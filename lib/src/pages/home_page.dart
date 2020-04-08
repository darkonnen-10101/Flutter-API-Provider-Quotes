/*
import 'dart:io';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:quotespremium/src/models/data_quote.dart';
import 'package:quotespremium/src/networking/fetch_api.dart';
import 'package:quotespremium/src/pages/settings_page.dart';
import 'package:quotespremium/src/providers/change_language.dart';
import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:quotespremium/src/data/languages_list.dart';
import 'package:quotespremium/src/providers/change_background_color.dart';
import 'package:quotespremium/src/providers/change_gradient.dart';
import 'package:quotespremium/src/providers/change_quote_and_author.dart';
import 'package:quotespremium/src/providers/change_text_color.dart';
import 'package:quotespremium/src/widgets/fancy_fab.dart';
import 'package:quotespremium/src/widgets/privacy_policy.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:linear_gradient/linear_gradient.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  static ScreenshotController screenshotController = ScreenshotController();
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Screenshot
  // Screenshot

  PermissionStatus _status;

  final List languages = Languages.languages;
  final List abreviatedLang = Languages.abreviatedLang;

  @override
  void initState() {
    super.initState();

    // fetchQuote(); ======================================================>>>>>>>>>>>>>> IMPORTANT ! ! !
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatus);
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

/*
  void _askPermission() {
    PermissionHandler()
        .requestPermissions([PermissionGroup.storage]).then(_onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
    final status = statuses[PermissionGroup.storage];
    if (status != PermissionStatus.granted) {
      // PermissionHandler().openAppSettings();
    } else {
      _updateStatus(status);
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    ChangeQuoteAndAuthor changeTextQuoteAuthor =
        Provider.of<ChangeQuoteAndAuthor>(context);

    // Language
    // ChangeLanguage _currentLanguage = Provider.of<ChangeLanguage>(context);

    // Text color
    ChangeTextColor textColorProvider = Provider.of<ChangeTextColor>(context);
    Color _textColor = textColorProvider.colorBase;
    // Color _currentTextColor = textColorProvider.colorBase;

    // Background color
    ChangeBackgroundColor backgroundColorProvider =
        Provider.of<ChangeBackgroundColor>(context);
    Color _backgroundColor = backgroundColorProvider.backgroundBase;

    ChangeGradient _gradientConfig = Provider.of<ChangeGradient>(context);

/*
    // Progress Dialog
    ProgressDialog pr;

    pr = new ProgressDialog(context);
    pr.style(
        message: 'Loading...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    // Progress Dialog

    Future fetchQuote() async {
      final response = await http.get(
        'https://quotes15.p.rapidapi.com/quotes/random/?language_code=${_currentLanguage.language}',
        headers: {
          "x-rapidapi-host": "quotes15.p.rapidapi.com",
          "x-rapidapi-key":
              "e9492e81femsh34b99eb6aa85e90p1311eejsnce09d6dad505",
        },
      );

      data = json.decode(response.body);
      /*
  print(Quote.fromJson(responseJson).content);
  print(Quote.fromJson(responseJson).originator.name);
  print(Quote.fromJson(responseJson).language);
*/
      if (response.statusCode == 200) {
        // return Quote.fromJson(responseJson);
        setState(() {
          quote = data["content"];
          author = data["originator"]["name"];
        });
      } else {
        throw Exception('Failed to load data from API');
      }
    }

 */
/*

    Future hitApi() async {
      Provider.of<FetchApiClass>(context, listen: false)
          .setLang(_currentLanguage.language);
      DataQuote dataQuote =
          await Provider.of<FetchApiClass>(context, listen: false).fetchQuote();
      Provider.of<FetchApiClass>(context, listen: false)
          .setDataQuote(dataQuote);
      setState(() {
        changeTextQuoteAuthor.setQuoteContent = dataQuote.content;

        changeTextQuoteAuthor.setQuoteAuthor = dataQuote.originator.name;
      });
    }

    void showFetch() {
      // fetchQuote();
      hitApi();
      pr.show();
      Future.delayed(Duration(
        milliseconds: 1500,
      )).then((value) {
        pr.hide().whenComplete(() {});
      });
    }

    void _displaySnackBar(BuildContext context) {
      final snackBar = SnackBar(
        content: Text(
          'Image Saved to Gallery',
        ),
      );
      HomePage.scaffoldKey.currentState.showSnackBar(snackBar);
    }

    // void changeBackgroundColor(Color color) =>         setState(() => _currentBackgroundColor = color);

    Future<void> _displayDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          int selectedRadio = 0;
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List<Widget>.generate(11, (int index) {
                      return RadioListTile<int>(
                        dense: true,
                        title: Text(
                          '${languages[index]}',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        value: index,
                        groupValue: selectedRadio,
                        onChanged: (int value) {
                          setState(() => selectedRadio = value);
                        },
                      );
                    }),
                  ),
                );
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Ok',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(
                    () {
                      _currentLanguage.languageTraduction =
                          abreviatedLang[selectedRadio];
                      showFetch();
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    }
*/

    Future<void> _displayDialog(BuildContext context) async {
      return showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            int selectedRadio = 0;
            return PrivacyPolicy();
          });
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
                      'assets/images/premiumQuotes.jpg',
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
                    Share.share(
                        'Check this app! https://play.google.com/store/apps/details?id=com.mundodiferente.premiumquotes');
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
          actions: <Widget>[],
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: Text(
            'Premium Quotes',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: _backgroundColor,
        ),
        body: Screenshot(
          controller: HomePage.screenshotController,
          child: Container(
            height: MediaQuery.of(context).size.height,
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
            child: Center(
              child: ListView(
                //physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //primary: false,
                padding: EdgeInsets.only(
                  right: 15.0,
                  left: 15.0,
                ),
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),

                  changeTextQuoteAuthor.quoteContent == null
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
                          /*changeTextQuoteAuthor.quoteContent == null
                        ? 'Press the Play button'
                        :*/
                          '\' ${utf8.decode(changeTextQuoteAuthor.quoteContent.runes.toList())} \'',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                  SizedBox(
                    height: 30.0,
                  ),

                  changeTextQuoteAuthor.quoteContent == null
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
                                child: new Icon(Icons.menu,
                                    size: 30.0, color: _textColor),
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
                        ),
                  SizedBox(
                    height: 150.0,
                  ),
                  // _imageFile != null ? Image.file(_imageFile) : Container(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton:
            FancyFab(), /*Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'language',
              child: Icon(
                Icons.language,
              ),
              onPressed: () {
                _displayDialog(context);
              },
            ),
            SizedBox(
              width: 20.0,
            ),
            FloatingActionButton(
              heroTag: 'settings',
              child: Icon(
                Icons.color_lens,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SettingsPage(),
                  ),
                );
              },
            ),
            SizedBox(
              width: 20.0,
            ),
            FloatingActionButton(
              heroTag: 'textColor',
              child: Icon(
                Icons.text_fields,
              ),
              onPressed: () {
                // backgroundColorProvider.backgroundColor = _chosenColor;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ColorPicker(
                              pickerColor: textColorProvider.colorBase,
                              onColorChanged: changeTextColor,
                              colorPickerWidth: 300.0,
                              pickerAreaHeightPercent: 0.3,
                              enableAlpha: true,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.hsv,
                              pickerAreaBorderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                              ),
                            ),
                            Text(
                              'Fuente de letra',
                            ),
                            Text(
                              'Tamaño de letra',
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                            child: Text(
                              'Change color',
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() => textColorProvider.textColor =
                                  _currentTextColor);
                            }),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(
              width: 20.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            FloatingActionButton(
              heroTag: 'getQuote',
              child: Icon(
                Icons.autorenew,
                color: _backgroundColor,
              ),
              onPressed: () {
                // print(fetchQuote().runtimeType);
                setState(() {
                  showFetch();
                });
              },
            ),
          ],
        ),*/
      ),
    );
  }
}
