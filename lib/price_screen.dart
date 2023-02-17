import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

const kApiKey = '0625EBA5-BF9E-42BC-A954-F3FE491C3D14';
late var asset_id_base;
late var rate1;
late var rate2;
late var rate3;
late var time;
late var rate;

String selectedCurrency = 'USD';

class PriceScreen extends StatefulWidget {
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}
List<dynamic> rates=[];

Future getInfo() async {
    for(String crypto in cryptoList) {
      http.Response response = await http.get(Uri.parse(
          'https://rest.coinapi.io/v1/exchangerate/$crypto/$selectedCurrency?apikey=$kApiKey'));

      var data = await response.body;
      // print(response.body);
      var decodedData = jsonDecode(data);
      time = decodedData['time'];
      rate = decodedData['rate'].round();
      asset_id_base = decodedData['asset_id_base'];
      rates.add(rate);

    }
    print(rates);
        return rates;

}

class _PriceScreenState extends State<PriceScreen> {
  List <dynamic> finalRates=[];
void getData() async {

    finalRates=await getInfo();
    setState(() {
      rate1=finalRates[0];
      rate2=finalRates[1];
      rate3=finalRates[2];
      finalRates.clear();
    });
// print(finalRates);
print(rate1);
print(rate2);
print(rate3);
}
  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget GetDropDownButton() {
    List<DropdownMenuItem<String>> CurrencyName() {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (String currency in currenciesList) {
        String name = currency;
        var newItem = DropdownMenuItem(
          child: Text(name),
          value: name,
        );
        dropDownItems.add(newItem);
      }
      return dropDownItems;
    }

    return DropdownButton(
      style: TextStyle(color: Colors.black, fontSize: 25),
      value: selectedCurrency,
      icon: Icon(
        Icons.arrow_drop_down,
        size: 50,
        color: Colors.blue,
      ),
      items: CurrencyName(),
      onChanged: (value) {
        setState(() {
          getData();
          selectedCurrency = value.toString();
        });
        print(value);
      },
    );
  }

  Widget GetCupertinoPicker() {
    List<Widget> GetPickerList() {
      List<Widget> pickerList = [];
      for (String currency in currenciesList) {
        var newItem = Text(currency);
        pickerList.add(newItem);
      }
      return pickerList;
    }

    return CupertinoPicker(
      backgroundColor: Colors.blue,
      onSelectedItemChanged: (index) {
        print(index);
      },
      itemExtent: 32.0,
      children: GetPickerList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(child: Text('Coin Ticker')),
        ),
        // body: Column(
        //   children: [
        //     Text('btc $rate1'),
        //     Text('eth $rate2'),
        //     Text('ltc $rate3'),
        //   ],
        // ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  height: 80,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(
                        '1 ${cryptoList[0]} = $rate1 $selectedCurrency',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // shape: ShapeBorder.lerp(a, b, t),
                  ),
                ),Container(
                  padding: EdgeInsets.all(15),
                  height: 80,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(
                        '1 ${cryptoList[1]} = $rate2 $selectedCurrency',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // shape: ShapeBorder.lerp(a, b, t),
                  ),
                ),Container(
                  padding: EdgeInsets.all(15),
                  height: 80,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(
                        '1 ${cryptoList[2]} = $rate3 $selectedCurrency',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // shape: ShapeBorder.lerp(a, b, t),
                  ),
                ),

              ],
            ),
            Container(
              height: 150,
              alignment: Alignment.center,
              color: Colors.blue,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // boxShadow: ,
                  color: Colors.white,
                ),
                child: Platform.isAndroid
                    ? GetDropDownButton()
                    : GetCupertinoPicker(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
