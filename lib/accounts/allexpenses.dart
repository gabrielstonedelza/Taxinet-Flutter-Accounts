import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";

import '../constants/app_colors.dart';
import '../controller/expensescontroller.dart';
import 'expensedetail.dart';

class AllExpenses extends StatefulWidget {
  const AllExpenses({Key? key}) : super(key: key);

  @override
  State<AllExpenses> createState() => _AllExpensesState();
}

class _AllExpensesState extends State<AllExpenses> {
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
          title: const Text("All Expenses",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body: GetBuilder<ExpensesController>(builder:(controller){
          return ListView.builder(
              itemCount: controller.expensesDates != null ? controller.expensesDates.length : 0,
              itemBuilder: (context,index){
                items = controller.expensesDates[index];
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
                          onTap: (){
                            Get.to(() => ExpenseDetail(requested_date:controller.expensesDates[index]));
                          },
                          title: Text(items),
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