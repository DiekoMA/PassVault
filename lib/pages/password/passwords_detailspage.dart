import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:flutter/material.dart';
import 'package:passvault/Database/database_manager.dart';
import 'package:passvault/models/password.dart';
import 'package:flutter/services.dart';
import 'package:passvault/widgets/HiddenTextTile.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:textfield_tags/textfield_tags.dart';

class PasswordDetailsPage extends StatefulWidget {
  final Password passwordDetails;

  const PasswordDetailsPage({Key? key, required this.passwordDetails})
      : super(key: key);

  @override
  State<PasswordDetailsPage> createState() => _PasswordDetailsPageState();
}

class _PasswordDetailsPageState extends State<PasswordDetailsPage> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    final Password info = widget.passwordDetails;
    double distanceToField = MediaQuery.of(context).size.width;
    final titleFieldController = TextEditingController();
    final usernameFieldController = TextEditingController();
    final passwordFieldController = TextEditingController();
    final websiteFieldController = TextEditingController();
    final notesFieldController = TextEditingController();
    final tagsFieldController = TextfieldTagsController();
    final FancyPasswordController _fancyPasswordController =
        FancyPasswordController();
    titleFieldController.text = info.title;
    usernameFieldController.text = info.username;
    passwordFieldController.text = info.password;
    websiteFieldController.text = info.website!;
    notesFieldController.text = info.notes!;
    // _tagsFieldController.addTag = info.tags.join();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.passwordDetails.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      // final password = Password(
                                      //   title: _titleFieldController.text,
                                      //   username: _usernameFieldController.text,
                                      //   password: _passwordFieldController.text,
                                      //   website: _websiteFieldController.text,
                                      //   notes: _notesFieldController.text,
                                      //   tags: _tagsFieldController.getTags,
                                      // );
                                      DatabaseManager.instance.updatePassword(
                                          widget.passwordDetails);
                                      Navigator.of(context).pop();
                                    },
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
                                    controller: titleFieldController,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Title',
                                      hintText: 'Development Account',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: usernameFieldController,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Email/Username',
                                      hintText: 'john.doe@example.com',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  FancyPasswordField(
                                    passwordController:
                                        _fancyPasswordController,
                                    controller: passwordFieldController,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: rules.map(
                                          (rule) {
                                            final ruleValidated =
                                                rule.validate(value);
                                            return Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  ruleValidated
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: ruleValidated
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  rule.name,
                                                  style: TextStyle(
                                                    color: ruleValidated
                                                        ? Colors.green
                                                        : Colors.red,
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
                                    controller: websiteFieldController,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Website',
                                      hintText: 'https://www.google.com',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: notesFieldController,
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    decoration: const InputDecoration(
                                      labelText: 'Notes',
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFieldTags(
                                      textfieldTagsController:
                                          tagsFieldController,
                                      textSeparators: const [' ', ' '],
                                      letterCase: LetterCase.normal,
                                      validator: (String tag) {
                                        if (tagsFieldController.getTags!
                                            .contains(tag)) {
                                          return 'Duplicate tag';
                                        }
                                        return null;
                                      },
                                      inputfieldBuilder: (context, tec, fn,
                                          error, onChanged, onSubmitted) {
                                        return ((context, sc, tags,
                                            onTagDelete) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 10.0),
                                            child: TextField(
                                              controller: tec,
                                              focusNode: fn,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                helperText: 'Enter language...',
                                                helperStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 74, 137, 92),
                                                ),
                                                hintText:
                                                    tagsFieldController.hasTags
                                                        ? ''
                                                        : "Enter tag...",
                                                errorText: error,
                                                prefixIconConstraints:
                                                    BoxConstraints(
                                                        maxWidth:
                                                            distanceToField *
                                                                0.74),
                                                prefixIcon: tags.isNotEmpty
                                                    ? SingleChildScrollView(
                                                        controller: sc,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                            children: tags.map(
                                                                (String tag) {
                                                          return Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20.0),
                                                              ),
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      74,
                                                                      137,
                                                                      92),
                                                            ),
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        4.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  child: Text(
                                                                    '#$tag',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 4.0),
                                                                InkWell(
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .cancel,
                                                                    size: 14.0,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            233,
                                                                            233,
                                                                            233),
                                                                  ),
                                                                  onTap: () {
                                                                    onTagDelete(
                                                                        tag);
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
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                DatabaseManager.instance
                    .deletePassword(widget.passwordDetails.id!);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Username'),
                subtitle: Text(widget.passwordDetails.username),
                trailing: const Icon(Icons.copy),
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(text: widget.passwordDetails.username));
                },
              ),
              HiddenTextTile(hiddenText: widget.passwordDetails.password),
              ListTile(
                title: const Text('Notes'),
                subtitle: Text(widget.passwordDetails.notes!),
                onTap: () {},
              ),
            ],
          ),
        ));
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
