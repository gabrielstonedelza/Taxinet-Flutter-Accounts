
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:taxinet_accounts/accounts/searchpromoters.dart';

import '../constants/app_colors.dart';
import '../controller/requestscontroller.dart';
import 'addpromotercommission.dart';


class Promoters extends StatefulWidget {
  const Promoters({Key? key}) : super(key: key);

  @override
  State<Promoters> createState() => _PromotersState();
}

class _PromotersState extends State<Promoters> {
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
          title: const Text("Promoters",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
          // actions: [
          //   IconButton(
          //       onPressed: () {
          //         Get.to(()=> const SearchPromoter());
          //       },
          //       icon:const Icon(Icons.search,color:defaultTextColor2)
          //   )
          // ],
        ),
        body: GetBuilder<RequestController>(builder:(controller){
          return Padding(
            padding: const EdgeInsets.only(left:10.0,right:10),
            child: ListView.builder(
              itemCount: controller.promoters != null ? controller.promoters.length : 0,
              itemBuilder: (BuildContext context, int index) {
                items = controller.promoters[index];
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      onTap: (){
                        Get.to(()=> AddPromoterCommission(promoter:controller.promoters[index]['user'].toString(),username:controller.promoters[index]['get_username']));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(items['promoter_profile_pic']),
                      ),
                      title: Text(items['get_full_name']),
                      subtitle: Text(items['get_username']),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
