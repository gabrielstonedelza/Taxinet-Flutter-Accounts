import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';



class UserController extends GetxController {
  final storage = GetStorage();
  var username = "";
  String uToken = "";
  String passengerProfileId = "";
  String passengerUsername = "";
  String profileImage = "";
  String nameOnGhanaCard = "";
  String email = "";
  String phoneNumber = "";
  String fullName = "";
  String nextOfKin = "";
  String nextOfKinPhoneNumber = "";
  String frontGhanaCard = "";
  String backGhanaCard = "";
  String referral = "";
  String uniqueCode = "";
  late bool verified;
  bool isVerified = false;
  late String updateUserName;
  late String updateEmail;
  late String updatePhone;
  bool isUpdating = true;
  bool hasUploadedFrontCard = false;
  bool hasUploadedBackCard = false;

  late List profileDetails = [];

  late List allUsers = [];
  late List phoneNumbers = [];
  late List driversUniqueCodes = [];
  late List allDrivers = [];
  late List driversNames = [];
  late List passengerNames = [];
  late List passengersUniqueCodes = [];
  late List allPassengers = [];


  bool isLoading = true;

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



  Future<void> getUserProfile(String token) async {
    try {
      isLoading = true;
      update();
      const profileLink = "https://taxinetghana.xyz/passenger-profile";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Token $token"
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        profileDetails = jsonData;
        for (var i in profileDetails) {
          profileImage = i['passenger_profile_pic'];
          nameOnGhanaCard = i['name_on_ghana_card'];
          email = i['get_passengers_email'];
          phoneNumber = i['get_passengers_phone_number'];
          fullName = i['get_passengers_full_name'];
          nextOfKin = i['next_of_kin'];
          nextOfKinPhoneNumber = i['next_of_kin_number'];
          frontGhanaCard = i['get_front_side_ghana_card'];
          backGhanaCard = i['get_back_side_ghana_card'];
          referral = i['referral'];
          verified = i['verified'];
          passengerProfileId = i['user'].toString();
          passengerUsername = i['username'].toString();
          uniqueCode = i['unique_code'];
        }
        update();
        storage.write("verified", "Verified");
        storage.write("profile_id", passengerProfileId);
        storage.write("profile_name", fullName);
        storage.write("profile_pic", profileImage);
        storage.write("passenger_username", passengerUsername);
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
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


  Future<void> getAllUsers() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/users/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allUsers = jsonData;
        for (var i in allUsers) {
          if(!phoneNumbers.contains(i['phone_number'])){
            phoneNumbers.add(i['phone_number']);
          }
        }
        update();
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getAllDrivers() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/all_drivers_profile/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allDrivers = jsonData;
        for (var i in allDrivers) {
          if(!driversUniqueCodes.contains(i['unique_code'])){
            driversUniqueCodes.add(i['unique_code']);
          }
          if(!driversNames.contains(i['get_drivers_full_name'])){
            driversNames.add(i['get_drivers_full_name']);
          }
        }
        update();
      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getAllPassengers() async {
    try {
      isLoading = true;
      const profileLink = "https://taxinetghana.xyz/all_passengers_profile/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allPassengers = jsonData;
        for (var i in allPassengers) {
          if(!passengersUniqueCodes.contains(i['unique_code'])){
            passengersUniqueCodes.add(i['unique_code']);
          }
          if(!passengerNames.contains(i['get_passengers_full_name'])){
            passengerNames.add(i['get_passengers_full_name']);
          }
        }
        update();

      }
      else{
        if (kDebugMode) {
          print(response.body);
        }
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
