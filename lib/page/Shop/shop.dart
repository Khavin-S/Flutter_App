//import 'package:app/api/google_signin_api.dart';
import 'package:app/global.dart';
import 'package:app/page/Shop/product.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import '../home.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  @override
  Widget build(BuildContext context) {
    //getting screen height and width for responsive design for different screen sizes
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        drawer: SizedBox(
          width: screenWidth / 1.7,
          child: Drawerreturn(),
        ),
        //nested scrollview for hiding appbar while scrolling page
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              //centerTitle: true,
              //alignment of Logo in appbar
              expandedHeight: screenWidth / 3,
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
            child: SizedBox(
              height: screenHeight,
              child: GridView.builder(
                itemCount: shop_imageList
                    .length, //creating dynamic grid container according to Shop gsheets img url length
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: ((screenWidth / 16) / (screenHeight / 18)),
                ),
                //calling dyamic widget in gridview
                itemBuilder: ((context, index) => getWidget(
                      shop_productName[index],
                      shop_imageList[index],
                      shop_priceList[index],
                      shop_stockList[index],
                      index,
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }

//Dynamic widget declaration
  Widget getWidget(
    Cell productName,
    Cell networkImage,
    Cell price,
    Cell stock,
    int index,
  ) {
    //GestureDetector to do task when clicked on Widget
    return GestureDetector(
      //onTap: what to do on tap of its child widgets
      onTap: () {
        setState(
          () {
            //setting Current Values for each Container in Synchronous way,
            strCurrentProductName = productName.value;
            strCurrentImg = networkImage.value;
            strCurrentprice = price.value;
            strCurrentRow = stock.row;
            strCurrentColumn = stock.column;
            CurrentstockRow = index;
          },
        );
        //page route to
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Product(),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: globalHeight! / 4,
            width: double.infinity,
            child: Image(
              image: NetworkImage(networkImage.value),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: globalHeight! / 25,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                productName.value,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                '\u{20B9}${price.value}',
                style: const TextStyle(fontSize: 16),
              ), //'\u{20B9}': Rupee symbol in text
            ),
          ),
        ],
      ),
    );
  }
}
