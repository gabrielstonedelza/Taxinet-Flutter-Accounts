import 'dart:async';

import "package:flutter/material.dart";
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants/app_colors.dart';
import '../homepage.dart';

class AddExpense extends StatefulWidget {
  final driver;
  const AddExpense({Key? key,required this.driver}) : super(key: key);

  @override
  State<AddExpense> createState() => _AddExpenseState(driver:this.driver);
}

class _AddExpenseState extends State<AddExpense> {
  final driver;
  _AddExpenseState({required this.driver});
  late final TextEditingController _amountController;
  late final TextEditingController _reasonController;
  final _formKey = GlobalKey<FormState>();

  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _reasonFocusNode = FocusNode();
  bool isPosting = false;
  final storage = GetStorage();
  late String username = "";
  late String uToken = "";

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

  addExpense() async {
    const loginUrl = "https://taxinetghana.xyz/add_expenses/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
      "driver" :driver,
          "user": driver,
          "amount": _amountController.text,
          "reason":_reasonController.text
        });

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    internetSubscription = InternetConnectionChecker().onStatusChange.listen((status){
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(()=> this.hasInternet = hasInternet);
    });
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    _amountController = TextEditingController();
    _reasonController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor:Colors.transparent,
        elevation:0,
        title: const Text("Add Expense",),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
        ),
      ),
      body:ListView(
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
                            color: defaultTextColor1,
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
                Container(
                  height: size.height * 0.08,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.grey[500]?.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16)),
                  child: Center(
                    child: TextFormField(
                      controller: _reasonController,
                      focusNode: _reasonFocusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.person,
                            color: defaultTextColor1,
                          ),
                          hintText: "Reason",
                          hintStyle: TextStyle(color: defaultTextColor1)),
                      cursorColor: defaultTextColor1,
                      style: const TextStyle(color: defaultTextColor1),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter reason";
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
                      _startPosting();
                      if (_formKey.currentState!.validate()) {
                        addExpense();

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
                      "Add",
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
