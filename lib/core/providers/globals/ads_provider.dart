import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
 import 'package:provider/provider.dart';

import '../../resources/environment.dart';
import 'iap_provider.dart';

///All ad's functions related
class AdsProvider extends ChangeNotifier {
  late BuildContext _context;

  ///Initialize context, so you can access context inside the provider
  ///without passing it manually through params
  static void initialize(BuildContext context) {
    AdsProvider.read(context)._context = context;

    final params = ConsentRequestParameters();
    ConsentInformation.instance.requestConsentInfoUpdate(params, () {
      ConsentInformation.instance.isConsentFormAvailable().then((value) {
        loadForm();
      });
    }, (error) {});
  }

  ///Load consent form for ads
  static void loadForm() {
    ConsentForm.loadConsentForm((consentForm) async {
      if (await ConsentInformation.instance.getConsentStatus() == ConsentStatus.required) {
        consentForm.show((formError) {});
      }
    }, (formError) {});
  }

  ///Initialize and load interstitial ad,
  ///it will return [InterstitialAd] that you can use to show interstitial ad
  ///
  ///[null] if it fail to fetch
  Future<InterstitialAd?> loadInterstitial(String unitId) async {
    if (IAPProvider.read(_context).isPro) return null;
    Completer<InterstitialAd?> completer = Completer<InterstitialAd>();
    InterstitialAd.load(
      adUnitId: unitId,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(ad);
          FirebaseAnalytics.instance.logAdImpression();
        },
        onAdFailedToLoad: (error) {
          completer.complete();
        },
      ),
    );
    return completer.future;
  }

  ///Initialize and load open app ad,
  ///it will return [OpenAppAd] that you can use to show open app ad
  ///
  ///[null] if it fail to fetch
  Future<AppOpenAd?> loadOpenAd(String unitId) async {
    if (IAPProvider.read(_context).isPro) return null;
    Completer<AppOpenAd?> completer = Completer<AppOpenAd>();
    AppOpenAd.load(
      adUnitId: unitId,
      request: adRequest,
      // orientation: AppOpenAd.orientationPortrait,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(ad);
          FirebaseAnalytics.instance.logAdImpression();
        },
        onAdFailedToLoad: (error) {
          completer.complete();
        },
      ),
    );
    return completer.future;
  }

  ///Initialize and load reward ad,
  ///it will return [RewardedInterstitialAd] that you can use to show reward ad
  ///
  ///[null] if it fail to fetch
  Future<RewardedInterstitialAd?> loadRewardAd(String unitId) async {
    Completer<RewardedInterstitialAd?> completer = Completer();
    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: adRequest,
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          completer.complete(ad);
          FirebaseAnalytics.instance.logAdImpression();
        },
        onAdFailedToLoad: (error) {
          completer.complete();
        },
      ),
    );
    return completer.future;
  }

  ///Its banner static's functions
  ///
  ///It will load and fetch banner ad and show it as Widget
  ///return [SizedBox] if fail to fetch
  static Widget bannerAd(String unitId, {AdSize adsize = AdSize.banner}) {
    var banner = BannerAd(
      adUnitId: unitId,
      size: adsize,
      listener: BannerAdListener(
        onAdImpression: (ad) {
          FirebaseAnalytics.instance.logAdImpression();
        },
      ),
      request: adRequest,
    );
    return Consumer<IAPProvider>(
      builder: (context, value, child) => value.isPro ? const SizedBox.shrink() : child!,
      child: SizedBox(
        key: Key(unitId),
        height: adsize.height.toDouble(),
        width: adsize.width.toDouble(),
        child: FutureBuilder(
          future: banner.load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AdWidget(ad: banner);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  static AdsProvider read(BuildContext context) => context.read().._context = context;
  static AdsProvider watch(BuildContext context) => context.read().._context = context;
}
