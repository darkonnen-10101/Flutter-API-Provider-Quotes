import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:linear_gradient/linear_gradient.dart';
import 'package:provider/provider.dart';
import 'package:quotespremium/src/admob/admob_config.dart';
import 'package:quotespremium/src/data/gradient_list.dart';
import 'package:quotespremium/src/pages/home_page.dart';
import 'package:quotespremium/src/providers/change_gradient.dart';
import 'package:quotespremium/src/widgets/static_admob_banner.dart';

class DynamicGradient extends StatefulWidget {
  // static AdmobBannerSize bannerSize = AdmobBannerSize.FULL_BANNER;

  @override
  _DynamicGradientState createState() => _DynamicGradientState();
}

class _DynamicGradientState extends State<DynamicGradient> {
  List<int> listOfGradients = listOfGradientStyles;
  // static AdmobBannerSize bannerSize = AdmobBannerSize.LEADERBOARD;

  final AdmobBannerWrapper fixedAdmobBanner = AdmobBannerWrapper(
    adSize: HomePage.bannerSize,
    adUnitId: getBannerAdUnitId(),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // bannerSize = AdmobBannerSize.LEADERBOARD;
  }

  @override
  Widget build(BuildContext context) {
    ChangeGradient _gradientConfig = Provider.of<ChangeGradient>(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: listOfGradients.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                ),
                elevation: 10.0,
                child: fixedAdmobBanner,
              ),
              Card(
                elevation: 10.0,
                child: SwitchListTile(
                  title: Text(
                    'Vertical gradient',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        _gradientConfig.valueState = value;
                        _gradientConfig.valueState
                            ? _gradientConfig.gradientOrientation =
                                LinearGradientStyle.ORIENTATION_VERTICAL
                            : _gradientConfig.gradientOrientation =
                                LinearGradientStyle.ORIENTATION_HORIZONTAL;
                      },
                    );
                  },
                  value: _gradientConfig.valueState,
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),
            ],
          );
        } /* else if (index > 8 && index % 30 == 0) {
          return Column(children: <Widget>[
            Card(
              elevation: 10.0,
              child: fixedAdmobBanner,
            ),
          ]);
        } */
        else {
          return Card(
            elevation: 10.0,
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                gradient: LinearGradientStyle.linearGradient(
                  orientation: _gradientConfig.gradientOrientation,
                  gradientType: listOfGradients[index],
                ),
              ),
              child: ListTile(
                onTap: () {
                  setState(
                    () {
                      _gradientConfig.gradientColor = listOfGradients[index];
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
