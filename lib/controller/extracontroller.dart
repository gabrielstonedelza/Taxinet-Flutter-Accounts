import 'package:flutter/foundation.dart';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ExtraController extends GetxController{
  bool isLoading = true;
  List allExtras = [];



  Future<void> getAllDriversExtras() async {
    try {
      isLoading = true;
      update();
      const walletUrl = "https://taxinetghana.xyz/get_activated_work_extra/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allExtras = jsonData;

        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
      update();
    }
  }
}