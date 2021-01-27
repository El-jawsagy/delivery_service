import 'package:bosta_clone_app/pages/shipment/all_shipments_screen.dart';
import 'package:bosta_clone_app/services/all_states_enum.dart';
import 'package:bosta_clone_app/services/authentication.dart';
import 'package:bosta_clone_app/services/cities_provider.dart';
import 'package:bosta_clone_app/services/pickup_location_provider.dart';
import 'package:bosta_clone_app/services/pickup_provider.dart';
import 'package:bosta_clone_app/services/preson_pickup_location_provider.dart';
import 'package:bosta_clone_app/services/shipment_packge_type_provider.dart';
import 'package:bosta_clone_app/services/shipment_provider.dart';
import 'package:bosta_clone_app/utilities/data/prefrences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/auth/login_screen.dart';
import 'utilities/lang/applocate.dart';
import 'utilities/theme/custom_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => ShipmentsProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => PickUpProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => CitiesProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => PackageTypesProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => PickUpLocationProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => PersonPickUpLocationProvider(),
          ),
        ],
        child: Lang(),
      ),
    ),
  );
}

class Lang extends StatefulWidget {
  @override
  _LangState createState() => _LangState();
}

class _LangState extends State<Lang> {
  chooseLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("lang") == null) {
      prefs.setString("lang", "ar");
      return Locale(prefs.getString("lang"), '');
    } else {
      return Locale(prefs.getString("lang"), '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chooseLang(),
        builder: (context, snapshot) {
          return MyApp(snapshot.data);
        });
  }
}

class MyApp extends StatelessWidget {
  final Locale locale;

  MyApp(this.locale);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        AppLocale.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      locale: this.locale,
      localeResolutionCallback: (currentLocale, supportedLocales) {
        if (currentLocale != null) {
          print(currentLocale.countryCode);
          for (Locale locale in supportedLocales) {
            if (currentLocale.languageCode == locale.languageCode) {
              return currentLocale;
            }
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        primaryColor: CustomColors.primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _showScreen(context),
    );
  }

  Widget _showScreen(context) {
    var authenticationProvider = Provider.of<AuthProvider>(context);
    if (authenticationProvider.token == null || authenticationProvider.token == "null") {
      return LoginPage();
    } else {
      if (authenticationProvider.user == null) {
        if (authenticationProvider.state == AuthStates.unAuthenticated) {
          authenticationProvider.getUser(Preference.getToken());
          Future.delayed(Duration(seconds: 3));
        }
      }
      return ShipmentsPage();
    }
  }
}
