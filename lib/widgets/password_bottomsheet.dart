import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:passvault/Database/database_manager.dart';
import 'package:passvault/models/password.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:textfield_tags/textfield_tags.dart';

class PasswordBottomSheet extends StatefulWidget {
  const PasswordBottomSheet({super.key});

  @override
  State<PasswordBottomSheet> createState() => _PasswordBottomSheetState();
}

class _PasswordBottomSheetState extends State<PasswordBottomSheet> {
  List<String> tags = [];
  final _titleFieldController = TextEditingController();
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  final _websiteFieldController = TextEditingController();
  final _notesFieldController = TextEditingController();
  final _tagsFieldController = TextfieldTagsController();
  final FancyPasswordController _fancyPasswordController =
      FancyPasswordController();
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
                  child: const Text('Add'),
                  onPressed: () async {
                    final password = Password(
                      title: _titleFieldController.text,
                      username: _usernameFieldController.text,
                      password: _passwordFieldController.text,
                      website: _websiteFieldController.text,
                      notes: _notesFieldController.text,
                      tags: _tagsFieldController.getTags,
                    );
                    DatabaseManager.instance.insertPassword(password);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            const Text(
              'Password Information',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 13),
            TextField(
              controller: _titleFieldController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Development Account',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameFieldController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Email/Username',
                hintText: 'john.doe@example.com',
              ),
            ),
            const SizedBox(height: 16),
            FancyPasswordField(
              passwordController: _fancyPasswordController,
              controller: _passwordFieldController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                hintText: 'Password',
              ),
              strengthIndicatorBuilder: (strength) {
                return StepProgressIndicator(
                  totalSteps: 8,
                  currentStep: getStep(strength),
                  selectedColor: getColor(strength)!,
                  unselectedColor: Colors.grey[300]!,
                );
              },
              validationRuleBuilder: (rules, value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rules.map(
                    (rule) {
                      final ruleValidated = rule.validate(value);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            ruleValidated ? Icons.check : Icons.close,
                            color: ruleValidated ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            rule.name,
                            style: TextStyle(
                              color: ruleValidated ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _websiteFieldController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Website',
                hintText: 'https://www.google.com',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesFieldController,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                labelText: 'Notes',
              ),
            ),
            const SizedBox(height: 16),
            TextFieldTags(
                textfieldTagsController: _tagsFieldController,
                textSeparators: const [' ', ' '],
                letterCase: LetterCase.normal,
                validator: (String tag) {
                  if (_tagsFieldController.getTags!.contains(tag)) {
                    return 'Duplicate tag';
                  }
                  return null;
                },
                inputfieldBuilder:
                    (context, tec, fn, error, onChanged, onSubmitted) {
                  return ((context, sc, tags, onTagDelete) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          isDense: true,
                          helperText: 'Enter language...',
                          helperStyle: const TextStyle(
                            color: Color.fromARGB(255, 74, 137, 92),
                          ),
                          hintText: _tagsFieldController.hasTags
                              ? ''
                              : "Enter tag...",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: _distanceToField * 0.74),
                          prefixIcon: tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: tags.map((String tag) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Color.fromARGB(255, 74, 137, 92),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              onTagDelete(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    );
                  });
                }),
          ],
        ),
      ),
    );
  }

  int getStep(double strength) {
    if (strength == 0) {
      return 0;
    } else if (strength < .1) {
      return 1;
    } else if (strength < .2) {
      return 2;
    } else if (strength < .3) {
      return 3;
    } else if (strength < .4) {
      return 4;
    } else if (strength < .5) {
      return 5;
    } else if (strength < .6) {
      return 6;
    } else if (strength < .7) {
      return 7;
    }
    return 8;
  }

  Color? getColor(double strength) {
    if (strength == 0) {
      return Colors.grey[300];
    } else if (strength < .1) {
      return Colors.red;
    } else if (strength < .2) {
      return Colors.red;
    } else if (strength < .3) {
      return Colors.yellow;
    } else if (strength < .4) {
      return Colors.yellow;
    } else if (strength < .5) {
      return Colors.yellow;
    } else if (strength < .6) {
      return Colors.green;
    } else if (strength < .7) {
      return Colors.green;
    }
    return Colors.green;
  }
}
