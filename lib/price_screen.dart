import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  bool isWaiting = false;
  String? selectedCurrency = 'USD';
  String? selectedCryto = 'BTC';

  // Rate for each crypto to hash (in a loop)
  Map<String, String> cryptoRateResults = {};

  List<ResultCard> resultCards() {
    List<ResultCard> resultCards = [];
    for (String crytoCurrency in cryptoList) {
      var resultCard = ResultCard(
          crytoCurrency: crytoCurrency,
          selectedCurrency: selectedCurrency,
          cryptoRateResults: cryptoRateResults,
          showIsWaiting: isWaiting,
      );
      resultCards.add(resultCard);
    }
    return resultCards;
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      dropDownItems
          .add(DropdownMenuItem(child: Text(currency), value: currency));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = pickerItems[selectedIndex].data;
          getData();
        });
      },
      children: pickerItems,
    );
  }

  void getData() async {
    isWaiting = true;
    try {
      for (String crypto in cryptoList) {
        print('crypto: $crypto');
        print('selectedCurrency: $selectedCurrency');
        String data = await CoinData().fetchData(
            assetIdBase: crypto, assetIdQuote: selectedCurrency);
        isWaiting = false;
        setState(() {
          // any variable you want to update on screen must go in setState
          cryptoRateResults[crypto] = data;
        });
      }
    } catch(e) {
      print("Error caught: $e" );
      print("Results: $cryptoRateResults");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: resultCards(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  const ResultCard({
    required this.crytoCurrency,
    required this.cryptoRateResults,
    required this.selectedCurrency,
    this.showIsWaiting,
  });

  final String crytoCurrency;
  final Map<String, String> cryptoRateResults;
  final String? selectedCurrency;
  final bool? showIsWaiting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            cardText(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String cardText() {
    String cardText;
    if (showIsWaiting == true) {
      cardText = '1 $crytoCurrency = ??? $selectedCurrency';
    } else {
      cardText =
      '1 $crytoCurrency = ${cryptoRateResults[crytoCurrency]} $selectedCurrency';
    }
    return cardText;
  }
}