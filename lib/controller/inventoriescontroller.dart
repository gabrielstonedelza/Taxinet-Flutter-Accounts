import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class InventoriesController extends GetxController{
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  String uToken = "";

  List inventories = [];
  List inventoriesToday = [];
  List inventoryDates = [];
  List inventoriesDates = [];


  late Timer _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
  }

  Future<void> getAllInventories() async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/admin_get_all_drivers_inventories/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        inventories.assignAll(jsonData);
        for(var i in inventories) {
          if(!inventoryDates.contains(i['date_checked'])){
            inventoryDates.add(i['date_checked']);
          }
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }
  Future<void> getAllInventoriesToday() async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/admin_get_inventories_today/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        inventoriesToday.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getInventoriesByDate(String inventoryDate) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/admin_get_all_drivers_inventories_by_date/$inventoryDate/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        inventoriesDates.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }
}