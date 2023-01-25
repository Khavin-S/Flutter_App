import 'home.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../global.dart';
import 'package:app/api/google_signin_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class YourPortrait extends StatefulWidget {
  const YourPortrait({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _YourPortraitState createState() => _YourPortraitState();
}

class _YourPortraitState extends State<YourPortrait> {
  @override
  Widget build(BuildContext context) {
    //get screen height and width of different screen size to be responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: SizedBox(width: screenWidth / 1.7, child: Drawerreturn()),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              //centerTitle: true,
              //alignment of Logo in appbar
              //expandedHeight: screenWidth / 3,
              title: Align(
                alignment: Alignment.centerRight, //align child to centerRight
                child: Text(
                  'BLACK&WHITE',
                  style: TextStyle(fontSize: screenHeight / 60),
                ),
              ),
              //transparent appbar
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
              floating: true,
              snap: false,
              pinned: false,
            ),
          ],
          body: Padding(
            padding: EdgeInsets.only(
                left: screenWidth / 20, right: screenWidth / 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight / 18),
                Container(
                  width: screenWidth / 2,
                  height: screenHeight / 12,
                  child: FittedBox(
                    child: Text(
                      'GET YOUR PENCIL\nPORTRAIT FOR \u{20B9}250',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 45),
                if (file != null)
                  Container(
                    color: Colors.black,
                    height: screenHeight / 1.8,
                    width: screenWidth,
                    child: Image.file(File(file!.path!), fit: BoxFit.contain),
                  ),
                if (file == null)
                  Container(
                    color: Colors.black,
                    height: screenHeight / 1.8,
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _upload,
                          icon: const Icon(Icons.upload_file_sharp),
                          iconSize: 50,
                          color: Colors.white,
                        ),
                        const Text(
                          'UPLOAD PICTURE',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                if (file != null)
                  Row(
                    children: [
                      IconButton(
                        onPressed: _upload,
                        icon: const Icon(Icons.upload_file_sharp),
                        iconSize: 50,
                      ),
                      const Text(
                        'CHANGE PICTURE',
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 15,
          child: SizedBox(
            height: screenHeight / 12,
            child: Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 20, right: screenWidth / 20),
              child: Row(children: [
                SizedBox(
                    width: screenWidth / 2,
                    child: const Text('cash on delivery')),
                Expanded(
                  child: SizedBox(
                    height: screenHeight / 20,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          )),
                      onPressed: () => sendEmail(),
                      child: const FittedBox(
                        child: Text(
                          "BOOK NOW",
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  //file picker
  String? filepath;
  PlatformFile? file;
  void _upload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        file = result.files.first;
        filepath = result.files.single.path; //pick file path
      });
      print(result.files.single.path);
    } else {
      print("No file is picked");
    }
  }

  //sending email function
  Future sendEmail() async {
    if (file == null) return photoexception();
    final user = await GoogleSignInApi.login();
    if (user == null) return;
    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken!;
    print('Authenticated: $email');
    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = Address(email, 'Khavin')
      ..recipients = ['khavinprince@gmail.com']
      ..ccRecipients.add(email)
      ..subject = 'Black&White'
      ..attachments.add(FileAttachment(File('$filepath')))
      //..text
      ..html =
          '''<h2><strong>Order placed, Expected delivery in 7 Days from now on</strong></h2>
          <table style="border-collapse: collapse; width: 100%; height: 36px;" border="1">
<tbody>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Name</td>
<td style="width: 50%; height: 18px;">$globalName</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Number</td>
<td style="width: 50%; height: 18px;">$globalNumber</td>
</tr>
</tbody>
</table>''';
    try {
      await send(message, smtpServer);
      mailsent();
    } on MailerException catch (e) {
      print(e);
    }
    setState(() {
      file = null;
    });
  }

  //SnackBar message
  mailsent() {
    const snackBar = SnackBar(
      content: Text("BOOKED SUCCESSFULLY"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  photoexception() {
    const snackBar = SnackBar(
      content: Text("UPLOAD A PHOTO TO BOOK"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
