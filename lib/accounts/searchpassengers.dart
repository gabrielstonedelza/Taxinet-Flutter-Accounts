import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../constants/app_colors.dart';
import '../controller/walletcontroller.dart';

class SearchPassenger extends StatefulWidget {
  const SearchPassenger({Key? key}) : super(key: key);

  @override
  State<SearchPassenger> createState() => _SearchPassengerState();
}

class _SearchPassengerState extends State<SearchPassenger> {
  final WalletController controller = Get.find();
  var items;
  late List passengers = [];
  bool isSearching = false;

  searchPassenger(String searchItem)async{
    final url = "https://taxinetghana.xyz/search_passenger?search=$searchItem";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

    if(response.statusCode ==200){
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      passengers = json.decode(jsonData);
      print(response.body);
    }
    else{
      print(response.body);
    }

    setState(() {
      // isSearching = false;
      passengers = passengers;
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
          title: const Text("Search Passenger",),
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
                    searchPassenger(value);
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
                  child: isSearching ? passengers.length == 0 ? const Text("No results found",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: defaultTextColor1),): ListView.builder(
                      itemCount: passengers != null ? passengers.length : 0,
                      itemBuilder: (context,index){
                        items = passengers[index];
                        return SlideInUp(
                          animate: true,
                          child: Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                onTap: (){
                                  // print(controller.allPassengers[index]['user']);
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.vertical(
                                            top: Radius.circular(25.0))),
                                    bounce: true,
                                    builder: (context) => SingleChildScrollView(
                                      controller: ModalScrollController.of(context),
                                      child: SizedBox(
                                          height: 500,
                                          child: Padding(
                                              padding: const EdgeInsets.all(18.0),
                                              child: ListView(
                                                children: [
                                                  const SizedBox(height:10),
                                                  const Center(
                                                      child: Text("Other Info",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                                                  ),
                                                  ListTile(
                                                      title: const Text("Email",),
                                                      subtitle: Text(items['get_passengers_email'])
                                                  ),
                                                  const Divider(),
                                                  // const SizedBox(height:5),
                                                  ListTile(
                                                      title: const Text("Phone Number",),
                                                      subtitle: Text(items['get_passengers_phone_number'])
                                                  ),
                                                  ListTile(
                                                      title: const Text("Next of kin",),
                                                      subtitle: Text(items['next_of_kin'])
                                                  ),
                                                  // const SizedBox(height:5),
                                                  const Divider(),
                                                  // const SizedBox(height:5),
                                                  ListTile(
                                                      title: const Text("Next of kin number",),
                                                      subtitle: Text(items['next_of_kin_number'])
                                                  ),
                                                  const Divider(),
                                                  // const SizedBox(height:5),
                                                  ListTile(
                                                      title: const Text("Referral",),
                                                      subtitle: Text(items['referral'])
                                                  ),
                                                  const Divider(),
                                                  // const SizedBox(height:5),

                                                  const Divider(),
                                                  // const SizedBox(height:5),
                                                  ListTile(
                                                      title: const Text("Unique Code",),
                                                      subtitle: Text(items['unique_code'])
                                                  ),
                                                ],
                                              )
                                          )
                                      ),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(items['passenger_profile_pic']),
                                ),
                                title: Text(items['get_passengers_full_name']),
                                subtitle: Text(items['username']),
                              )
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
