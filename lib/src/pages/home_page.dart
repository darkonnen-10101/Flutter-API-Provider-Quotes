import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:quotespremium/src/admob/admob_config.dart';
import 'package:quotespremium/src/data/languages_list.dart';
import 'package:quotespremium/src/providers/change_background_color.dart';
import 'package:quotespremium/src/providers/change_gradient.dart';
import 'package:quotespremium/src/providers/change_quote_and_author.dart';
import 'package:quotespremium/src/providers/change_text_color.dart';
import 'package:quotespremium/src/widgets/fancy_fab.dart';
import 'package:quotespremium/src/widgets/privacy_policy.dart';
import 'package:quotespremium/src/widgets/static_admob_banner.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:linear_gradient/linear_gradient.dart';
import 'package:share/share.dart';
import 'package:admob_flutter/admob_flutter.dart';

class HomePage extends StatefulWidget {
  static ScreenshotController screenshotController = ScreenshotController();
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static AdmobBannerSize bannerSize = AdmobBannerSize.FULL_BANNER;

  static String _drawerImage = 'assets/images/premiumQuotes.jpg';
  static String _appBarName = 'Premium Quotes';
  static String _appShare =
      'Check this app! https://play.google.com/store/apps/details?id=com.mundodiferente.premiumquotes';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PermissionStatus _status;

  final List languages = Languages.languages;
  final List abreviatedLang = Languages.abreviatedLang;

  final AdmobBannerWrapper fixedAdmobBanner = AdmobBannerWrapper(
    adSize: HomePage.bannerSize,
    adUnitId: getBannerAdUnitId(),
  );

  AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();

    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatus);

    // bannerSize = AdmobBannerSize.FULL_BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );

    interstitialAd.load();
  }

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(
        () {
          _status = status;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ChangeQuoteAndAuthor changeTextQuoteAuthor =
        Provider.of<ChangeQuoteAndAuthor>(context);

    // Text color
    ChangeTextColor textColorProvider = Provider.of<ChangeTextColor>(context);
    Color _textColor = textColorProvider.colorBase;

    // Background color
    ChangeBackgroundColor backgroundColorProvider =
        Provider.of<ChangeBackgroundColor>(context);
    Color _backgroundColor = backgroundColorProvider.backgroundBase;

    ChangeGradient _gradientConfig = Provider.of<ChangeGradient>(context);

    Future<void> _displayDialog(BuildContext context) async {
      return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return PrivacyPolicy();
          });
    }

    String capitalize(String string) {
      if (string == null) {
        throw ArgumentError("string: $string");
      }

      if (string.isEmpty) {
        return string;
      }

      return string[0].toUpperCase() + string.substring(1);
    }

    Widget _titleQuote() {
      return changeTextQuoteAuthor.quoteContent == null
          ? Center(
              child: new RichText(
                text: new TextSpan(children: [
                  TextSpan(
                    text: 'Press the ',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  WidgetSpan(
                    child: new Icon(Icons.play_arrow,
                        size: 50.0, color: _textColor),
                  ),
                  TextSpan(
                    text: ' button.',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ]),
              ),
            )
          : Text(
              '\' ${capitalize(utf8.decode(changeTextQuoteAuthor.quoteContent.runes.toList()))} \'',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            );
    }

    Widget _subtitleQuote() {
      return changeTextQuoteAuthor.quoteContent == null
          ? Center(
              child: new RichText(
                text: new TextSpan(children: [
                  TextSpan(
                    text: 'Inside the ',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  WidgetSpan(
                    child: new Icon(Icons.menu, size: 30.0, color: _textColor),
                  ),
                  TextSpan(
                    text: ' menu.',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ]),
              ),
            )
          : Text(
              '${utf8.decode(changeTextQuoteAuthor.quoteAuthor.runes.toList())}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _textColor,
                fontWeight: FontWeight.w300,
                fontSize: 22.0,
              ),
            );
    }

    Widget _doubleContainer() {
      return Center(
        child: ListView(
          padding: EdgeInsets.all(
            60.0,
          ),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            _titleQuote(),
            SizedBox(
              height: 40.0,
            ),
            _subtitleQuote(),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Image(
                    image: AssetImage(
                      HomePage._drawerImage,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                  ),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  trailing: Icon(
                    Icons.library_books,
                    color: Colors.black,
                  ),
                  title: Text('Privacy Policy'),
                  onTap: () {
                    Navigator.pop(context);

                    _displayDialog(context);
                  },
                ),
                ListTile(
                  trailing: Icon(
                    Icons.share,
                    color: Colors.black,
                  ),
                  title: Text('Share App'),
                  onTap: () {
                    Share.share(HomePage._appShare);
                  },
                ),
                ListTile(
                  trailing: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: Text('Exit'),
                  onTap: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
        key: HomePage.scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: Text(
            HomePage._appBarName,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: _backgroundColor,
        ),
        // fixedAdmobBanner

        /*
                    Card(
              elevation: 10.0,
              child: fixedAdmobBanner,
            ),

        */

        body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Screenshot(
              controller: HomePage.screenshotController,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                  maxHeight: double.infinity,
                ),
                //height: double.infinity,
//                height: MediaQuery.of(context).size.height,

                decoration: //_gradientContainer == true ?
                    BoxDecoration(
                  border: Border.all(
                    color: _textColor,
                    width: 10.0,
                  ),
                  gradient: LinearGradientStyle.linearGradient(
                      orientation: _gradientConfig.gradientOrientation,
                      gradientType: _gradientConfig.gradientColor),
                ),
                child:
                    _doubleContainer(), /*ListView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(
                    65.0,
                  ),
                  children: <Widget>[
                    _titleQuote(),
                    _subtitleQuote(),
                  ],
                ),*/
              ),
            ),
          ),
        ),
        floatingActionButton: FancyFab(),
      ),
    );
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }
}
