import 'package:flutter/foundation.dart';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class PaymentsController extends GetxController{
  List payments = [];
  List paymentsToday = [];
  List paymentDates = [];
  List datesPaid = [];

  String driverId = "";
  String amount = "";
  String title = "";
  bool read = false;
  String datePaid = "";
  String timePaid = "";
  bool isLoading = true;


  Future<void> getDetailPayment(String id) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/admin_get_payment_detail/$id/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        final codeUnits = response.body;
        var jsonData = jsonDecode(codeUnits);
        driverId = jsonData['driver'].toString();
        amount = jsonData['amount'].toString();
        title = jsonData['title'];
        read = jsonData['read'];
        datePaid = jsonData['date_paid'];
        timePaid = jsonData['time_paid'];
        update();
      }
      else{
        if (kDebugMode) {
          print("this is coming from the schedule detail ${response.body}");
        }
        if (kDebugMode) {
          print("this is coming from the schedule detail ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getAllPayments() async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_all_payments_today/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        payments.assignAll(jsonData);
        for(var i in payments){
          if(!paymentDates.contains(i['date_paid'])){
            paymentDates.add(i['date_paid']);
          }
        }
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getAllPaymentsToday() async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_payments_today/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        paymentsToday.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> getPaymentsByDate(String datePaid) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/admin_get_all_drivers_payments_by_date/$datePaid/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        datesPaid.assignAll(jsonData);
        update();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    } finally {
      isLoading = false;
    }
  }

}