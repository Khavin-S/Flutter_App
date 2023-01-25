import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/api/sheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  @override
  Widget build(BuildContext context) {
    //portrait device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //creating textfield for entering Name
              TextFormField(
                onChanged: (text) {
                  getname(text);
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'ENTER YOUR NAME',
                ),
              ),
              const SizedBox(height: 20),

              //creating textfield for entering Number
              TextFormField(
                onChanged: (text) {
                  getnumber(text);
                },
                decoration:
                    const InputDecoration(labelText: "ENTER YOUR NUMBER"),
                // Only numbers can be entered
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: screenHeight / 18,
                width: screenWidth / 2,
                child: ElevatedButton(
                  //custom style for elevated button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  //text in button
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 25),
                  ),
                  //action
                  onPressed: () async {
                    //validating form fields
                    if ((Name != "" && Number != "") &&
                        (Name != "" || Number != "")) {
                      if (Number!.length != 10) {
                        ValidNumber();
                      } else {
                        //navigate to homepage
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      }
                    } else {
                      SnackBarMsg();
                    }
                    //shared preferences take Instance
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString('Name', Name!);
                    sharedPreferences.setString('Number', Number!);
                    UserGsheet(Name!, Number!);
                  },
                ),
              ),
              SizedBox(
                height: screenHeight / 40,
              ),
              Text(
                'Note : Always Turn your mobile data on\nwhile using this app',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

//******************************************************************************
//getting Name and Number field from textfield
  // ignore: non_constant_identifier_names
  String? Number = '';
  // ignore: non_constant_identifier_names
  String? Name = '';

//update Name on typing in textfield
  getname(val) async {
    setState(() {
      Name = val;
    });
  }

//update Number on typing in textfield
  getnumber(val) async {
    setState(() {
      Number = val;
    });
  }
//******************************************************************************

//show error msg
  // ignore: non_constant_identifier_names
  SnackBarMsg() {
    const snackBar = SnackBar(
      content: Text("Fill all field's"),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ignore: non_constant_identifier_names
  ValidNumber() {
    const snackBar = SnackBar(
      content: Text("Number must be 10 characters"),
    );
// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
//******************************************************************************
