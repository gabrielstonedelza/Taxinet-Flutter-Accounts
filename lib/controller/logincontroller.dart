import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:taxinet_accounts/homepage.dart';
import '../../constants/app_colors.dart';
import '../login.dart';



class MyLoginController extends GetxController{
  static MyLoginController get to => Get.find<MyLoginController>();
  final storage = GetStorage();
  var username = "";
  final password = "";

  late List allDrivers = [];

  late List driversUserNames = [];
  late List allPassengers = [];
  late List passengerUserNames = [];
  late List allInvestors = [];
  late List investorUserNames = [];
  bool hasErrors = false;

  bool isLoading = true;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllDrivers();
    getAllPassengers();
    getAllInvestors();
  }


  Future<void> getAllPassengers() async {
    try {
      isLoading = true;
      const completedRides = "https://taxinetghana.xyz/all_passengers";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allPassengers.assignAll(jsonData);
        for (var i in allPassengers) {
          passengerUserNames.add(i['username']);
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

  Future<void> getAllDrivers() async{
    try {
      isLoading = true;
      const completedRides = "https://taxinetghana.xyz/all_drivers";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDrivers.assignAll(jsonData);
        for(var i in allDrivers){
          driversUserNames.add(i['username']);
        }
        update();
      }
    } catch (e) {
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
    }
    finally{
      isLoading = false;
    }
  }

  Future<void> getAllInvestors() async{
    try {
      isLoading = true;
      const completedRides = "https://taxinetghana.xyz/all_investors/";
      var link = Uri.parse(completedRides);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allInvestors.assignAll(jsonData);
        for(var i in allInvestors){
          investorUserNames.add(i['username']);
        }
        update();
      }
    } catch (e) {
      Get.snackbar("Sorry",
          "something happened or please check your internet connection");
    }
    finally{
      isLoading = false;
    }
  }

  loginUser(String uname, String uPassword) async {
    const loginUrl = "https://taxinetghana.xyz/auth/token/login/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"username": uname, "password": uPassword});

    if (response.statusCode == 200) {
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      var userId = jsonData['user'];
      storage.write("username", uname);
      storage.write("userToken", userToken);
      storage.write("userType", "Accounts");
      storage.write("userid", userId);
      update();
      hasErrors = false;
      if (driversUserNames.contains(uname) || passengerUserNames.contains(uname) || investorUserNames.contains(uname)) {
        storage.remove("username");
        storage.remove("userToken");
        storage.remove("userType");
        storage.remove("userid");
        Get.snackbar("Sorry 😢", "you are not the accounts admin",
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: defaultTextColor1);
        Get.offAll(() => const NewLogin());
      }
      else {
        Timer(const Duration(seconds: 5), () =>
            Get.offAll(() => const HomePage()));
      }

    }
    else{
      hasErrors = true;
      Get.snackbar("Sorry 😢", "invalid details",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor1);
      return;
    }
  }
}