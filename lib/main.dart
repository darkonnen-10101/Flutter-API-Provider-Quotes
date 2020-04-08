import 'package:flutter/material.dart';
import 'package:quotespremium/src/networking/fetch_api.dart';
import 'package:quotespremium/src/providers/change_gradient.dart';
import 'src/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'src/pages/settings_page.dart';
import 'src/providers/change_background_color.dart';
import 'src/providers/change_language.dart';
import 'src/providers/change_quote_and_author.dart';
import 'src/providers/change_text_color.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChangeQuoteAndAuthor(),
        ),
        ChangeNotifierProvider(
          create: (context) => FetchApiClass(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeLanguage(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeTextColor(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeBackgroundColor(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeGradient(),
        ),
      ],
      child: MaterialApp(
        initialRoute: 'home',
        routes: {
          'home': (context) => HomePage(),
          'settings': (context) => SettingsPage(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Premium Quotes',
        // home: HomePage(),
      ),
    );
  }
}
