package com.example.m7_binary_protection

import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * RootDetectionPlugin — checks multiple indicators of root access or device tampering.
 *
 * Tools like Magisk actively attempt to hide root indicators, which is why we check
 * several heuristics rather than relying on any single test.
 *
 * Channel: com.example.m7/root_detection
 * Methods:
 *   checkRoot  → Map<String, Boolean>  (Android)
 */
class RootDetectionPlugin : FlutterPlugin {
    private lateinit var channel: MethodChannel
    private lateinit var appContext: android.content.Context

    // Common su binary locations
    private val suPaths = listOf(
        "/system/app/Superuser.apk",
        "/sbin/su",
        "/system/bin/su",
        "/system/xbin/su",
        "/data/local/xbin/su",
        "/data/local/bin/su",
        "/system/sd/xbin/su",
        "/system/bin/failsafe/su",
        "/data/local/su",
        "/su/bin/su"
    )

    // Known root management packages
    private val rootPackages = listOf(
        "com.noshufou.android.su",
        "com.noshufou.android.su.elite",
        "eu.chainfire.supersu",
        "com.koushikdutta.superuser",
        "com.thirdparty.superuser",
        "com.yellowes.su",
        "com.topjohnwu.magisk"
    )

    // Packages that try to hide root from other apps
    private val rootCloakingPackages = listOf(
        "com.devadvance.rootcloak",
        "com.devadvance.rootcloakplus",
        "de.robv.android.xposed.installer",
        "com.saurik.substrate",
        "com.zachspong.temprootremovejb",
        "com.amphoras.hidemyroot"
    )

    // Magisk-specific paths
    private val magiskPaths = listOf(
        "/sbin/.magisk",
        "/data/adb/magisk",
        "/data/adb/modules"
    )

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.example.m7/root_detection")

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkRoot" -> result.success(
                    mapOf(
                        "suBinaryExists" to checkSuBinary(),
                        "superuserApkExists" to File("/system/app/Superuser.apk").exists(),
                        "rootCloakingApps" to checkRootCloakingApps(),
                        "testKeysBuild" to checkTestKeys(),
                        "dangerousProps" to checkDangerousProps(),
                        "rwSystem" to checkRwSystem(),
                        "magiskDetected" to checkMagisk()
                    )
                )
                else -> result.notImplemented()
            }
        }
    }

    private fun checkSuBinary(): Boolean = suPaths.any { File(it).exists() }

    private fun checkRootCloakingApps(): Boolean {
        val pm = appContext.packageManager
        return (rootPackages + rootCloakingPackages).any { pkg ->
            try { pm.getPackageInfo(pkg, 0); true } catch (_: Exception) { false }
        }
    }

    private fun checkTestKeys(): Boolean {
        val tags = Build.TAGS ?: return false
        return tags.contains("test-keys")
    }

    private fun checkDangerousProps(): Boolean {
        // Checks ro.debuggable=1 and ro.secure=0 via system properties
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("getprop", "ro.debuggable"))
            val value = process.inputStream.bufferedReader().readLine()?.trim()
            value == "1"
        } catch (_: Exception) {
            false
        }
    }

    private fun checkRwSystem(): Boolean {
        return try {
            val output = Runtime.getRuntime().exec("mount")
                .inputStream.bufferedReader().readText()
            output.contains(Regex("""/system\s.*\brw\b"""))
        } catch (_: Exception) {
            false
        }
    }

    private fun checkMagisk(): Boolean = magiskPaths.any { File(it).exists() }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
