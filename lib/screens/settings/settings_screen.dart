import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
        ],
      ),
    );
  }
}
