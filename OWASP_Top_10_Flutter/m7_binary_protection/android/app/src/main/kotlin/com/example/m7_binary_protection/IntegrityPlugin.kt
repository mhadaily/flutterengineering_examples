package com.example.m7_binary_protection

import android.content.pm.PackageManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.security.MessageDigest

/**
 * IntegrityPlugin — signature verification, binary hash check, and debugger/Frida detection.
 *
 * Channel: com.example.m7/integrity
 * Methods:
 *   verifySignature     → Boolean
 *   getSignatureHash    → String (SHA-256 hex fingerprint, colon-separated)
 *   getLibappHash       → String (SHA-256 hex of libapp.so)
 *   isDebuggerAttached  → Boolean
 */
class IntegrityPlugin : FlutterPlugin {
    private lateinit var channel: MethodChannel
    private lateinit var appContext: android.content.Context

    // Add your release signing certificate SHA-256 fingerprint here.
    // Generate it with:
    //   keytool -printcert -jarfile your-release.apk | grep SHA256
    private val validSignatures = listOf(
        "REPLACE_WITH_YOUR_RELEASE_CERT_SHA256_COLON_HEX"
    )

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.example.m7/integrity")

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "verifySignature" -> result.success(verifyAppSignature())
                "getSignatureHash" -> result.success(getAppSignatureHash())
                "getLibappHash" -> result.success(computeLibappHash())
                "isDebuggerAttached" -> result.success(isDebuggerOrFridaPresent())
                else -> result.notImplemented()
            }
        }
    }

    // -------------------------------------------------------------------------
    // Signature verification
    // -------------------------------------------------------------------------

    private fun verifyAppSignature(): Boolean {
        val currentHash = getAppSignatureHash() ?: return false
        return validSignatures.contains(currentHash)
    }

    private fun getAppSignatureHash(): String? {
        return try {
            val packageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                appContext.packageManager.getPackageInfo(
                    appContext.packageName,
                    PackageManager.GET_SIGNING_CERTIFICATES
                )
            } else {
                @Suppress("DEPRECATION")
                appContext.packageManager.getPackageInfo(
                    appContext.packageName,
                    PackageManager.GET_SIGNATURES
                )
            }

            val signatures = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageInfo.signingInfo?.apkContentsSigners
            } else {
                @Suppress("DEPRECATION")
                packageInfo.signatures
            }

            val signature = signatures?.firstOrNull() ?: return null
            val digest = MessageDigest.getInstance("SHA-256").digest(signature.toByteArray())
            digest.joinToString(":") { "%02X".format(it) }
        } catch (e: Exception) {
            null
        }
    }

    // -------------------------------------------------------------------------
    // Binary hash (libapp.so)
    // -------------------------------------------------------------------------

    private fun computeLibappHash(): String? {
        return try {
            // nativeLibraryDir is the correct runtime path — DO NOT hardcode it.
            val nativeDir = appContext.applicationInfo.nativeLibraryDir
            val libapp = File("$nativeDir/libapp.so")
            if (!libapp.exists()) return null

            val digest = MessageDigest.getInstance("SHA-256")
            libapp.inputStream().use { stream ->
                val buffer = ByteArray(8192)
                var bytesRead: Int
                while (stream.read(buffer).also { bytesRead = it } != -1) {
                    digest.update(buffer, 0, bytesRead)
                }
            }
            digest.digest().joinToString("") { "%02x".format(it) }
        } catch (e: Exception) {
            null
        }
    }

    // -------------------------------------------------------------------------
    // Debugger and Frida detection
    // -------------------------------------------------------------------------

    private fun isDebuggerOrFridaPresent(): Boolean {
        // Standard debugger check
        if (android.os.Debug.isDebuggerConnected() || android.os.Debug.waitingForDebugger()) {
            return true
        }

        // Frida server listens on port 27042 by default
        try {
            val socket = java.net.Socket("127.0.0.1", 27042)
            socket.close()
            return true
        } catch (_: Exception) {
            // Port not open — good
        }

        // Check /proc/self/maps for frida-agent or frida-gadget
        try {
            val maps = File("/proc/self/maps").readText()
            if (maps.contains("frida") || maps.contains("gadget")) {
                return true
            }
        } catch (_: Exception) {
            // Could not read maps
        }

        return false
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
