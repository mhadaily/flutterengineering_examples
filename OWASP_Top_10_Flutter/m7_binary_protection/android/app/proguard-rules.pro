# ProGuard / R8 rules for m7_binary_protection example
#
# Flutter's Dart code is obfuscated by --obfuscate at build time.
# These rules protect the Kotlin/Java layer (plugins, platform channels).
#
# NOTE: The directive -optimizationpasses is ignored by R8 (Android's default
# shrinker since AGP 3.4). R8 determines the optimal number of passes itself.
# See: https://r8.googlesource.com/r8/+/refs/heads/main/compatibility-faq.md

# ---- Flutter engine classes (must not be renamed) ----
-keep class io.flutter.app.**         { *; }
-keep class io.flutter.plugin.**      { *; }
-keep class io.flutter.util.**        { *; }
-keep class io.flutter.view.**        { *; }
-keep class io.flutter.**             { *; }
-keep class io.flutter.plugins.**     { *; }

# ---- Our own plugin classes referenced from Dart via MethodChannel ----
-keep class com.example.m7_binary_protection.SecretProvider      { *; }
-keep class com.example.m7_binary_protection.IntegrityPlugin     { *; }
-keep class com.example.m7_binary_protection.RootDetectionPlugin { *; }

# ---- JNI — native method names must be preserved so the linker finds them ----
-keepclasseswithmembernames class * {
    native <methods>;
}

# ---- Aggressively obfuscate and repackage everything else ----
-repackageclasses ''
-allowaccessmodification
-dontskipnonpubliclibraryclasses

# ---- Keep source file names and line numbers in crash traces ----
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# ---- Suppress warnings for optional Play Core classes (not in apk) ----
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
