import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../services/monetization_service.dart';
import '../theme/app_theme.dart';

class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _banner;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mono = context.watch<MonetizationService>();
    if (!mono.showAds) {
      _banner?.dispose();
      _banner = null;
      _loaded = false;
      return;
    }
    if (_banner == null && !kIsWeb) {
      final ad = BannerAd(
        size: AdSize.banner,
        adUnitId: AppConfig.bannerAdUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) setState(() => _loaded = true);
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _banner = null;
                _loaded = false;
              });
            }
          },
        ),
        request: const AdRequest(),
      );
      _banner = ad;
      ad.load();
    }
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mono = context.watch<MonetizationService>();
    if (!mono.showAds || !_loaded || _banner == null) {
      return const SizedBox.shrink();
    }
    return ColoredBox(
      color: AppTheme.card(context),
      child: SizedBox(
        width: _banner!.size.width.toDouble(),
        height: _banner!.size.height.toDouble(),
        child: AdWidget(ad: _banner!),
      ),
    );
  }
}