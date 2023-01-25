import 'package:app/global.dart';
import 'package:app/page/signup.dart';
import 'package:app/page/your_portrait.dart';
import 'package:app/page/Shop/shop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/google_signin_api.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

ScrollController scrollController = ScrollController();

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //portrait device orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //get screen height and width of different screen size to be responsive
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    globalWidth = screenWidth;
    globalHeight = screenHeight;

    return SafeArea(
      child: Scaffold(
        //navigation side drawer
        //menu drawer auto placed in appbar at left side
        drawer: SizedBox(
          width: screenWidth / 1.7,
          height: screenHeight,
          child: Drawerreturn(),
        ),

        body: //To hide Appbar while scroll use Nested scrollview with silverAppBar iinstead of appbar
            Scrollbar(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                //centerTitle: true,
                // expandedHeight: screenWidth / 3, //heignt of Appbar
                //alignment of Logo in appbar
                title: Column(
                  children: [
                    Align(
                      alignment:
                          Alignment.centerRight, //align child to centerRight
                      child: Text(
                        'BLACK&WHITE',
                        style: TextStyle(fontSize: screenHeight / 60),
                      ),
                    ),
                  ],
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
            body: //infinite scroll length
                SingleChildScrollView(
              child:
                  //start column elements from start but default Center()
                  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //gap from border of device
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight / 12,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'khavin',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth / 18, right: screenWidth / 20),
                    //fitted box to be reponsive with different size screens
                    child: SizedBox(
                      height: screenHeight / 5.5,
                      width: screenWidth / 2,
                      child: const FittedBox(
                        child: Text(
                          'Art is\nEverything,\nEverywhere!',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: screenHeight / 2,
                        width: screenWidth / 2.8,
                        /* child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, //Center Row contents horizontally,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, //Center Row contents vertically,
                              children: const <Widget>[
                                FittedBox(
                                  child: Icon(
                                    Icons.arrow_upward_sharp,
                                    size: 48,
                                  ),
                                ),
                                FittedBox(
                                  child: Icon(
                                    Icons.arrow_upward_sharp,
                                    size: 48,
                                  ),
                                ),
                              ],
                            ),
                            FittedBox(
                              child: Text(
                                "SCROLL UP",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),*/
                      ),
                      /* SizedBox(
                        height: screenHeight / 2,
                        child: const RotatedBox(
                          quarterTurns: 3,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: FittedBox(
                                child: Text(
                                  'FEATURED ART',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              ),
                        ),
                      ),*/

                      //fill up remaining space in row or column
                      Flexible(
                        child: SizedBox(
                          height: screenHeight / 2,
                          child: ListView.separated(
                              itemCount: featureList.length,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: globalWidth! / 50),
                              itemBuilder: (context, index) =>
                                  getWidget(featureList[index])),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight / 14,
                    width: screenWidth,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth / 18, right: screenWidth / 20),
                    child: SizedBox(
                      height: screenHeight / 5.5,
                      width: screenWidth / 2,
                      child: const FittedBox(
                        child: Text(
                          'Get your\nportrait\nHere',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 16,
                    width: screenWidth,
                  ),
                  Center(
                    child: SizedBox(
                      height: screenHeight / 16,
                      width: screenWidth / 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => YourPortrait(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            )),
                        child: FittedBox(
                          child: const Text(
                            "YOUR PORTRAIT",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight / 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //dynamic widget to display featured image from gsheets
  Widget getWidget(Cell image) => SizedBox(
        width: globalWidth! / 1.5,
        child: Image(
          image: NetworkImage(image.value),
          fit: BoxFit.cover,
        ),
      );
}

//side navigation drawer
class Drawerreturn extends StatelessWidget {
  Drawerreturn({super.key});
  final Uri whatsapp = Uri.parse('whatsapp://send?phone=+917538803228');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
              width: double.infinity,
              child: DrawerHeader(
                child: Text(
                  "EXPLORE",
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_sharp),
              title: const Text('HOME'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.pencilAlt),
              title: const Text('YOUR PORTRAIT'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const YourPortrait(),
                  ),
                );
              },
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_sharp),
              title: const Text('SHOP'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Shop(),
                  ),
                );
              },
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: const Icon(Icons.whatsapp),
                    title: const Text('CONTACT'),
                    onTap: () async {
                      launchUrl(whatsapp);
                    },
                  ),
                  Divider(
                    height: 1,
                    color: Colors.black,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout_sharp),
                    title: const Text('LOGOUT'),
                    onTap: () async {
                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.remove('Name');
                      sharedPreferences.remove('Number');
                      try {
                        await GoogleSignInApi.logout();
                        // ignore: empty_catches
                      } catch (e) {}
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const Loginpage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
