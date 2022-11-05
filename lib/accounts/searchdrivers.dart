import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../constants/app_colors.dart';
import '../controller/walletcontroller.dart';
import 'addexpense.dart';

class SearchDriver extends StatefulWidget {
  const SearchDriver({Key? key}) : super(key: key);

  @override
  State<SearchDriver> createState() => _SearchDriverState();
}

class _SearchDriverState extends State<SearchDriver> {
  final WalletController controller = Get.find();
  var items;
  late List drivers = [];
  bool isSearching = false;

  searchDrivers(String searchItem)async{
    final url = "https://taxinetghana.xyz/search_driver?search=$searchItem";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if(response.statusCode ==200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      drivers = json.decode(jsonData);
    }
    else{

    }

    setState(() {
      // isSearching = false;
      drivers = drivers;
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
          title: const Text("Search Driver",),
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
                    searchDrivers(value);
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
                  child: isSearching ? drivers.length == 0 ? const Text("No results found",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: defaultTextColor1),): ListView.builder(
                      itemCount: drivers != null ? drivers.length : 0,
                      itemBuilder: (context,index){
                        items = drivers[index];
                        return SlideInUp(
                          animate: true,
                          child: Card(
                            elevation: 12,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              onTap: (){
                                // print(controller.allDrivers[index]['user']);
                                Get.to(()=> AddExpense(driver:drivers[index]['user'].toString()));
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(items['driver_profile_pic']),
                              ),
                              title: Text(items['get_drivers_full_name']),
                              subtitle: Text(items['username']),
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
