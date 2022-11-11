import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class StocksController extends GetxController{
  late List allStocks = [];
  bool isLoading = true;

  Future<void> getAllStocks() async {
    try{
      isLoading = true;
      const url = "https://taxinetghana.xyz/get_all_stocks/";
      var myLink = Uri.parse(url);
      final response =
      await http.get(myLink);
      if (response.statusCode == 200) {
        final codeUnits = response.body.codeUnits;
        var jsonData = const Utf8Decoder().convert(codeUnits);
        allStocks = json.decode(jsonData);
        update();
      } else {
        if (kDebugMode) {
          // print(response.body);
        }
      }
    }
    catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    finally {
      isLoading = false;
    }
  }
}