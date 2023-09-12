import 'package:flutter/material.dart';
import 'package:passvault/main.dart';
import 'package:passvault/widgets/change_masterpassword_bottomsheet.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _useBio = false;
  bool _darkMode = true;
  SharedPreferences? prefs;
  int selectedValue = 1;

  @override
  void initState() {
    super.initState();
    getPrefrences();
  }

  Future<void> getPrefrences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedValue = prefs!.getInt('themeIndex')!;
      _useBio = prefs!.getBool('usebio')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _newPasswordFieldController = TextEditingController();
    final _newPasswordConfirmationFieldController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Security'),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: _useBio,
                  leading: const Icon(Icons.fingerprint),
                  title: const Text('Use fingerprint authentication'),
                  onToggle: (value) async {
                    setState(() {
                      _useBio = value;
                      prefs!.setBool('usebio', value);
                    });
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.password),
                  title: const Text('Change Master Password'),
                  value: const Text('Current Password'),
                  onPressed: (value) {
                    showModalBottomSheet(
                        showDragHandle: true,
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangeMasterPasswordBottomSheet();
                        });
                  },
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Appearance'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.palette),
                  title: const Text('App Theme'),
                  value: _darkMode
                      ? const Text('Dark Mode')
                      : const Text('Light Mode'),
                  onPressed: (value) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Choose a theme'),
                            content: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    RadioListTile(
                                      title: const Text('Light'),
                                      value: 1,
                                      groupValue: selectedValue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Text('Dark'),
                                      value: 2,
                                      groupValue: selectedValue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Text('Nord'),
                                      value: 3,
                                      groupValue: selectedValue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: const Text('Green Apple'),
                                      value: 4,
                                      groupValue: selectedValue,
                                      onChanged: (int? value) {
                                        setState(() {
                                          selectedValue = value!;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Ok'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  prefs!.setInt('themeIndex', selectedValue);
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
