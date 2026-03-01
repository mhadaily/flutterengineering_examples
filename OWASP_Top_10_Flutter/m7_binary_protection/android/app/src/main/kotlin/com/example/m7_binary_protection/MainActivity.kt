package com.example.m7_binary_protection

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register all M7 binary protection plugins
        flutterEngine.plugins.add(SecretProvider())
        flutterEngine.plugins.add(IntegrityPlugin())
        flutterEngine.plugins.add(RootDetectionPlugin())
    }
}
