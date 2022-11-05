import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import '../constants/app_colors.dart';
import '../controller/expensescontroller.dart';
import 'allexpenses.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
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
            title: const Text("Expenses Today",),
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
            ),
          ),
          body: GetBuilder<ExpensesController>(builder: (controller){
            return ListView.builder(
                itemCount: controller.expensesToday != null ? controller.expensesToday.length : 0,
                itemBuilder: (context,index){
                  items = controller.expensesToday[index];
                  return SlideInUp(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                          elevation: 12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(

                            title: Text(items['get_username']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text("GHS ${items['amount']}"),
                                const SizedBox(height: 5),
                                Text(items['reason']),
                                const SizedBox(height: 5),
                                Text(items['date_requested']),
                                const SizedBox(height: 5),
                                Text(items['time_requested'].toString().split(".").first),
                              ],
                            ),
                          )
                      ),
                    ),

                  );
                }
            );
          }),
          floatingActionButton:FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: (){
                Get.to(()=> const AllExpenses());
              },
              child: const Text("All")
          )
      ),
    );
  }
}