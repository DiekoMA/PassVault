import 'package:flutter/material.dart';
import 'package:passvault/main.dart';
import 'package:passvault/pages/dashboard_page.dart';

class SetMasterPasswordPage extends StatefulWidget {
  const SetMasterPasswordPage({super.key});

  @override
  State<SetMasterPasswordPage> createState() => _SetMasterPasswordPageState();
}

class _SetMasterPasswordPageState extends State<SetMasterPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Set Master Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Set your master password:'),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    setMasterPassword(passwordController.text);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DashboardPage(),
                        ));
                  },
                  child: const Text('Set Password'),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> setMasterPassword(String password) async {
    await secureStorage.write(key: 'master_password', value: password);
  }
}
