import 'package:flutter/material.dart';
import 'package:linear_gradient/linear_gradient.dart';
import 'package:provider/provider.dart';
import 'package:quotespremium/src/models/gradient_list.dart';
import 'package:quotespremium/src/providers/change_gradient.dart';

class DynamicGradient extends StatefulWidget {
  @override
  _DynamicGradientState createState() => _DynamicGradientState();
}

class _DynamicGradientState extends State<DynamicGradient> {
  List<int> listOfGradients = listOfGradientStyles;

  @override
  Widget build(BuildContext context) {
    ChangeGradient _gradientConfig = Provider.of<ChangeGradient>(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: listOfGradients.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SwitchListTile(
            title: Text(
              'Vertical gradient',
              style: TextStyle(fontWeight: FontWeight.bold),
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
          );
        } else {
          return Container(
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
          );
        }
      },
    );
  }
}
