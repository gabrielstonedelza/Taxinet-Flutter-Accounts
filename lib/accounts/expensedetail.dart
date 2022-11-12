import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import '../constants/app_colors.dart';
import '../controller/expensescontroller.dart';

class ExpenseDetail extends StatefulWidget {
  final requested_date;
  const ExpenseDetail({Key? key,required this.requested_date}) : super(key: key);

  @override
  State<ExpenseDetail> createState() => _ExpenseDetailState(requested_date:this.requested_date);
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  final requested_date;
  _ExpenseDetailState({required this.requested_date});

  final ExpensesController controller = Get.find();
  var items;

  @override
  void initState(){
    super.initState();
    controller.getExpenseByDate(requested_date);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: const Text("Expenses",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body: GetBuilder<ExpensesController>(builder:(controller){
          return ListView.builder(
              itemCount: controller.datesRequested != null ? controller.datesRequested.length : 0,
              itemBuilder: (context,index){
                items = controller.datesRequested[index];
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
                            padding: const EdgeInsets.only(top:10.0,bottom:10.0),
                            child: Row(
                              children: [
                                const Text("Driver: ",style:TextStyle(fontWeight: FontWeight.bold,)),
                                Text(items['get_username']),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Item Name: ",style:TextStyle(fontWeight: FontWeight.bold,)),
                                  Text(items['item_name']),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("quantity: ",style:TextStyle(fontWeight: FontWeight.bold,)),
                                  Text(items['quantity'].toString()),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Amount: ",style:TextStyle(fontWeight: FontWeight.bold,)),
                                  Text("GHS ${items['amount']}"),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text("Reason: ",style:TextStyle(fontWeight: FontWeight.bold,)),
                                  Text(items['reason']),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(items['date_requested']),
                                  const SizedBox(height: 5),
                                  Text(items['time_requested'].toString().split(".").first),
                                ],
                              ),
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
