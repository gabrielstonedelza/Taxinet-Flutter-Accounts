import 'dart:async';

import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:get_storage/get_storage.dart';
import 'accounts/drivers.dart';
import 'accounts/expensetoday.dart';
import 'accounts/wallets.dart';
import 'constants/app_colors.dart';
import 'controller/expensescontroller.dart';
import 'controller/inventoriescontroller.dart';
import 'controller/requestscontroller.dart';
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
    userController.getUserProfile(uToken);
    userController.getAllUsers();
    userController.getAllDrivers();
    userController.getAllPassengers();
    walletController.getAllWallet();
    expensesController.getAllExpenses();
    expensesController.getAllExpensesToday();

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
      userController.getUserProfile(uToken);
      userController.getAllUsers();
      userController.getAllDrivers();
      userController.getAllPassengers();
      walletController.getAllWallet();
      expensesController.getAllExpenses();
      expensesController.getAllExpensesToday();
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
                        Get.to(() => const AllDrivers());
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
                        // Get.to(() => const Registration());
                      },
                      child: Card(
                        elevation: 12,
                        child: Container(

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
