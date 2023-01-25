import 'package:app/api/sheets.dart';
import 'package:app/global.dart';
import 'package:app/page/signup.dart';
import 'package:app/page/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  featured_gsheet().then((value) {
    Validate();
  });
}

void Validate() async {
  LicenseRegistry.addLicense(() async* {
    final license =
        await rootBundle.loadString('assets/fonts/Kanit/Kanit-SemiBold.ttf');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  // init a shared preferences variable
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // get the locally stored boolean variable
  String? finalName = prefs.getString('Name') ?? '';
  String? finalNumber = prefs.getString('Number') ?? '';

  //storing Name & Number in local variable
  globalName = finalName;
  globalNumber = finalNumber;

  // define the initial route based on whether the user is logged in or not
  String? initialRoute = true ? '/' : 'Home';

  // create a flutter material app as usual
  Widget app = MaterialApp(
    initialRoute: initialRoute,
  );

  if (finalName != '' && finalNumber != '') {
    // mount and run the flutter app
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kanit',
      ),
      home: const Home(),
    ));
  } else {
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Kanit',
        ),
        home: const Loginpage(),
      ),
    );
  }
}
