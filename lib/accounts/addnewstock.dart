import 'dart:async';

import "package:flutter/material.dart";
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';


import '../constants/app_colors.dart';
import '../homepage.dart';

class AddStock extends StatefulWidget {
  const AddStock({Key? key}) : super(key: key);

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {

  late final TextEditingController _itemNameController;
  late final TextEditingController _quantityController;
  final _formKey = GlobalKey<FormState>();


  final FocusNode _itemNameFocusNode = FocusNode();
  final FocusNode _quantityFocusNode = FocusNode();

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
    const loginUrl = "https://taxinetghana.xyz/add_stock/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "item_name":_itemNameController.text,
          "quantity":_quantityController.text
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

    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }

    _itemNameController = TextEditingController();
    _quantityController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: const Text("Add Stock",),
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
                          controller: _itemNameController,
                          focusNode: _itemNameFocusNode,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.transparent
                              ),
                              hintText: "Item name",
                              hintStyle: TextStyle(color: defaultTextColor1)),
                          cursorColor: defaultTextColor1,
                          style: const TextStyle(color: defaultTextColor1),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter item name";
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
                          controller: _quantityController,
                          focusNode: _quantityFocusNode,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.transparent
                              ),
                              hintText: "Quantity",
                              hintStyle: TextStyle(color: defaultTextColor1)),
                          cursorColor: defaultTextColor1,
                          style: const TextStyle(color: defaultTextColor1),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter quantity";
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
