import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:taxinet_accounts/accounts/promoters.dart';
import 'package:taxinet_accounts/accounts/salarydrivers.dart';

import '../constants/app_colors.dart';
import 'drivers.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar:AppBar(
        backgroundColor:Colors.transparent,
        elevation:0,
        title: const Text("Please select",),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:10.0,right:10),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: const Text("Drivers Expense",style:TextStyle(fontWeight: FontWeight.bold,)),
                subtitle: const Text("Add new drivers expense"),
                  onTap: (){
                    Get.to(() => const AllDrivers());
                  }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right:10),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: (){
                  Get.to(()=> const SalaryDrivers());
                },
                  title: const Text("Monthly Salary",style:TextStyle(fontWeight: FontWeight.bold,)),
                  subtitle: const Text("Pay drivers monthly salary"),

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right:10),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                  onTap: (){
                    Get.to(()=> const Promoters());
                  },
                  title: const Text("Promoter Commission",style:TextStyle(fontWeight: FontWeight.bold,)),
                  subtitle: const Text("Payout promoters commission")
              ),
            ),
          ),
        ],
      )
    );
  }
}
