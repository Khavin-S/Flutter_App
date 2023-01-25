// ignore_for_file: non_constant_identifier_names

import 'package:app/global.dart';
import 'package:gsheets/gsheets.dart';

/// Your google auth credentials
///
/// how to get credentials - https://medium.com/@a.marenkov/how-to-get-credentials-for-google-sheets-456b7e88c430
const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-370606",
  "private_key_id": "914dbc49660664a3a8308400b2252795efb23552",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC4HgexKojB0v6K\nU81K8fcKhtB0d5a5Lj0uE7BePJfdD9vsglxzZRO8DY2sUapU5kAa9Pg9yATRp0oD\n0QkbWZ5k5fhLXCjyAqLO+mbbCNuLUk0HLWDhl+v7oMyLlcrMW4h4w0cHoyyIJSAx\nl/7eXrul84Ts2063i2gDMp50M/hZPViqzRN3vs4K/FPw+l5696OTQJAYH+ZnTACY\nKEkyl4YAmMZhKrWRy3kNy3aV3vuqRQlScEvvIUecKjyJPOwNyS0QO7dOfEvJ6uda\nQUGs6IckuUQV9EaqDqG/KNaaRoyUpztRBKdEzOCPanv8o+zicO7wMPalJc/ZCp9K\nj1GbCYBtAgMBAAECggEABnvoQXECB/FqTWzOGgmTbad5x+A+Sp86QFkpKOhxYLOi\nRx4AK4AvxbukdaEaoorJTym5ZFOa99cwYBoIfBIX5e3DZMQGHR/CpA9ld+lD8hAf\n7lTGyKsVAHOVQIUx8yh2EequobI5a0IDdDuqGiKz8RA2ajD/AK/EJfiuY+FAqcPT\n7Ioc7gzmxSI1ekvaeIOK3urTxYeEg2OZ6cA+izqq0BPxwKM7SfdzRTqhV+RNO9fP\njG5Ko1UyeXqo5nnNtGJESPry9BFiKAXbO/RktPjM05Ss42bHlkoIymD0SvxUQT2O\nP3qw6TIYsG6X2gf6QsjMHgKjWq9S1ZMtjUlSFhQ3cQKBgQDyt/SwuqcIM9Ta0XtY\njymIjpy9U+3jf0dePsoMrbgj9LHpoWGnQIOZX/JlZD2/qFP8Eh+75UAqgKIUr68w\n0OhbQ04qNdFtLecGpS1YO2VdJehGKiRTiT/jPxGJ1J4B7l0ra/6g+LEGhrW3gbmz\nupYO8BtrzA307A10ors/rwAufwKBgQDCMS1ofQAqxb4IX65pQ23lgR/A+tibNTRo\nE+pnnSPtDkIOYElJMXnfKPqARr5kXaqTNsseuLSLuq9g9TSIapRu8dZ8yhmKmVoI\nb+fqLegfThFFya+sdyTrRABgTOj1ZqSg3H1UZYIhoPdJg10aPF5TC1BmUetRuxMA\n5hFd211zEwKBgF05ss4+ovFPly4Ez++P7U/6FtHRbsm2lV7plwmPn+6PidZGmg93\nhBRg+eVfvyfiK3/iJjYxM5gfmCGB6TRCyTxkeZ1U1n+s5dNzlhsRlTlV2gU5IoLD\ncLqD+uSJubbcKwUGkeKaIsRy8VDujrktrX1HVADve1zbXb+y0WEAgn1ZAoGAK+Fi\n6l58oC2owEmmpqCW/6pK25eTRJckLXR6nkky6gkzwf3d8Y0dheDDoiLaOOG1fqh+\nA4YnPf/ES3t9EGpM+jjph68/UENQxeFLnW4cKp7AZm2ppaYSkJsAHsKiTXmRL8xD\nAcQiQKkX1+O4MQp9IfTHiSdvrjtAkw5p1DSSjEMCgYAnIzL4dYl8i6CphnQcVZQF\nLsrkBj0wkID1yZwSX31n4ZmONjTgRHNI5j7IQilQ+0tFAGwASi1c7mn3UtmPzVXi\nCqfHyZfUlGQlvHM9TaJm82Jjut+GgTBgNH3V1s2VY9Yld/r3cmUpbzNbR1WZ7Iad\n9I4i3+RC0rl/XRmHXXxHXw==\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-370606.iam.gserviceaccount.com",
  "client_id": "110908309836440394173",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-370606.iam.gserviceaccount.com"
}
''';
const _spreadsheetId = '1D6u-jRpdu6qkKtA9C-bWLXr5EQPdh7jBbvSRBzKxBHQ';

//Storing Conunt of users
void UserGsheet(String Name, String Number) async {
  // init GSheets
  // ignore: prefer_typing_uninitialized_variables
  var NewRow;
  final gsheets = GSheets(_credentials);
  // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(_spreadsheetId);
  print(ss.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));
  var sheet = ss.worksheetByTitle('Users');
  NewRow = {
    'Name': Name,
    'MobileNumber': Number,
  };
  await sheet!.values.map.appendRow(NewRow);
}

//get Home page Image url from Feature Gsheet
Future<void> featured_gsheet() async {
  // init GSheets
  var gsheets1 = GSheets(_credentials);

  // fetch spreadsheet by its id
  final ss1 = await gsheets1.spreadsheet(_spreadsheetId);
  print(ss1.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));
  var sheet1 = ss1.worksheetByTitle('Featured');
  sheet1!.cells;

  featureList = await sheet1.cells.column(2, fromRow: 2);

  //calling shopping list gsheets function
  shop_gsheet();
}

//shopping list gsheet
Future<void> shop_gsheet() async {
  // init GSheets
  var gsheets1 = GSheets(_credentials);

  // fetch spreadsheet by its id
  final ss1 = await gsheets1.spreadsheet(_spreadsheetId);
  print(ss1.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));
  var sheet1 = ss1.worksheetByTitle('Shop');
  sheet1!.cells;

  //getting list of columns from User gsheets
  //takes column from Column no: 2 and from R0w no: 2
  var shopList = await sheet1.cells
      .allColumns(fromColumn: 2, fromRow: 2); //contains List<List<String>>
  shop_productName = shopList[0]; //assigning Product_Name column from gsheet
  shop_imageList = shopList[1]; //assigning My_Art column from gsheets
  shop_priceList = shopList[2]; //assigning Price column from gsheets
  shop_stockList = shopList[3]; //assigning Stock column from gsheets
}

//update stock availabe to '0' of product after booked in Shop
void updateStock(
    String strCurrentStock, int strCurrentColumn, int strCurrentRow) async {
  // init GSheets
  var gsheets1 = GSheets(_credentials);

  // fetch spreadsheet by its id
  final ss1 = await gsheets1.spreadsheet(_spreadsheetId);
  print(ss1.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));
  var sheet1 = ss1.worksheetByTitle('Shop');
  sheet1!.cells;

  await sheet1.values.insertValue(strCurrentStock,
      column: strCurrentColumn, row: strCurrentRow);
}

//check stock for Button in Bag page
checkStock(CurrentstockRow) async {
  // init GSheets
  var gsheets1 = GSheets(_credentials);

  // fetch spreadsheet by its id
  final ss = await gsheets1.spreadsheet(_spreadsheetId);
  print(ss.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));
  var sheet = ss.worksheetByTitle('Shop');
  sheet!.cells;

  //getting list of columns from User gsheets
  //takes column from Column no: 2 and from R0w no: 2
  List<Cell> chkStock =
      await sheet.cells.column(5, fromRow: 2); //contains List<Cell>
  chkStockValue = chkStock[CurrentstockRow];
}

//get shop order details
void shopOrder(String Name, String Number, String Product_Name,
    String Product_Img, String Price) async {
  // init GSheets
  var NewRow;
  final gsheets = GSheets(_credentials);
  // fetch spreadsheet by its id
  final ss = await gsheets.spreadsheet(_spreadsheetId);
  print(ss.data.namedRanges.byName.values
      .map((e) => {
            'name': e.name,
            'start':
                '${String.fromCharCode((e.range?.startColumnIndex ?? 0) + 97)}${(e.range?.startRowIndex ?? 0) + 1}',
            'end':
                '${String.fromCharCode((e.range?.endColumnIndex ?? 0) + 97)}${(e.range?.endRowIndex ?? 0) + 1}'
          })
      .join('\n'));
  var sheet = ss.worksheetByTitle('ShopOrder');
  NewRow = {
    'Name': Name,
    'MobileNumber': Number,
    'Product_Name': Product_Name,
    'Product_Img': Product_Img,
    'Price': Price,
  };
  await sheet!.values.map.appendRow(NewRow);
}



/*
  // create worksheet if it does not exist yet
  sheet ??= await ss.addWorksheet('Users');
  // update cell at 'B2' by inserting string 'new'
  await sheet.values.insertValue('new', column: 2, row: 2);
  print(await sheet.values.value(column: 2, row: 2));
  // get cell at 'B2' as Cell object
  final cell = await sheet.cells.cell(column: 2, row: 2);
  // prints 'new'
  print(cell.value);
  // update cell at 'B2' by inserting 'new2'
  await cell.post('new2');
  // prints 'new2'
  print(cell.value);
  // also prints 'new2'
  print(await sheet.values.value(column: 2, row: 2));

  // insert list in row #1
  final firstRow = ['index', 'letter', 'number', 'label'];
  await sheet.values.insertRow(1, firstRow);
  // prints [index, letter, number, label]
  print(await sheet.values.row(1));

  // insert list in column 'A', starting from row #2
  final firstColumn = ['0', '1', '2', '3', '4'];
  await sheet.values.insertColumn(1, firstColumn, fromRow: 2);
  // prints [0, 1, 2, 3, 4, 5]
  print(await sheet.values.column(1, fromRow: 2));

  // insert list into column named 'letter'
  final secondColumn = ['a', 'b', 'c', 'd', 'e'];
  await sheet.values.insertColumnByKey('letter', secondColumn);
  // prints [a, b, c, d, e, f]
  print(await sheet.values.columnByKey('letter'));

  // insert map values into column 'C' mapping their keys to column 'A'
  // order of map entries does not matter
  final thirdColumn = {
    '0': '1',
    '1': '2',
    '2': '3',
    '3': '4',
    '4': '5',
  };
  await sheet.values.map.insertColumn(3, thirdColumn, mapTo: 1);
  // prints {index: number, 0: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6}
  print(await sheet.values.map.column(3));

  // insert map values into column named 'label' mapping their keys to column
  // named 'letter'
  // order of map entries does not matter
  final fourthColumn = {
    'a': 'a1',
    'b': 'b2',
    'c': 'c3',
    'd': 'd4',
    'e': 'e5',
  };
  await sheet.values.map.insertColumnByKey(
    'label',
    fourthColumn,
    mapTo: 'letter',
  );
  // prints {a: a1, b: b2, c: c3, d: d4, e: e5, f: f6}
  print(await sheet.values.map.columnByKey('label', mapTo: 'letter'));

  // appends map values as new row at the end mapping their keys to row #1
  // order of map entries does not matter
  final secondRow = {
    'index': '5',
    'letter': 'f',
    'number': '6',
    'label': 'f6',
  };
  await sheet.values.map.appendRow(secondRow);
  // prints {index: 5, letter: f, number: 6, label: f6}
  print(await sheet.values.map.lastRow());

  // get first row as List of Cell objects
  final cellsRow = await sheet.cells.row(1);
  // update each cell's value by adding char '_' at the beginning
  cellsRow.forEach((cell) => cell.value = '_${cell.value}');
  // actually updating sheets cells
  await sheet.cells.insert(cellsRow);
  // prints [_index, _letter, _number, _label]
  print(await sheet.values.row(1));
*/
