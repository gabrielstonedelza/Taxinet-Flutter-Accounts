import 'dart:async';
import 'package:flutter/foundation.dart';
import "package:get/get.dart";
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../constants/app_colors.dart';
import '../controller/requestscontroller.dart';
import '../homepage.dart';



class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  late var items;
  final storage = GetStorage();
  late String username = "";
  bool hasToken = false;
  late String uToken = "";
  bool isPosting = false;
  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      isPosting = false;
    });
  }

  addToBlockedList(String userId,String email,String username,String phoneNumber,String fullName) async {
    final depositUrl = "https://taxinetghana.xyz/update_blocked/$userId/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "user_blocked": "True",
      "email": email,
      "username": username,
      "phone_number": phoneNumber,
      "full_name": fullName,
    });
    if (res.statusCode == 200) {
      Get.snackbar("Success", "user is added to block lists",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: snackColor);
    }
    else{
      if (kDebugMode) {
        print(res.body);
      }
    }
  }

  removeFromBlockedList(String userId,String email,String username,String phoneNumber,String fullName) async {
    final depositUrl = "https://taxinetghana.xyz/update_blocked/$userId/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    }, body: {
      "user_blocked": "False",
      "email": email,
      "username": username,
      "phone_number": phoneNumber,
      "full_name": fullName,
    });
    if (res.statusCode == 200) {
      Get.snackbar("Success", "user is removed from block lists",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          backgroundColor: snackColor);
    }
    else{
      if (kDebugMode) {
        print(res.body);
      }
    }
  }

  deleteUser(String id)async{
    final url = "https://taxinetghana.xyz/delete_user/$id";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if(response.statusCode == 204){
      Get.offAll(()=> const HomePage());
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("username") != null) {
      setState(() {
        username = storage.read("username");
      });
    }
    if (storage.read("usertoken") != null) {
      setState(() {
        hasToken = true;
        uToken = storage.read("usertoken");
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("All Users"),
      ),
      body: GetBuilder<RequestController>(builder:(controller){
        return ListView.builder(
            itemCount: controller.allUsers != null ? controller.allUsers.length : 0,
            itemBuilder: (context,i){
              items = controller.allUsers[i];
              return Column(
                children: [
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8),
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      // shadowColor: Colors.pink,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: ListTile(
                            trailing: items['user_blocked'] ? IconButton(
                                onPressed: () {
                                  _startPosting();
                                  Get.snackbar("Please wait...", "removing user from  block lists",
                                      colorText: defaultTextColor1,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 5),
                                      backgroundColor: snackColor);
                                  removeFromBlockedList(controller.allUsers[i]['id'].toString(),controller.allUsers[i]['email'],controller.allUsers[i]['username'],controller.allUsers[i]['phone_number'],controller.allUsers[i]['full_name']);
                                },
                                icon:Image.asset("assets/images/blocked.png",width:100,height:100)
                            ) : IconButton(
                                onPressed: () {
                                  _startPosting();
                                  Get.snackbar("Please wait...", "adding user to block lists",
                                      colorText: defaultTextColor1,
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: const Duration(seconds: 5),
                                      backgroundColor: snackColor);
                                  addToBlockedList(controller.allUsers[i]['id'].toString(),controller.allUsers[i]['email'],controller.allUsers[i]['username'],controller.allUsers[i]['phone_number'],controller.allUsers[i]['full_name']);
                                },
                                icon:Image.asset("assets/images/block.png",width:100,height:100)
                            ),
                            leading: IconButton(
                                onPressed: () {
                                  Get.defaultDialog(
                                      buttonColor: primaryColor,
                                      title: "Confirm Delete",
                                      middleText: "Are you sure you want to remove ${controller.allUsers[i]['username']}?",
                                      confirm: RawMaterialButton(
                                          shape: const StadiumBorder(),
                                          fillColor: primaryColor,
                                          onPressed: (){
                                            deleteUser(controller.allUsers[i]['id'].toString());
                                            Get.back();
                                          }, child: const Text("Yes",style: TextStyle(color: Colors.white),)),
                                      cancel: RawMaterialButton(
                                          shape: const StadiumBorder(),
                                          fillColor: primaryColor,
                                          onPressed: (){Get.back();},
                                          child: const Text("Cancel",style: TextStyle(color: Colors.white),))
                                  );

                                },
                                icon:Image.asset("assets/images/cancel.png",width:40,height:40,fit: BoxFit.cover,)
                            ),

                            title: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0,top: 10),
                                child: Text(items['username'],style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
                              ),
                            ),
                            subtitle : Column(
                              children: [
                                Row(
                                  children: [
                                    const Text("Unique Code: ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                    Text(items['unique_code']),
                                  ],
                                ),
                                items['user_blocked'] ? const Center(child: Text("User is blocked")) : const Text("")
                              ],
                            )

                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,)
                ],
              );
            }
        );
      }),

    );
  }
}
