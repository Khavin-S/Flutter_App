import 'package:app/global.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/google_signin_api.dart';
import '../../api/sheets.dart';
import '../home.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  PproductState createState() => PproductState();
}

class PproductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        drawer: SizedBox(width: screenWidth / 1.7, child: Drawerreturn()),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              //centerTitle: true,
              //alignment of Logo in appbar
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
            padding: EdgeInsets.all(screenWidth / 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight / 1.8,
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage('$strCurrentImg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: screenHeight / 18,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '$strCurrentProductName',
                        style: const TextStyle(fontSize: 20),
                      )),
                ),
                Container(
                  width: double.infinity,
                  height: screenHeight / 18,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        '\u{20B9}$strCurrentprice',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
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
              child: Row(
                children: [
                  SizedBox(width: screenWidth / 2, child: const Text('')),
                  Expanded(
                    child: SizedBox(
                      height: screenHeight / 20,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await checkStock(CurrentstockRow);
                          if (chkStockValue?.value == '0') {
                            nostock();
                          } else {
                            strCurrentStock = '0';
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            // get the locally stored boolean variable

                            shopOrder(
                                globalName!,
                                globalNumber!,
                                strCurrentProductName!,
                                strCurrentImg!,
                                strCurrentprice!);
                            sendEmail();
                            updateStock(strCurrentStock!, strCurrentColumn!,
                                strCurrentRow!);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            )),
                        child: const Text(
                          "PAY",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sendEmail() async {
    //GoogleSignInApi.signOut();
    //return;
    //GoogleSignInApi.disconnect();
    //return;
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
      ..subject = '$strCurrentProductName Order Placed'
      //..attachments.add()
      ..html =
          '''<h2><strong>Order Placed, Expected delivery : 7 Days</strong></h2>
<table style="border-collapse: collapse; width: 100%; height: 72px;" border="1">
<tbody>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Name</td>
<td style="width: 50%; height: 18px;">$globalName</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Number</td>
<td style="width: 50%; height: 18px;">$globalNumber</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Product Name</td>
<td style="width: 50%; height: 18px;">
<div>
<div>$strCurrentProductName</div>
</div>
</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%; height: 18px;">Price</td>
<td style="width: 50%; height: 18px;">$strCurrentprice</td>
</tr>
<tr style="height: 18px;">
<td style="width: 50%;">Image</td>
<td style="width: 50%;">$strCurrentImg</td>
</tr>
</tbody>
</table>''';
    try {
      await send(message, smtpServer);
      mailsent();
    } on MailerException //catch (e)
    {
      //print(e);
    }
  }

  progress() {
    const Center(
      child: CircularProgressIndicator(),
    );
  }

  mailsent() {
    const snackBar = SnackBar(
      content: Text("Your order has been placed"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  nostock() {
    const snackBar = SnackBar(
      content: Text("Out of stock"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
