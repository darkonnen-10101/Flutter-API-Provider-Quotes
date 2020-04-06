import 'package:flutter/material.dart';
import 'package:quotespremium/src/widgets/dynamic_gradient.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gradient style',
        ),
      ),
      body: DynamicGradient(),
    );
  }
}
