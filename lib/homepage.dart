import 'dart:async';

import 'package:animate_do/animate_do.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:get_storage/get_storage.dart';
import 'package:taxinet_accounts/shimmers/shimmerwidget.dart';
import 'accounts/addexpenselists.dart';
import 'accounts/alldrivers.dart';
import 'accounts/allusers.dart';
import 'accounts/driversforinspection.dart';
import 'accounts/expensetoday.dart';
import 'accounts/extras.dart';
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
    requestController.fetchUsers();
    requestController.fetchBlockedUsers();
    userController.getUserProfile(uToken);
    userController.getAllUsers();
    userController.getAllDrivers();
    userController.getAllPassengers();
    userController.getUserDetails(uToken);
    walletController.getAllWallet();
    walletController.getUserWallet(uToken);
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
      requestController.fetchUsers();
      requestController.fetchBlockedUsers();
      userController.getUserProfile(uToken);
      userController.getAllUsers();
      userController.getAllDrivers();
      userController.getAllPassengers();
      userController.getUserDetails(uToken);
      walletController.getAllWallet();
      walletController.getUserWallet(uToken);
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
        body: SlideInUp(
          animate: true,
          child: ListView(
            children: [
              const SizedBox(height:20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: (){
                        Get.to(()=> const AllUsers());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom:18.0),
                        child: Image.asset("assets/images/group.png",width:60,height:60,fit: BoxFit.cover,),
                      )),
                  const SizedBox(width:40),
                  Center(child:
                  GetBuilder<WalletController>(builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.account_balance_wallet),
                        const SizedBox(width: 10),
                        walletController.isLoading
                            ? const ShimmerWidget.rectangular(
                            width: 100, height: 20)
                            : Text("GHS ${walletController.wallet}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                    );
                  })
                  ),
                ],
              ),
              const SizedBox(width:20),
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
              const SizedBox(height: 10,),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left:18.0,right:18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          Get.to(() => const DriversForInspection());
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
                                  Image.asset("assets/images/inspection.png",width:42),
                                  const SizedBox(height:20),
                                  const Text("Inspection",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
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
                          Get.to(() => const AllDriversExtras());
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
                                  Image.asset("assets/images/extra.png",width:42),
                                  const SizedBox(height:20),
                                  const Text("Driver's Extra",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),)
                                ]
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height:20),
            ],
          ),
        )
      ),
    );
  }
}
