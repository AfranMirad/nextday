import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../config.dart';
import '../data/repositories.dart';

class MonetizationService extends ChangeNotifier {
  MonetizationService({AppRepository? repository})
      : _repo = repository ?? AppRepository();

  final AppRepository _repo;
  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSub;
  bool adsRemoved = false;
  bool iapAvailable = false;
  bool purchasePending = false;
  ProductDetails? removeAdsProduct;
  String? lastError;
  bool _adsSdkReady = false;

  Future<void> init() async {
    adsRemoved = (await _repo.getSetting('ads_removed')) == '1';
    if (AppConfig.adsEnabled) {
      try {
        await MobileAds.instance.initialize();
        _adsSdkReady = true;
      } catch (e) {
        lastError = e.toString();
      }
    }
    if (!kIsWeb) {
      iapAvailable = await _iap.isAvailable();
      if (iapAvailable) {
        _purchaseSub = _iap.purchaseStream.listen(
          _onPurchases,
          onError: (Object e) {
            lastError = e.toString();
            purchasePending = false;
            notifyListeners();
          },
        );
        await _loadProducts();
        await _iap.restorePurchases();
      }
    }
    notifyListeners();
  }

  bool get showAds => AppConfig.adsEnabled && _adsSdkReady && !adsRemoved;

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails({AppConfig.removeAdsProductId});
    if (response.productDetails.isNotEmpty) {
      removeAdsProduct = response.productDetails.first;
    }
    if (response.error != null) {
      lastError = response.error!.message;
    }
    notifyListeners();
  }

  Future<void> buyRemoveAds() async {
    if (adsRemoved) return;
    if (!iapAvailable || removeAdsProduct == null) {
      // Dev / store not configured: unlock locally so UI can be tested.
      if (kDebugMode) {
        await _setAdsRemoved(true);
        return;
      }
      lastError = 'Product not available';
      notifyListeners();
      return;
    }
    purchasePending = true;
    notifyListeners();
    final param = PurchaseParam(productDetails: removeAdsProduct!);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> restore() async {
    if (!iapAvailable) return;
    await _iap.restorePurchases();
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID != AppConfig.removeAdsProductId) continue;
      if (p.status == PurchaseStatus.pending) {
        purchasePending = true;
      } else {
        purchasePending = false;
        if (p.status == PurchaseStatus.purchased ||
            p.status == PurchaseStatus.restored) {
          await _setAdsRemoved(true);
        } else if (p.status == PurchaseStatus.error) {
          lastError = p.error?.message ?? 'purchase error';
        }
        if (p.pendingCompletePurchase) {
          await _iap.completePurchase(p);
        }
      }
    }
    notifyListeners();
  }

  Future<void> _setAdsRemoved(bool value) async {
    adsRemoved = value;
    await _repo.setSetting('ads_removed', value ? '1' : '0');
    notifyListeners();
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    super.dispose();
  }
}