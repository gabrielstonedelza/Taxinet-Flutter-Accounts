import 'dart:async';

import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:get_storage/get_storage.dart';
import 'accounts/addexpenselists.dart';
import 'accounts/alldrivers.dart';
import 'accounts/drivers.dart';
import 'accounts/expensetoday.dart';
import 'accounts/passengers.dart';
import 'accounts/stocks.dart';
import 'accounts/userregistration.dart';
import 'accounts/wallets.dart';
import 'constants/app_colors.dart';
import 'controller/expensescontroller.dart';
import 'controller/inventoriescontroller.dart';
import 'controller/requestscontroller.dart';
import 'controller/stockscontroller.dart';
import 'controller/usercontroller.dart';
import 'controller/walletcontroller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserController userController = Get.find();
  final WalletController walletController = Get.find();
  final ExpensesController expensesController = Get.find();
  final RequestController requestController = Get.find();
  final InventoriesController inventoriesController = Get.find();
  final StocksController stocksController = Get.find();
  late Timer _timer;

  final storage = GetStorage();

  late String username = "";

  late String uToken = "";

  late String userid = "";

  @override
  void initState() {
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    if (storage.read("userid") != null) {
      userid = storage.read("userid");
    }

    inventoriesController.getAllInventories();
    inventoriesController.getAllInventoriesToday();
    requestController.getActiveSchedules();
    requestController.getAllSchedules();
    requestController.getOneTimeSchedules();
    requestController.getDailySchedules();
    requestController.getDaysSchedules();
    requestController.getWeeklySchedules();
    requestController.getAllDrivers();
    requestController.getAllPassengers();
    requestController.getAllInvestors();
    requestController.getAllAssignedDrivers();
    requestController.getAllPromoters();
    userController.getUserProfile(uToken);
    userController.getAllUsers();
    userController.getAllDrivers();
    userController.getAllPassengers();
    walletController.getAllWallet();
    expensesController.getAllExpenses();
    expensesController.getAllExpensesToday();
    stocksController.getAllStocks();

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      inventoriesController.getAllInventories();
      inventoriesController.getAllInventoriesToday();
      requestController.getActiveSchedules();
      requestController.getAllSchedules();
      requestController.getOneTimeSchedules();
      requestController.getDailySchedules();
      requestController.getDaysSchedules();
      requestController.getWeeklySchedules();
      requestController.getAllDrivers();
      requestController.getAllPassengers();
      requestController.getAllInvestors();
      requestController.getAllAssignedDrivers();
      requestController.getAllPromoters();
      userController.getUserProfile(uToken);
      userController.getAllUsers();
      userController.getAllDrivers();
      userController.getAllPassengers();
      walletController.getAllWallet();
      expensesController.getAllExpenses();
      expensesController.getAllExpensesToday();
      stocksController.getAllStocks();
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width:40),
            Padding(
              padding: const EdgeInsets.only(left:18.0,right:18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(() => const ExpenseList());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/budget.png",width:42),
                                const SizedBox(height:20),
                                const Text("Add Expense",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:20),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(() => const Expenses());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/budget.png",width:42,height: 42,),
                                const SizedBox(height:20),
                                const Text("View Expenses",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:18.0,right:18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(() => const AllWallets());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/wallet.png",width:42),
                                const SizedBox(height:20),
                                const Text("Wallets",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:20),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(() => const Stocks());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/inventory.png",width:42),
                                const SizedBox(height:20),
                                const Text("Stocks",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:18.0,right:18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(() => const Drivers());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/taxi-driver.png",width:42),
                                const SizedBox(height:20),
                                const Text("Drivers",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:20),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(() => const Passengers());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/passenger.png",width:42),
                                const SizedBox(height:20),
                                const Text("Passengers",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left:18.0,right:18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.to(() => const Registration());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/register.png",width:42),
                                const SizedBox(height:20),
                                const Text("Register User",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width:20),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        // Get.to(() => const Stocks());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(
                          height:130,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/images/investor.png",width:42),
                                const SizedBox(height:20),
                                const Text("Investors",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}
