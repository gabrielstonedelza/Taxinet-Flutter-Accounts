
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet_accounts/accounts/searchdrivers.dart';

import '../constants/app_colors.dart';
import '../controller/requestscontroller.dart';
import 'addexpense.dart';


class AllDrivers extends StatefulWidget {
  const AllDrivers({Key? key}) : super(key: key);

  @override
  State<AllDrivers> createState() => _AllDriversState();
}

class _AllDriversState extends State<AllDrivers> {

  final RequestController controller = Get.find();
  var items;

  @override
  void initState(){
    super.initState();
    // print(controller.allDrivers);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: const Text("Drivers",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(()=> const SearchDriver());
                },
                icon:const Icon(Icons.search,color:defaultTextColor2)
            )
          ],
        ),
        body: GetBuilder<RequestController>(builder:(controller){
          return ListView.builder(
            itemCount: controller.allDrivers != null ? controller.allDrivers.length : 0,
            itemBuilder: (BuildContext context, int index) {
              items = controller.allDrivers[index];
              return Padding(
                padding: const EdgeInsets.only(left:18.0,right:18),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: (){
                      // print(controller.allDrivers[index]['user']);
                      Get.to(()=> AddExpense(driver:controller.allDrivers[index]['user'].toString()));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(items['driver_profile_pic']),
                    ),
                    title: Text(items['get_drivers_full_name']),
                    subtitle: Text(items['username']),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
