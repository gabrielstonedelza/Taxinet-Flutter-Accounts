import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../constants/app_colors.dart';
import '../controller/walletcontroller.dart';
import 'addexpense.dart';
import 'addpromotercommission.dart';

class SearchPromoter extends StatefulWidget {
  const SearchPromoter({Key? key}) : super(key: key);

  @override
  State<SearchPromoter> createState() => _SearchPromoterState();
}

class _SearchPromoterState extends State<SearchPromoter> {
  final WalletController controller = Get.find();
  var items;
  late List promoters = [];
  bool isSearching = false;

  searchPromoters(String searchItem)async{
    final url = "https://taxinetghana.xyz/search_promoter?search=$searchItem";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if(response.statusCode ==200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      promoters = json.decode(jsonData);
      print(promoters);
    }
    else{

    }

    setState(() {
      // isSearching = false;
      promoters = promoters;
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
          title: const Text("Search Promoter",),
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
                    searchPromoters(value);
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
                  child: isSearching ? promoters.length == 0 ? const Text("No results found",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: defaultTextColor1),): ListView.builder(
                      itemCount: promoters != null ? promoters.length : 0,
                      itemBuilder: (context,index){
                        items = promoters[index];
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
                                Get.to(()=> AddPromoterCommission(promoter:promoters[index]['user'].toString(),username:promoters[index]['get_username']));
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(items['promoter_profile_pic']),
                              ),
                              title: Text(items['get_full_name']),
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
