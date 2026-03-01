// ⚠️ BAD EXAMPLE — DO NOT USE IN PRODUCTION
//
// This demonstrates client-side-only license checking.
// A single byte-patch in libapp.so can make isPremiumUser
// always return true — no server needed.
//
// See: good_examples/license_service.dart for the right approach.

// Simulated API response
class LicenseResponse {
  final bool isValid;
  LicenseResponse({required this.isValid});
}

class MockApi {
  Future<LicenseResponse> verifyLicense(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return LicenseResponse(isValid: true);
  }
}

class TradeOrder {
  final String symbol;
  final double amount;
  TradeOrder({required this.symbol, required this.amount});
}

// ❌ BAD: Client-side-only premium check
class TradingFeaturesBad {
  bool isPremiumUser = false;
  final _api = MockApi();
  final String userId = 'user_123';

  Future<void> checkLicense() async {
    final response = await _api.verifyLicense(userId);
    // ❌ This boolean is stored in memory and controlled by the client.
    // An attacker can patch the branch instruction in the binary so that
    // executeAdvancedTrade() always takes the "premium" path.
    isPremiumUser = response.isValid;
  }

  void executeAdvancedTrade(TradeOrder order) {
    // ❌ Client-side gating — bypassed with a single binary patch
    if (!isPremiumUser) {
      _showUpgradeDialog();
      return;
    }
    _runProprietaryAlgorithm(order);
  }

  void _showUpgradeDialog() {
    // Show upgrade dialog
  }

  void _runProprietaryAlgorithm(TradeOrder order) {
    // ❌ Proprietary algorithm is also in the binary — extractable
  }
}
