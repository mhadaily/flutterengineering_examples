# ProGuard / R8 rules for release builds.
# Referenced from build.gradle release buildType.

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Keep app entry point
-keep class com.example.m8_security_misconfiguration.** { *; }
