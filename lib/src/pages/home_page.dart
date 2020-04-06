import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quotespremium/src/pages/settings_page.dart';
import 'package:quotespremium/src/providers/change_background_color.dart';
import 'package:quotespremium/src/providers/change_gradient.dart';
import 'package:quotespremium/src/providers/change_text_color.dart';
import 'package:quotespremium/src/widgets/fancy_fab.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:linear_gradient/linear_gradient.dart';
import 'package:progress_dialog/progress_dialog.dart';
/*

English, Spanish, Portuguese, Italian, German,
French, Czech, Slovak, Polish, Hungarian, Russian

e9492e81femsh34b99eb6aa85e90p1311eejsnce09d6dad505

quotes15.p.rapidapi.com
 */

class Originator {
  final String name;
  Originator({this.name});

  factory Originator.fromJson(Map<String, dynamic> json) {
    return Originator(
      name: json['name'],
    );
  }
}

class Quote {
  final String language;
  final String content;
  final Originator originator;

  Quote({this.language, this.content, this.originator});

  factory Quote.fromJson(Map<String, dynamic> parsedJson) {
    return Quote(
      language: parsedJson['language_code'],
      content: parsedJson['content'],
      originator: Originator.fromJson(parsedJson['originator']),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Screenshot
  // GlobalKey _globalKey = GlobalKey();
  // File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  // Screenshot

  PermissionStatus _status;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Map data;
  String quote;
  String author;
  String currentLanguage = 'en';
  List languages = [
    'English',
    'Spanish',
    'Portuguese',
    'Italian',
    'German',
    'French',
    'Czech',
    'Slovak',
    'Polish',
    'Hungarian',
    'Russian'
  ];
  List abreviatedLang = [
    'en',
    'es',
    'pt',
    'it',
    'de',
    'fr',
    'cs',
    'sk',
    'pl',
    'hu',
    'ru',
  ];

  // Color
  // Color

  Future fetchQuote() async {
    final response = await http.get(
      'https://quotes15.p.rapidapi.com/quotes/random/?language_code=$currentLanguage',
      headers: {
        "x-rapidapi-host": "quotes15.p.rapidapi.com",
        "x-rapidapi-key": "e9492e81femsh34b99eb6aa85e90p1311eejsnce09d6dad505",
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

  @override
  void initState() {
    super.initState();
    fetchQuote();
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

  @override
  Widget build(BuildContext context) {
    ChangeTextColor textColorProvider = Provider.of<ChangeTextColor>(context);
    ChangeBackgroundColor backgroundColorProvider =
        Provider.of<ChangeBackgroundColor>(context);

    Color _textColor = textColorProvider.colorBase;
    Color _backgroundColor = backgroundColorProvider.backgroundBase;
    Color _currentTextColor = textColorProvider.colorBase;
    // Color _currentBackgroundColor = Colors.white;
    // bool _gradientContainer = true;

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

    void showFetch() {
      fetchQuote();
      pr.show();
      Future.delayed(Duration(
        milliseconds: 1500,
      )).then((value) {
        pr.hide().whenComplete(() {});
      });
    }

    void changeTextColor(Color color) =>
        setState(() => _currentTextColor = color);
    // void changeBackgroundColor(Color color) =>         setState(() => _currentBackgroundColor = color);

    ChangeGradient _gradientConfig = Provider.of<ChangeGradient>(context);
    void _displaySnackBar(BuildContext context) {
      final snackBar = SnackBar(
        content: Text(
          'Image Saved to Gallery',
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

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
                      currentLanguage = abreviatedLang[selectedRadio];
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
        key: _scaffoldKey,
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
          controller: screenshotController,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: //_gradientContainer == true ?
                BoxDecoration(
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

                  Text(
                    quote == null
                        ? 'Quote'
                        : '\' ${utf8.decode(quote.runes.toList())} \'',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 25.0,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    quote == null
                        ? 'Author'
                        : '${utf8.decode(author.runes.toList())}',
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
            FloatingActionButton(
              heroTag: 'download',
              child: Icon(
                Icons.file_download,
                color: _backgroundColor,
              ),
              onPressed: () {
                if (_status != PermissionStatus.granted) {
                  _askPermission();
                } else {
                  // _imageFile = null;
                  screenshotController
                      .capture(delay: Duration(milliseconds: 10))
                      .then((File image) async {
                    //print("Capture Done");
                    setState(() {
                      // _imageFile = image;
                    });
                    // final result =
                    await ImageGallerySaver.saveImage(image.readAsBytesSync());
                    // print("File Saved to Gallery");
                    _displaySnackBar(context);
                  }).catchError((onError) {
                    print(onError);
                  });
                }
              },
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
            FancyFab(),
          ],
        ), */
      ),
    );
  }
}
