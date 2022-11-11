
import "package:flutter/material.dart";
import "package:get/get.dart";

import '../constants/app_colors.dart';

import '../controller/stockscontroller.dart';
import 'addnewstock.dart';



class Stocks extends StatefulWidget {
  const Stocks({Key? key}) : super(key: key);

  @override
  State<Stocks> createState() => _StocksState();
}

class _StocksState extends State<Stocks> {

  final StocksController controller = Get.find();
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
          title: const Text("Stocks",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
        ),
        body: GetBuilder<StocksController>(builder:(controller){
          return ListView.builder(
            itemCount: controller.allStocks != null ? controller.allStocks.length : 0,
            itemBuilder: (BuildContext context, int index) {
              items = controller.allStocks[index];
              return Padding(
                padding: const EdgeInsets.only(left:18.0,right:18),
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom:8.0),
                      child: Row(
                        children: [
                          const Text("Item Name: ",style:TextStyle(fontWeight: FontWeight.bold,)),
                          Text(items['item_name']),
                        ],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text("quantity: ",style:TextStyle(fontWeight: FontWeight.bold,)),
                            Text(items['quantity'].toString()),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:10.0),
                          child: Text(items['date_added']),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor:Colors.black,
          onPressed: () {
            Get.to(()=>const AddStock());
          },
          child: const Icon(Icons.add_circle)
        ),
      ),
    );
  }
}
