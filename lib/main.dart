import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:country_codes/country_codes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';
import 'package:thunder_vpn/root.dart';

import 'core/providers/globals/ads_provider.dart';
import 'core/providers/globals/connected_server.dart';
import 'core/providers/globals/iap_provider.dart';
import 'core/providers/globals/theme_provider.dart';
import 'core/providers/globals/vpn_provider.dart';
import 'core/resources/environment.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/resources/themes.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  /// supabase initialization
  await Supabase.initialize(
    url: supaBaseURL,
    anonKey: supaBaseAnonKey,
  );
  await Future.wait([
    CountryCodes.init(),
    EasyLocalization.ensureInitialized(),
    MobileAds.instance.initialize(),
    AppTrackingTransparency.requestTrackingAuthorization(),
  ].map((e) => Future.microtask(() => e)));

  return runApp(
    EasyLocalization(
      path: 'assets/languages',
      supportedLocales: supportedLocales,
      fallbackLocale: const Locale('en', 'US'),
      saveLocale: true,
      useOnlyLangCode: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => VpnProvider()..initialize(context)),
          ChangeNotifierProvider(create: (context) => IAPProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => AdsProvider()),
          ChangeNotifierProvider(create: (context) => ConnectedServerProvider()),
        ],
        builder: (context, child) => MaterialApp(
          themeMode: ThemeProvider.watch(context).themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          debugShowCheckedModeBanner: false,
          title: appName,
          home: const Root(),
        ),
      ),
    ),
  );
}
