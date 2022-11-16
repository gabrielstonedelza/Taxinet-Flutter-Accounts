import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';


import '../constants/app_colors.dart';
import '../controller/usercontroller.dart';
import '../controller/walletcontroller.dart';
import '../homepage.dart';

class AddDrivesSalary extends StatefulWidget {
  final driver;
  final username;
  const AddDrivesSalary({Key? key,required this.driver,required this.username}) : super(key: key);

  @override
  State<AddDrivesSalary> createState() => _AddDrivesSalaryState(driver:this.driver,username:this.username);
}

class _AddDrivesSalaryState extends State<AddDrivesSalary> {
  final driver;
  final username;
  _AddDrivesSalaryState({required this.driver,required this.username});
  late final TextEditingController _amountController;
  final WalletController controller = Get.find();

  final _formKey = GlobalKey<FormState>();

  final FocusNode _amountFocusNode = FocusNode();
  bool isPosting = false;
  final storage = GetStorage();
  String deDriver = "";
  String walletId = "";
  String initialWallet = "0.0";
  bool isLoading = true;
  var username1 = "";
  String uToken = "";
  double initialAccountWallet = 0;


  Future<void> getDriversWallet() async {
    final walletUrl = "https://taxinetghana.xyz/get_wallet_by_username/$username/";
    var link = Uri.parse(walletUrl);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    });
    if (response.statusCode == 200) {
      final codeUnits = response.body;
      var jsonData = jsonDecode(codeUnits);
      deDriver = jsonData['user'].toString();
      walletId = jsonData['id'].toString();
      initialWallet = jsonData['amount'].toString();
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  final UserController user = Get.find();
  var items;

  addSalary() async {
    const salaryUrl = "https://taxinetghana.xyz/add_monthly_salary/";
    final myLogin = Uri.parse(salaryUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "driver" :driver,
          "user": driver,
          "amount": _amountController.text,
        });

    if (response.statusCode == 201) {
      initialAccountWallet = initialAccountWallet - double.parse(_amountController.text);
      double amount = double.parse(initialWallet) + double.parse(_amountController.text);
      updateWallet(walletId,amount.toString() , deDriver);
      updateAccountsWallet();
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

  updateWallet(String id,String amount,String user)async {
    final requestUrl = "https://taxinetghana.xyz/admin_update_wallet/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      // "Authorization": "Token $uToken"
    }, body: {
      "amount" : amount,
      "user" : user
    });
    if(response.statusCode == 200){
      setState(() {
      });

      Get.snackbar("Success", "wallet was updated",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5)
      );
    }
    else{
      if (kDebugMode) {
        // print(response.body);
      }
    }
  }
  updateAccountsWallet() async {
    final depositUrl = "https://taxinetghana.xyz/user_update_wallet/${user.userId}/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      // "passenger": userid,
      "user": user.userId,
      "amount": initialAccountWallet.toString(),
    });
    if (res.statusCode == 200) {
      Get.snackbar("Hurray 😀", "Transaction completed successfully.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      // Get.to(()=> const Transfers());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username1 = storage.read("username");
    }
    _amountController = TextEditingController();
    getDriversWallet();
    initialAccountWallet = double.parse(controller.wallet);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: Text("Pay $username's salary",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body:isLoading ? const Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 5,
            backgroundColor: primaryColor
          )
        ) :ListView(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [

                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                          color: Colors.grey[500]?.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: TextFormField(
                          controller: _amountController,
                          focusNode: _amountFocusNode,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.transparent,
                              ),
                              hintText: "amount",
                              hintStyle: TextStyle(color: defaultTextColor1)),
                          cursorColor: defaultTextColor1,
                          style: const TextStyle(color: defaultTextColor1),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter amount";
                            }
                            else{
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    const SizedBox(height: 25,),
                    isPosting ? const Center(
                        child: CircularProgressIndicator.adaptive(
                            strokeWidth: 5,
                            backgroundColor:primaryColor
                        )
                    ) : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: primaryColor
                      ),
                      height: size.height * 0.08,
                      width: size.width * 0.8,
                      child: RawMaterialButton(
                        onPressed: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);

                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          _startPosting();
                          if (_formKey.currentState!.validate()) {
                            addSalary();

                          } else {

                            Get.snackbar("Error", "Something went wrong,check form",
                                colorText: defaultTextColor1,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red
                            );
                            return;
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 8,
                        fillColor: Colors.black,
                        splashColor: defaultColor,
                        child: const Text(
                          "Pay",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: defaultTextColor1),
                        ),
                      ),
                    )
                  ],
                )
            )
          ],
        )
    );
  }
}
