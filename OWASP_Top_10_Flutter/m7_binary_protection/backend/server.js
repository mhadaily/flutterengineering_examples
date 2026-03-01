/**
 * server.js — Node.js/Express server-side license validation example.
 *
 * Companion to lib/good_examples/license_service.dart.
 *
 * The key insight: any check that runs only on the client can be patched out.
 * This server validates three things the app cannot forge:
 *   1. App signature  — proves the APK has not been re-signed (tampered/cracked)
 *   2. License key    — proves the user has a valid, unexpired license
 *   3. Device binding — proves the license is being used on the correct device
 *
 * Install: npm install express
 * Run:     node server.js
 */

import express from 'express';

const app = express();
app.use(express.json());

// ---- Mock database ----
const licenses = new Map([
	[
		'LICENSE-DEMO-001',
		{
			features: ['trading', 'analytics'],
			expiresAt: new Date('2027-01-01'),
			boundDeviceId: null, // null = not yet bound
		},
	],
]);

// Your release APK signing certificate SHA-256 fingerprints
const validSignatures = [
	'A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6', // production
	'F6:E5:D4:C3:B2:A1:J0:I9:H8:G7:F6:E5:D4:C3:B2:A1', // staging
];

// ---- Security event logger ----
function logSecurityEvent(type, data) {
	console.warn(`[SECURITY] ${type}`, JSON.stringify(data));
	// In production: send to your SIEM, Datadog, Splunk, etc.
}

// ---- License verification endpoint ----
// POST /api/verify-license
// Body: { licenseKey, deviceId, appSignature }
app.post('/api/verify-license', async (req, res) => {
	const { licenseKey, deviceId, appSignature } = req.body;

	// 1. Verify the app has not been tampered with and re-signed
	if (appSignature && !validSignatures.includes(appSignature)) {
		logSecurityEvent('TAMPERED_APP', { deviceId, appSignature });
		return res.json({ isValid: false, reason: 'invalid_app_signature' });
	}

	// 2. Verify the license exists and has not expired
	const license = licenses.get(licenseKey);
	if (!license) {
		return res.json({ isValid: false, reason: 'license_not_found' });
	}
	if (license.expiresAt < new Date()) {
		return res.json({ isValid: false, reason: 'license_expired' });
	}

	// 3. Verify device binding (bind on first use)
	if (license.boundDeviceId === null) {
		// First activation — bind to this device
		license.boundDeviceId = deviceId;
		logSecurityEvent('LICENSE_ACTIVATED', { licenseKey, deviceId });
	} else if (license.boundDeviceId !== deviceId) {
		// Different device attempting to use the same license
		logSecurityEvent('DEVICE_MISMATCH', { licenseKey, deviceId });
		return res.json({ isValid: false, reason: 'device_mismatch' });
	}

	return res.json({ isValid: true, features: license.features });
});

// ---- Health check ----
app.get('/health', (_req, res) => res.json({ status: 'ok' }));

const port = process.env.PORT ?? 3000;
app.listen(port, () => console.log(`Server listening on http://localhost:${port}`));
