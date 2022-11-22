import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import '../constants/app_colors.dart';
import '../controller/extracontroller.dart';

class AllDriversExtras extends StatefulWidget {
  const AllDriversExtras({Key? key}) : super(key: key);

  @override
  State<AllDriversExtras> createState() => _AllDriversExtrasState();
}

class _AllDriversExtrasState extends State<AllDriversExtras> {
  // final ExpensesController controller = Get.find();
  var items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: const Text("All Extra Modes",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body: GetBuilder<ExtraController>(builder:(controller){
          return ListView.builder(
              itemCount: controller.allExtras != null ? controller.allExtras.length : 0,
              itemBuilder: (context,index){
                items = controller.allExtras[index];
                return SlideInUp(
                  animate: true,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                        elevation: 12,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom:10.0),
                            child: Text(items['get_username'],style:const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          subtitle: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom:8.0),
                                child: Text(items['date_paid']),
                              ),
                              Text(items['time_paid']),
                            ],
                          ),
                        )
                    ),
                  ),

                );
              }
          );
        }),

      ),
    );
  }
}