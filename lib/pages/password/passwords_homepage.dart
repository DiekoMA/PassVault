import 'package:flutter/material.dart';
import 'package:passvault/Database/database_manager.dart';
import 'package:passvault/models/password.dart';
import 'package:passvault/pages/password/passwords_detailspage.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  List<Password> passwords = [];

  @override
  void initState() {
    super.initState();
    retrievePasswords();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> retrievePasswords() async {
    final dbManager = DatabaseManager.instance;
    final retrievedPasswords = await dbManager.getPasswords();
    setState(() {
      passwords = retrievedPasswords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          retrievePasswords();
        });
      },
      child: ListView.builder(
        itemCount: passwords.length,
        itemBuilder: (BuildContext context, int index) {
          final password = passwords[index];

          return ListTile(
            title: Text(password.title),
            subtitle: Text(password.username),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          PasswordDetailsPage(passwordDetails: password))));
            },
          );
        },
      ),
    );
  }
}
