import 'dart:async';

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';


import '../constants/app_colors.dart';
import '../homepage.dart';

class AddPromoterCommission extends StatefulWidget {
  final promoter;
  final username;
  const AddPromoterCommission({Key? key,required this.promoter,required this.username}) : super(key: key);

  @override
  State<AddPromoterCommission> createState() => _AddPromoterCommissionState(promoter:this.promoter,username:this.username);
}

class _AddPromoterCommissionState extends State<AddPromoterCommission> {
  final promoter;
  final username;
  _AddPromoterCommissionState({required this.promoter,this.username});
  late final TextEditingController _amountController;

  final _formKey = GlobalKey<FormState>();

  final FocusNode _amountFocusNode = FocusNode();

  bool isPosting = false;


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

  payCommission() async {
    const url = "https://taxinetghana.xyz/add_promoter_commission/";
    final myLogin = Uri.parse(url);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "promoter" : promoter,
          "amount": _amountController.text,
        });

    if (response.statusCode == 201) {
      Get.offAll(()=> const HomePage());
    }
    else {
      if (kDebugMode) {
        print(response.body);
      }

      Get.snackbar(
          "Error 😢", "something went wrong",
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
    _amountController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: Text("Pay $username's commission",),
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
                                color: Colors.transparent,
                              ),
                              hintText: "amount",
                              hintStyle: TextStyle(color: defaultTextColor1)),
                          cursorColor: defaultTextColor1,
                          style: const TextStyle(color: defaultTextColor1),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
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
                          _startPosting();
                          if (_formKey.currentState!.validate()) {
                            payCommission();

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
