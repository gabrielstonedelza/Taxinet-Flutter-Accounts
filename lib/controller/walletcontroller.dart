import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class WalletController extends GetxController{
  bool isLoading = true;
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  List allWallets = [];



  Future<void> getAllWallet() async {
    try {
      isLoading = true;
      update();
      const walletUrl = "https://taxinetghana.xyz/admin_get_all_users_wallet/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allWallets = jsonData;

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