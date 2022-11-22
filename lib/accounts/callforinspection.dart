import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import '../constants/app_colors.dart';
import '../homepage.dart';


class CallForInspection extends StatefulWidget {
  final driver;
  const CallForInspection({Key? key,required this.driver}) : super(key: key);

  @override
  State<CallForInspection> createState() => _CallForInspectionState(driver:this.driver);
}

class _CallForInspectionState extends State<CallForInspection> {
  final driver;
  _CallForInspectionState({required this.driver});
  List inspectionDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String currentSelectedDay = "Monday";

  late final  TextEditingController timeController = TextEditingController();
  final FocusNode timeFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  bool isPosting = false;
  late DateTime _dateTime;
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 6, minute: 00);

  void _startPosting()async{
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  callForInspection() async {
    const requestUrl = "https://taxinetghana.xyz/call_for_inspection/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',

    }, body: {
      "driver": driver,
      "day_for_inspection": currentSelectedDay,
      "time_for_inspection": timeController.text,
    });
    if (response.statusCode == 201) {
      Get.offAll(() => const HomePage());
      Get.snackbar("Success 😀", "",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryColor,
          colorText: defaultTextColor2);
    }
    else{
      if (kDebugMode) {
        print(response.body);
      }
      Get.snackbar("Sorry 😢", "something went wrong,please try again later.",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: defaultTextColor2);
    }
  }



  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text("Call for Inspection"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
                key:_formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Select Day",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: defaultTextColor2)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: DropdownButton(
                            dropdownColor: defaultTextColor1,
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: const TextStyle(
                                color: defaultTextColor2, fontSize: 20),
                            items: inspectionDays.map((dropDownStringItem) {
                              return DropdownMenuItem(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            onChanged: (newValueSelected) {
                              _onDropDownSelectedDay(newValueSelected);
                            },
                            value: currentSelectedDay,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        controller: timeController,
                        cursorColor: primaryColor,
                        cursorRadius: const Radius.elliptical(10, 10),
                        cursorWidth: 10,
                        readOnly: true,
                        style: const TextStyle(color: defaultTextColor2),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.access_time,color: secondaryColor,),
                              onPressed: (){
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                                  setState(() {
                                    _timeOfDay = value!;
                                    timeController.text = _timeOfDay.format(context).toString();
                                  });
                                });
                              },
                            ),
                            labelText: "Click on icon to pick up time",
                            labelStyle: const TextStyle(color: defaultTextColor2),

                            focusColor: primaryColor,
                            fillColor: primaryColor,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please pick a start date";
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 5),

                    isPosting ? const Center(
                        child: CircularProgressIndicator.adaptive(strokeWidth:5,backgroundColor:primaryColor)
                    ) : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black,
                      ),
                      height: size.height * 0.06,
                      width: size.width * 0.6,
                      child: RawMaterialButton(
                        onPressed: () {
                          _startPosting();
                          if (_formKey.currentState!.validate()) {
                            callForInspection();
                          } else {
                            Get.snackbar("Error", "Something went wrong",
                                colorText: defaultTextColor2,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red
                            );
                            return;
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 8,
                        fillColor: Colors.black,
                        splashColor: defaultColor,
                        child: const Text(
                          "Send",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: defaultTextColor1),
                        ),
                      ),
                    )
                  ],
                )
            ),
          )
        ],
      ),
    );
  }

  void _onDropDownSelectedDay(newValueSelected) {
    setState(() {
      currentSelectedDay = newValueSelected;
    });
  }
}
