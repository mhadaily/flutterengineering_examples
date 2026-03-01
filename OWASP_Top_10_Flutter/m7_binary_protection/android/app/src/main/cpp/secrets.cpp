/**
 * secrets.cpp — Native secrets stored in C++ with XOR encoding.
 *
 * C++ is significantly harder to reverse-engineer with automated tools than Dart.
 * The XOR encoding means the API key is never present as a readable string in the
 * binary — an attacker with `strings` or Ghidra has to work harder to find it.
 *
 * Build this into libm7secrets.so by adding the following to your CMakeLists.txt:
 *
 *   cmake_minimum_required(VERSION 3.10)
 *   project("m7secrets")
 *   add_library(m7secrets SHARED secrets.cpp)
 *   find_library(log-lib log)
 *   target_link_libraries(m7secrets ${log-lib})
 *
 * And in android/app/build.gradle:
 *   android {
 *     defaultConfig {
 *       externalNativeBuild { cmake { cppFlags "-std=c++17" } }
 *     }
 *     externalNativeBuild {
 *       cmake { path "src/main/cpp/CMakeLists.txt" }
 *     }
 *   }
 *
 * How the encoding works:
 *   Each byte of the plaintext is XOR'd with the mask byte (0x5A).
 *   To generate new encoded values for your own secrets, run:
 *
 *     python3 -c "
 *     mask = 0x5A
 *     secret = b'sk-prod-your-real-key-here'
 *     print(', '.join(f'0x{b ^ mask:02X}' for b in secret))
 *     "
 *
 *   Replace the encoded[] array below with the output.
 *
 * ⚠️  REMINDER: this is still extractable by a determined attacker with a debugger.
 * Prefer not shipping the secret at all — use SecureRemoteConfig on the Dart side.
 */

#include <jni.h>
#include <string>

// XOR mask — change this to any non-zero byte for your own builds
static constexpr unsigned char kMask = 0x5A;

// Encoded "sk-prod" (placeholder — replace with your real encoded key bytes)
static constexpr unsigned char kEncodedApiKey[] = {
    0x29, 0x31, 0x77, 0x2A, 0x28, 0x35, 0x3E
    //  s     k     -     p     r     o     d
};

// Encoded base64 key (placeholder — replace with your real model key bytes)
static constexpr unsigned char kEncodedModelKey[] = {
    0x1E, 0x3E, 0x28, 0x33, 0x29, 0x35, 0x27
    //  D     E     M     O     K     E     Y
};

static std::string xorDecode(const unsigned char* encoded, size_t len) {
    std::string result;
    result.reserve(len);
    for (size_t i = 0; i < len; ++i) {
        result += static_cast<char>(encoded[i] ^ kMask);
    }
    return result;
}

extern "C" {

JNIEXPORT jstring JNICALL
Java_com_example_m7_1binary_1protection_SecretProvider_getApiKeyFromNative(
        JNIEnv* env, jobject /* thiz */) {
    auto decoded = xorDecode(kEncodedApiKey, sizeof(kEncodedApiKey));
    return env->NewStringUTF(decoded.c_str());
}

JNIEXPORT jstring JNICALL
Java_com_example_m7_1binary_1protection_SecretProvider_getModelKeyFromNative(
        JNIEnv* env, jobject /* thiz */) {
    auto decoded = xorDecode(kEncodedModelKey, sizeof(kEncodedModelKey));
    return env->NewStringUTF(decoded.c_str());
}

} // extern "C"
