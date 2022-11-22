import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:taxinet_accounts/accounts/searchdrivers.dart';

import '../constants/app_colors.dart';
import '../controller/requestscontroller.dart';
import '../controller/usercontroller.dart';
import 'callforinspection.dart';


class DriversForInspection extends StatefulWidget {
  const DriversForInspection({Key? key}) : super(key: key);

  @override
  State<DriversForInspection> createState() => _DriversForInspectionState();
}

class _DriversForInspectionState extends State<DriversForInspection> {
  final UserController userController = Get.find();
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
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: (){
                      Get.to(() => CallForInspection(phone:controller.allDrivers[index]['get_drivers_phone_number'],driver:controller.allDrivers[index]['user'].toString()));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(items['driver_profile_pic']),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom:10.0,top:10),
                      child: Text(items['get_drivers_full_name']),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:8.0),
                          child: Text(items['username']),
                        ),
                        const Text("Tap for inspection"),
                      ],
                    ),
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
