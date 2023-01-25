library my_prj.globals;

//importing Cell data type from gsheets
import 'package:gsheets/gsheets.dart';

//featured image for home screen
String? ImgUrl1 = '';
String? ImgUrl2 = '';
String? ImgUrl3 = '';
String? ImgUrl4 = '';
String? ImgUrl5 = '';

//declaing from featured image in homepage
List<Cell> featureList = [];

//declaring for storing shopping from gsheets by its column
List<Cell> shop_productName = [];
List<Cell> shop_imageList = [];
List<Cell> shop_priceList = [];
List<Cell> shop_stockList = [];

//current selected image in Grid view
String? strCurrentProductName = '';
String? strCurrentImg = '';
String? strCurrentprice = '';
String? strCurrentStock = '';
//using for updaing row of stock
int? strCurrentRow;
int? strCurrentColumn;

//storing Name and number to pass with ordered person details
String? globalName = '';
String? globalNumber = '';

//check stock
int? CurrentstockRow;
Cell? chkStockValue;

//global screen width and height
double? globalWidth;
double? globalHeight;
