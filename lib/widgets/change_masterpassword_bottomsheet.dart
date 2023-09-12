import 'package:flutter/material.dart';
import 'package:passvault/main.dart';

class ChangeMasterPasswordBottomSheet extends StatefulWidget {
  const ChangeMasterPasswordBottomSheet({super.key});

  @override
  State<ChangeMasterPasswordBottomSheet> createState() =>
      _ChangeMasterPasswordBottomSheetState();
}

class _ChangeMasterPasswordBottomSheetState
    extends State<ChangeMasterPasswordBottomSheet> {
  final _newPasswordFieldController = TextEditingController();
  final _newPasswordConfirmationFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _distanceToField = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                OutlinedButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (_newPasswordConfirmationFieldController.text ==
                        _newPasswordFieldController.text) {
                      setMasterPassword(_newPasswordFieldController.text);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('The passwords do not match'),
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
                ),
                const TextField(
                  //controller: _newPasswordFieldController,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    label: Text('New Password'),
                    border: OutlineInputBorder(),
                    hintText: 'Development Account',
                  ),
                ),
                // const SizedBox(height: 16),
                // TextField(
                //     controller: _newPasswordConfirmationFieldController,
                //     autocorrect: false,
                //     enableSuggestions: false,
                //     decoration: const InputDecoration(
                //       label: Text('Confirm New Password'),
                //       border: OutlineInputBorder(),
                //       hintText: 'Development Account',
                //     )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> setMasterPassword(String password) async {
  await secureStorage.write(key: 'master_password', value: password);
}
