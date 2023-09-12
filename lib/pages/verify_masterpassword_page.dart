import 'package:flutter/material.dart';
import 'package:passvault/main.dart';
import 'package:passvault/pages/dashboard_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyMasterPasswordPage extends StatefulWidget {
  const VerifyMasterPasswordPage({super.key});

  @override
  State<VerifyMasterPasswordPage> createState() =>
      _VerifyMasterPasswordPageState();
}

class _VerifyMasterPasswordPageState extends State<VerifyMasterPasswordPage> {
  final TextEditingController passwordController = TextEditingController();

  SharedPreferences? prefs;
  bool _useBio = false;

  Future<void> getPrefrences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _useBio = prefs!.getBool('usebio')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify Master Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your master password:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () async {
                  bool isPasswordCorrect =
                      await verifyMasterPassword(passwordController.text);
                  if (isPasswordCorrect) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardPage(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Incorrect Password'),
                          content: const Text('Please try again.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Verify Password'),
              ),
            ],
          ),
        ));
  }

  Future<bool> verifyMasterPassword(String password) async {
    String? storedPassword = await secureStorage.read(key: 'master_password');

    // Compare the entered password with the stored password
    return password == storedPassword;
  }
}
