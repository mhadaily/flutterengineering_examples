package com.example.m7_binary_protection

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

/**
 * SecretProvider — exposes secrets stored in native code to Dart via a MethodChannel.
 *
 * The actual secret values live in the companion JNI C++ library (see jni/secrets.cpp).
 * Native code (C++) is harder to reverse-engineer than Dart, and the XOR encoding in
 * C++ adds an extra layer of difficulty for static analysis tools like Ghidra.
 *
 * ⚠️  This is a speed bump, not a wall. A determined attacker can still find the secret
 * with enough time. Never ship secrets that don't need to be on the device at all —
 * prefer server-side config (SecureConfigService on the Dart side).
 *
 * Channel: com.example.m7/secrets
 * Methods:
 *   getApiKey              → String
 *   getModelDecryptionKey  → String (base64-encoded AES-256 key)
 */
class SecretProvider : FlutterPlugin {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "com.example.m7/secrets")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getApiKey" -> result.success(getApiKeyFromNative())
                "getModelDecryptionKey" -> result.success(getModelKeyFromNative())
                else -> result.notImplemented()
            }
        }
    }

    // Declared as external — implemented in jni/secrets.cpp
    private external fun getApiKeyFromNative(): String
    private external fun getModelKeyFromNative(): String

    companion object {
        init {
            System.loadLibrary("m7secrets")
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
