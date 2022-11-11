import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../homepage.dart';


class MyRegistrationController extends GetxController{


  registerUser(String uType,String uname,String email,String fName,String phoneNumber,String uPassword, String uRePassword,String promoter) async {
    const loginUrl = "https://taxinetghana.xyz/auth/users/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"user_type":uType,"username": uname,"email":email,"full_name":fName,"phone_number":phoneNumber, "password": uPassword,"re_password":uRePassword,"promoter": promoter});

    if (response.statusCode == 201) {
      Get.offAll(()=> const HomePage());
    }
    else {
      Get.snackbar(
          "Error 😢", response.body.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 8)
      );
      return;
    }
  }
}
