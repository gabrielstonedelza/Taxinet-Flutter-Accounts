import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:get/get.dart";
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:taxinet_accounts/accounts/searchwallet.dart';
import '../constants/app_colors.dart';
import '../controller/usercontroller.dart';
import '../controller/walletcontroller.dart';
import 'package:http/http.dart' as http;

class AllWallets extends StatefulWidget {
  const AllWallets({Key? key}) : super(key: key);

  @override
  State<AllWallets> createState() => _AllWalletsState();
}

class _AllWalletsState extends State<AllWallets> {
  final WalletController controller = Get.find();
  final UserController user = Get.find();
  var items;
  double initialWallet = 0;
  late final  TextEditingController newAmountController = TextEditingController();
  late final  TextEditingController newAmountController2 = TextEditingController();
  late final  TextEditingController reasonController = TextEditingController();
  late final  TextEditingController reasonController2 = TextEditingController();
  final FocusNode newAmountFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool isPosting = false;
  final storage = GetStorage();
  var username = "";
  String uToken = "";

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isPosting = false;
      newAmountController.text = "";
      Get.snackbar("Success", "Wallet was updated",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5)
      );
      Navigator.pop(context);
    });
  }

  addReason(String user,String amount) async {
    const salaryUrl = "https://taxinetghana.xyz/deduct_wallet/";
    final myLogin = Uri.parse(salaryUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "user": user,
          "amount": amount,
          "reason": reasonController.text
        });

    if (response.statusCode == 201) {

    }
    else {

      Get.snackbar(
          "Error 😢", response.body.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 8)
      );
      return;
    }
  }

  addWalletReason(String user,String amount) async {
    const salaryUrl = "https://taxinetghana.xyz/add_to_wallet/";
    final myLogin = Uri.parse(salaryUrl);

    http.Response response = await http.post(myLogin,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "user": user,
          "amount": amount,
          "reason": reasonController2.text
        });

    if (response.statusCode == 201) {

    }
    else {

      Get.snackbar(
          "Error 😢", response.body.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 8)
      );
      return;
    }
  }

  updateWallet(String id,String amount,String user)async {
    final requestUrl = "https://taxinetghana.xyz/admin_update_wallet/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      // "Authorization": "Token $uToken"
    }, body: {
      "amount" : amount,
      "user" : user
    });
    if(response.statusCode == 200){
      setState(() {
        newAmountController.text = "";
      });

      Get.snackbar("Success", "wallet was updated",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 5)
      );
    }
    else{
      if (kDebugMode) {
        // print(response.body);
      }
    }
  }

  updateAccountsWallet() async {
    final depositUrl = "https://taxinetghana.xyz/user_update_wallet/${user.userId}/";
    final myLink = Uri.parse(depositUrl);
    final res = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    }, body: {
      // "passenger": userid,
      "user": user.userId,
      "amount": initialWallet.toString(),
    });
    if (res.statusCode == 200) {
      Get.snackbar("Hurray 😀", "Transaction completed successfully.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: snackColor);
      // Get.to(()=> const Transfers());
    }
  }

  @override
  void initState(){
    super.initState();
    if (storage.read("userToken") != null) {
      uToken = storage.read("userToken");
    }
    if (storage.read("username") != null) {
      username = storage.read("username");
    }
    initialWallet = double.parse(controller.wallet);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation:0,
          title: const Text("Wallets",),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon:const Icon(Icons.arrow_back,color:defaultTextColor2)
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(()=> const SearchWallet());
                },
                icon:const Icon(Icons.search,color:defaultTextColor2)
            )
          ],
        ),
        body: GetBuilder<WalletController>(builder:(controller){
          return ListView.builder(
            itemCount: controller.allWallets != null ? controller.allWallets.length : 0,
            itemBuilder: (BuildContext context, int index) {
              items = controller.allWallets[index];
              return Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: items['get_profile_pic'] != null ? CircleAvatar(
                    backgroundImage: NetworkImage(items['get_profile_pic']),
                  ) : const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/user.png"),
                    radius: 20,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom:10.0,top:10),
                    child: Text(items['get_full_name']),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(items['get_username']),
                      const SizedBox(height:10),
                      Text(items['get_user_type']),
                      const SizedBox(height:10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  enableDrag: false,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.vertical(
                                          top: Radius.circular(25.0))),
                                  bounce: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: SingleChildScrollView(
                                      controller: ModalScrollController.of(context),
                                      child: SizedBox(
                                          height: 350,
                                          child: ListView(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          newAmountController.text = "";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(FontAwesomeIcons.times,size:30,color:Colors.red)
                                                  )
                                                ],
                                              ),
                                              Center(
                                                  child: Text("Update ${controller.allWallets[index]['get_username']}'s wallet",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                                              ),
                                              Center(
                                                  child: Text("(₵${controller.allWallets[index]['amount']})",style: const TextStyle(fontSize: 15))
                                              ),
                                              const SizedBox (height:20),
                                              Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Form(
                                                  key: _formKey1,
                                                  child:Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(color: Colors.grey, width: 1)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 8.0,right: 10),
                                                            child: TextFormField(
                                                              controller: newAmountController2,
                                                              focusNode: newAmountFocusNode,
                                                              autocorrect: true,
                                                              enableSuggestions: true,
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: "Enter amount",
                                                                hintStyle: TextStyle(color: defaultTextColor2,),
                                                              ),
                                                              cursorColor: defaultTextColor2,
                                                              style: const TextStyle(color: defaultTextColor2),
                                                              keyboardType: TextInputType.number,
                                                              textInputAction: TextInputAction.next,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return "Enter amount";
                                                                }
                                                                else{
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(color: Colors.grey, width: 1)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 8.0,right: 10),
                                                            child: TextFormField(
                                                              controller: reasonController2,

                                                              autocorrect: true,
                                                              enableSuggestions: true,
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: "Enter reason",
                                                                hintStyle: TextStyle(color: defaultTextColor2,),
                                                              ),
                                                              cursorColor: defaultTextColor2,
                                                              style: const TextStyle(color: defaultTextColor2),
                                                              keyboardType: TextInputType.text,
                                                              textInputAction: TextInputAction.next,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return "Enter reason";
                                                                }
                                                                else{
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              isPosting ? const Center(
                                                  child:CircularProgressIndicator.adaptive(
                                                    strokeWidth: 5,
                                                    backgroundColor: primaryColor,
                                                  )
                                              ) :  Padding(
                                                padding: const EdgeInsets.only(left:18.0,right:18),
                                                child: RawMaterialButton(
                                                  onPressed: () {

                                                    if (!_formKey1.currentState!.validate()) {
                                                      Get.snackbar("Error", "Something went wrong",
                                                          colorText: defaultTextColor1,
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: Colors.red
                                                      );
                                                      return;
                                                    } else {
                                                      _startPosting();
                                                      initialWallet = initialWallet - double.parse(newAmountController2.text);
                                                      double totalAmount = double.parse(controller.allWallets[index]['amount']) + double.parse(newAmountController2.text);
                                                      updateWallet(controller.allWallets[index]['id'].toString(),totalAmount.toString(),controller.allWallets[index]['user'].toString());
                                                      updateAccountsWallet();
                                                      addWalletReason(controller.allWallets[index]['user'].toString(),newAmountController2.text);
                                                    }
                                                  },
                                                  // child: const Text("Send"),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8)),
                                                  elevation: 8,
                                                  fillColor:
                                                  primaryColor,
                                                  splashColor:
                                                  defaultColor,
                                                  child: const Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 20,
                                                        color:
                                                        defaultTextColor1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_circle,size: 40,color:Colors.green)
                          ),
                          IconButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  isDismissible: false,
                                  enableDrag: false,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.vertical(
                                          top: Radius.circular(25.0))),
                                  bounce: true,
                                  builder: (context) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: SingleChildScrollView(
                                      controller: ModalScrollController.of(context),
                                      child: SizedBox(
                                          height: 450,
                                          child: ListView(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          newAmountController.text = "";
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(FontAwesomeIcons.times,size:30,color:Colors.red)
                                                  )
                                                ],
                                              ),
                                              Center(
                                                  child: Text("Deduct from ${controller.allWallets[index]['get_username']}'s wallet",style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                                              ),
                                              const SizedBox (height:10),
                                              Center(
                                                  child: Text("(₵${controller.allWallets[index]['amount']})",style: const TextStyle(fontSize: 15))
                                              ),
                                              const SizedBox (height:20),
                                              Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Form(
                                                  key: _formKey,
                                                  child:Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(color: Colors.grey, width: 1)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 8.0,right: 10),
                                                            child: TextFormField(
                                                              controller: newAmountController,
                                                              focusNode: newAmountFocusNode,
                                                              autocorrect: true,
                                                              enableSuggestions: true,
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: "Enter amount",
                                                                hintStyle: TextStyle(color: defaultTextColor2,),
                                                              ),
                                                              cursorColor: defaultTextColor2,
                                                              style: const TextStyle(color: defaultTextColor2),
                                                              keyboardType: TextInputType.number,
                                                              textInputAction: TextInputAction.next,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return "Enter amount";
                                                                }
                                                                else{
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 10.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(color: Colors.grey, width: 1)),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 8.0,right: 10),
                                                            child: TextFormField(
                                                              controller: reasonController,

                                                              autocorrect: true,
                                                              enableSuggestions: true,
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                hintText: "Enter reason",
                                                                hintStyle: TextStyle(color: defaultTextColor2,),
                                                              ),
                                                              cursorColor: defaultTextColor2,
                                                              style: const TextStyle(color: defaultTextColor2),
                                                              keyboardType: TextInputType.text,
                                                              textInputAction: TextInputAction.next,
                                                              validator: (value){
                                                                if(value!.isEmpty){
                                                                  return "Enter reason";
                                                                }
                                                                else{
                                                                  return null;
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              isPosting ? const Center(
                                                  child:CircularProgressIndicator.adaptive(
                                                    strokeWidth: 5,
                                                    backgroundColor: primaryColor,
                                                  )
                                              ) :  Padding(
                                                padding: const EdgeInsets.only(left:18.0,right:18),
                                                child: RawMaterialButton(
                                                  onPressed: () {

                                                    if (!_formKey.currentState!.validate()) {
                                                      Get.snackbar("Error", "Something went wrong",
                                                          colorText: defaultTextColor1,
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: Colors.red
                                                      );
                                                      return;
                                                    } else {
                                                      _startPosting();
                                                      initialWallet = initialWallet + double.parse(newAmountController.text);
                                                      double totalAmount = double.parse(controller.allWallets[index]['amount']) - double.parse(newAmountController.text);
                                                      updateWallet(controller.allWallets[index]['id'].toString(),totalAmount.toString(),controller.allWallets[index]['user'].toString());
                                                      updateAccountsWallet();
                                                      addReason(controller.allWallets[index]['user'].toString(),newAmountController.text);
                                                    }
                                                  },
                                                  // child: const Text("Send"),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          8)),
                                                  elevation: 8,
                                                  fillColor:
                                                  primaryColor,
                                                  splashColor:
                                                  defaultColor,
                                                  child: const Text(
                                                    "Update",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 20,
                                                        color:
                                                        defaultTextColor1),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: Image.asset("assets/images/remove.png",width:40,height:40,fit:BoxFit.cover)
                          )
                        ],
                      )
                    ],
                  ),
                  trailing: Text("₵${items['amount']}",style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
