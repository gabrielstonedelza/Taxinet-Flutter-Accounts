import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../constants/app_colors.dart';
import '../controller/walletcontroller.dart';

class SearchWallet extends StatefulWidget {
  const SearchWallet({Key? key}) : super(key: key);

  @override
  State<SearchWallet> createState() => _SearchWalletState();
}

class _SearchWalletState extends State<SearchWallet> {
  final WalletController controller = Get.find();
  var items;
  late List walletUsers = [];
  bool isSearching = false;

  late final  TextEditingController newAmountController = TextEditingController();
  final FocusNode newAmountFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isPosting = false;

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isPosting = false;
      newAmountController.text = "";
      Get.snackbar("Success", "Wallet was updated",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5)
      );
      Navigator.pop(context);
    });
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
        newAmountController.text = "";
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

  searchWallet(String searchItem)async{
    final url = "https://taxinetghana.xyz/search_wallet?search=$searchItem";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if(response.statusCode ==200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      walletUsers = json.decode(jsonData);
    }
    else{

    }

    setState(() {
      // isSearching = false;
      walletUsers = walletUsers;
    });
  }

  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: const Text("Search User Wallet",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value){
                  if(value.isNotEmpty){
                    setState(() {
                      isSearching = true;
                    });
                    searchWallet(value);
                  }
                  if(value.isEmpty){
                    setState(() {
                      isSearching = false;
                    });
                  }

                },
                style: const TextStyle(color:defaultTextColor1),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: defaultColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:BorderSide.none,

                  ),
                  hintText:  "eg: username, phone number",
                  prefixIcon: const Icon(Icons.search,color:Colors.white),
                  prefixIconColor: Colors.white,
                ),
              ),
              const SizedBox (height:20),
              Expanded(
                  child: isSearching ? walletUsers.length == 0 ? const Text("No results found",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: defaultTextColor1),): ListView.builder(
                      itemCount: walletUsers != null ? walletUsers.length : 0,
                      itemBuilder: (context,index){
                        items = walletUsers[index];
                        return SlideInUp(
                          animate: true,
                          child: Card(
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: (){
                                showMaterialModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.vertical(
                                          top: Radius.circular(25.0))),
                                  bounce: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: SingleChildScrollView(
                                      controller: ModalScrollController.of(context),
                                      child: SizedBox(
                                          height: 350,
                                          child: ListView(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          newAmountController.text = "";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(FontAwesomeIcons.times,size:30,color:Colors.red)
                                                  )
                                                ],
                                              ),
                                              Center(
                                                  child: Text("Update ${controller.allWallets[index]['get_username']}'s wallet",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                                              ),
                                              Center(
                                                  child: Text("(₵${controller.allWallets[index]['amount']})",style: const TextStyle(fontSize: 15))
                                              ),
                                              const SizedBox (height:20),
                                              Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Form(
                                                  key: _formKey,
                                                  child:Padding(
                                                    padding: const EdgeInsets.only(bottom: 10.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(color: Colors.grey, width: 1)),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 8.0,right: 10),
                                                        child: TextFormField(
                                                          controller: newAmountController,
                                                          focusNode: newAmountFocusNode,
                                                          autocorrect: true,
                                                          enableSuggestions: true,
                                                          decoration: const InputDecoration(
                                                            border: InputBorder.none,
                                                            hintText: "Enter amount",
                                                            hintStyle: TextStyle(color: defaultTextColor2,),
                                                          ),
                                                          cursorColor: defaultTextColor2,
                                                          style: const TextStyle(color: defaultTextColor2),
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
                                                  ),
                                                ),
                                              ),
                                              isPosting ? const Center(
                                                  child:CircularProgressIndicator.adaptive(
                                                    strokeWidth: 5,
                                                    backgroundColor: primaryColor,
                                                  )
                                              ) :  Padding(
                                                padding: const EdgeInsets.only(left:18.0,right:18),
                                                child: RawMaterialButton(
                                                  onPressed: () {
                                                    _startPosting();
                                                    if (!_formKey.currentState!.validate()) {
                                                      Get.snackbar("Error", "Something went wrong",
                                                          colorText: defaultTextColor1,
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: Colors.red
                                                      );
                                                      return;
                                                    } else {
                                                      double totalAmount = double.parse(controller.allWallets[index]['amount']) + double.parse(newAmountController.text);
                                                      updateWallet(controller.allWallets[index]['id'].toString(),totalAmount.toString(),controller.allWallets[index]['user'].toString());
                                                    }
                                                  },
                                                  // child: const Text("Send"),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8)),
                                                  elevation: 8,
                                                  fillColor:
                                                  primaryColor,
                                                  splashColor:
                                                  defaultColor,
                                                  child: const Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 20,
                                                        color:
                                                        defaultTextColor1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                );
                              },
                              leading: items['get_profile_pic'] != null ? CircleAvatar(
                                backgroundImage: NetworkImage(items['get_profile_pic']),
                              ) : const CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                                radius: 20,
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom:10.0,top:10),
                                child: Text(items['get_full_name']),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(items['get_username']),
                                  const SizedBox(height:10),
                                  Text(items['get_user_type']),
                                  const SizedBox(height:10),
                                ],
                              ),
                              trailing: Text("₵${items['amount']}",style: const TextStyle(fontWeight: FontWeight.bold)),
                              // trailing: CachedNetworkImage(
                              //   imageUrl: items['driver_profile_pic'],
                              //   placeholder: (context, url) => const CircularProgressIndicator(),
                              //   errorWidget: (context, url, error) => const Icon(Icons.error),
                              // ),
                            ),
                          ),
                        );
                      }
                  ) : Container()
              )
            ],
          ),
        )
    );
  }
}
