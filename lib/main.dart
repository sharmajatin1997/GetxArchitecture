import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:getx_code_architecture/common_helper/shared_prefence_helper.dart';
import 'package:getx_code_architecture/constants/app_translations.dart';
import 'package:getx_code_architecture/routes/route_generator.dart';
import 'package:getx_code_architecture/routes/routes.dart';
import 'package:getx_code_architecture/theme/dark_theme.dart';
import 'package:getx_code_architecture/theme/light_theme.dart';

import 'constants/size_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.init();

  // Determine initial locale
  String? savedLang = SharedPreferenceHelper().getLanguageCode();
  Locale initialLocale = savedLang == "hi_IN"
      ? const Locale('hi', 'IN')
      : savedLang == "fr_FR"
      ? const Locale('fr', 'FR')
      : const Locale('en', 'US');

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    SizeHelper.init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro Product Explorer',

      // Themes
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Automatically follow system dark/light

      // Localization
      locale: initialLocale,
      translations: AppTranslations(),
      fallbackLocale: const Locale('en', 'US'),

      // Navigation
      initialRoute: Routes.productListScreen,
      onGenerateRoute: RoutesGenerator.generateRoute,
      navigatorObservers: [ClearFocusOnPush()],
    );
  }
}

/// Clears focus automatically when navigating
class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
