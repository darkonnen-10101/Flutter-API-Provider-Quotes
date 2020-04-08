import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:quotespremium/src/models/data_quote.dart';
import 'package:quotespremium/src/data/languages_list.dart';
import 'package:quotespremium/src/networking/fetch_api.dart';
import 'package:quotespremium/src/pages/home_page.dart';
import 'package:quotespremium/src/pages/settings_page.dart';
import 'package:quotespremium/src/providers/change_background_color.dart';
import 'package:quotespremium/src/providers/change_language.dart';
import 'package:quotespremium/src/providers/change_quote_and_author.dart';
import 'package:quotespremium/src/providers/change_text_color.dart';
import 'package:screenshot/screenshot.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final IconData icon;

  FancyFab({this.onPressed, this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  static final List languages = Languages.languages;
  static final List abreviatedLang = Languages.abreviatedLang;

  // Screenshot
  ScreenshotController screenshotController = HomePage.screenshotController;
  static final _scaffoldKey = HomePage.scaffoldKey;

  // Screenshot

  PermissionStatus _status;

  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;

  // Dropdown
  // Dropdown

  @override
  initState() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then(_updateStatus);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
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
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  @override
  Widget build(BuildContext context) {
    ChangeLanguage _currentLanguage = Provider.of<ChangeLanguage>(context);
    ChangeQuoteAndAuthor changeTextQuoteAuthor =
        Provider.of<ChangeQuoteAndAuthor>(context);

    ChangeTextColor textColorProvider = Provider.of<ChangeTextColor>(context);
    Color _currentTextColor = textColorProvider.colorBase;

    ChangeBackgroundColor backgroundColorProvider =
        Provider.of<ChangeBackgroundColor>(context);
    Color _backgroundColor = backgroundColorProvider.backgroundBase;

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

    Widget toggle() {
      return Container(
        child: FloatingActionButton(
          backgroundColor: _buttonColor.value,
          onPressed: animate,
          tooltip: 'Toggle',
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            color: _buttonColor.value == Colors.black
                ? Colors.white
                : Colors.black,
            progress: _animateIcon,
          ),
        ),
      );
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

    void changeTextColor(Color color) =>
        setState(() => _currentTextColor = color);

    void _displaySnackBar(BuildContext context) {
      final snackBar = SnackBar(
        content: Text(
          'Image Saved to Gallery',
        ),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    Widget download() {
      return Container(
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          heroTag: 'download',
          child: Icon(
            Icons.file_download,
            color: Colors.black,
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
      );
    }

    Widget editText() {
      return Container(
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          heroTag: 'textColor',
          child: Icon(
            Icons.text_fields,
            color: Colors.black,
          ),
          onPressed: () {
            // backgroundColorProvider.backgroundColor = _chosenColor;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
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
                              pickerAreaHeightPercent: 0.5,
                              enableAlpha: true,
                              displayThumbColor: true,
                              showLabel: true,
                              paletteType: PaletteType.hsv,
                              pickerAreaBorderRadius: const BorderRadius.only(
                                topLeft: const Radius.circular(2.0),
                                topRight: const Radius.circular(2.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(
                            child: Text(
                              'Ok',
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                textColorProvider.textColor = _currentTextColor;
                                // textStyles.setFontStyleQuote =                                    selectedFontStyle.fontStyleQuote;
                              });
                            }),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      );
    }

    Widget gradient() {
      return Container(
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          heroTag: 'settings',
          child: Icon(
            Icons.color_lens,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SettingsPage(),
              ),
            );
          },
        ),
      );
    }

    Widget language() {
      return Container(
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          heroTag: 'language',
          child: Icon(
            Icons.language,
            color: Colors.black,
          ),
          onPressed: () {
            _displayDialog(context);
          },
        ),
      );
    }

    Widget fetchQuote() {
      return Container(
        child: FloatingActionButton(
          backgroundColor: _backgroundColor,
          heroTag: 'getQuote',
          child: Icon(
            Icons.play_arrow,
            color: Colors.black,
          ),
          onPressed: () {
            // print(fetchQuote().runtimeType);
            setState(() {
              showFetch();
            });
          },
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 5.0,
            0.0,
          ),
          child: editText(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 4.0,
            0.0,
          ),
          child: gradient(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: language(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: fetchQuote(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: download(),
        ),
        toggle(),
      ],
    );
  }
}
