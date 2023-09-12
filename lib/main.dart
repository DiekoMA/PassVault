import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:passvault/pages/SetMasterPasswordPage.dart';
import 'package:passvault/pages/verify_masterpassword_page.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
}

final secureStorage = FlutterSecureStorage();
final _defaultLightColorScheme =
    ColorScheme.fromSwatch(primarySwatch: Colors.blue);

final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue, brightness: Brightness.dark);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pass Vault',
            theme: ThemeData(
              colorScheme: lightColorScheme ?? _defaultLightColorScheme,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
              useMaterial3: true,
            ),
            themeMode: ThemeMode.dark,
            home: FutureBuilder(
              future: checkMasterPasswordExists(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  if (snapshot.data == true) {
                    return const VerifyMasterPasswordPage();
                  } else {
                    return const SetMasterPasswordPage();
                  }
                }
              },
            ));
      },
    );
  }

  Future<bool> checkMasterPasswordExists() async {
    String? masterPassword = await secureStorage.read(key: 'master_password');

    return masterPassword != null;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[]),
      ),
    );
  }
}
