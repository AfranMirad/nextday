import 'dart:async';

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

class _BannerAdSlotState extends State<BannerAdSlot>
    with WidgetsBindingObserver {
  BannerAd? _banner;
  bool _loaded = false;
  bool _leftForAd = false;
  Timer? _reloadTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureBanner());
  }

  @override
  void dispose() {
    _reloadTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _disposeBanner();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _leftForAd) {
      _leftForAd = false;
      // Recreate after returning from an external app (e.g. YouTube) so the
      // click intent is not re-delivered into the same AdWidget.
      _disposeBanner();
      _reloadTimer?.cancel();
      _reloadTimer = Timer(const Duration(milliseconds: 800), () {
        if (mounted) _ensureBanner();
      });
    }
  }

  void _disposeBanner() {
    _banner?.dispose();
    _banner = null;
    _loaded = false;
  }

  void _ensureBanner() {
    if (kIsWeb || !mounted) return;
    final mono = context.read<MonetizationService>();
    if (!mono.showAds) {
      if (_banner != null) {
        setState(_disposeBanner);
      }
      return;
    }
    if (_banner != null) return;

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
        onAdOpened: (ad) {
          _leftForAd = true;
        },
        onAdClosed: (ad) {
          _leftForAd = false;
          _disposeBanner();
          _reloadTimer?.cancel();
          _reloadTimer = Timer(const Duration(milliseconds: 600), () {
            if (mounted) {
              setState(() {});
              _ensureBanner();
            }
          });
        },
        onAdClicked: (ad) {
          _leftForAd = true;
        },
      ),
      request: const AdRequest(),
    );
    _banner = ad;
    ad.load();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mono = context.watch<MonetizationService>();
    if (!mono.showAds) {
      if (_banner != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(_disposeBanner);
        });
      }
      return const SizedBox.shrink();
    }

    if (_banner == null && !_leftForAd) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensureBanner());
    }

    if (!_loaded || _banner == null) {
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
