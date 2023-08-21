import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  CoinData();
  String apikey = '99CEDE8A-B1FD-44B1-B1FD-4599A6B58DB1';

  // get coin data from coinapi
  Future<String> fetchData({String? assetIdBase="BTC", String? assetIdQuote="USD"}) async {
    var rate;

    String uri = 'https://rest.coinapi.io/v1/exchangerate/$assetIdBase/$assetIdQuote?apikey=$apikey';
    http.Response response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      print(decodedData);
      rate = decodedData['rate'].toStringAsFixed(2);
    } else {
      print(response.body);
    }
    return rate;
  }
}
