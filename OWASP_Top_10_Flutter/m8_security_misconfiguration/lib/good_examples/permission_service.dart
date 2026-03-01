/// GOOD EXAMPLE — Runtime permission requests with user explanation.
///
/// From the article section "Excessive Permissions".
/// Demonstrates asking only for permissions the app needs, explaining
/// *why* before the system dialog appears.
library;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Requests camera permission with an explanation dialog.
  ///
  /// Flow:
  /// 1. Check current status (already granted? → return true).
  /// 2. If denied, show an explanation dialog first.
  /// 3. If permanently denied, guide user to Settings.
  ///
  /// Console output (example):
  /// ```
  /// [Permission] Camera status: PermissionStatus.denied
  /// [Permission] Showing explanation dialog…
  /// [Permission] User accepted explanation — requesting camera…
  /// [Permission] Camera result: PermissionStatus.granted ✅
  /// ```
  Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    print('[Permission] Camera status: $status');

    if (status.isGranted) return true;

    if (status.isDenied) {
      print('[Permission] Showing explanation dialog…');
      final shouldRequest = await _showPermissionExplanation(
        context,
        title: 'Camera Permission Required',
        explanation:
            'We need camera access to scan QR codes for secure login. '
            'Your camera feed is processed locally and never stored or transmitted.',
        icon: Icons.camera_alt,
      );

      if (!shouldRequest) {
        print('[Permission] User declined explanation dialog.');
        return false;
      }

      print('[Permission] User accepted explanation — requesting camera…');
      final result = await Permission.camera.request();
      print('[Permission] Camera result: $result '
          '${result.isGranted ? "✅" : "❌"}');
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      print('[Permission] Permanently denied — directing to Settings.');
      await _showSettingsDialog(context, 'camera');
      return false;
    }

    return false;
  }

  // ---------------------------------------------------------------------------
  // UI helpers
  // ---------------------------------------------------------------------------

  Future<bool> _showPermissionExplanation(
    BuildContext context, {
    required String title,
    required String explanation,
    required IconData icon,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(child: Text(title)),
              ],
            ),
            content: Text(explanation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Not Now'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showSettingsDialog(
    BuildContext context,
    String permission,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(
          'The $permission permission was denied. '
          'Please enable it in Settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
