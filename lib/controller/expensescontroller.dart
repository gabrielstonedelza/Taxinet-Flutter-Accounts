import 'package:flutter/foundation.dart';
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ExpensesController extends GetxController{
  List expenses = [];
  List expensesToday = [];
  List expensesDates = [];
  List datesRequested = [];

  String userId = "";
  String amount = "";
  String reason = "";
  String requestStatus = "";

  String dateRequested = "";
  String timeRequested = "";
  bool isLoading = true;


  Future<void> getDetailExpense(String id) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/expense_detail/$id/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        final codeUnits = response.body;
        var jsonData = jsonDecode(codeUnits);
        userId = jsonData['user'].toString();
        amount = jsonData['amount'].toString();
        reason = jsonData['reason'];
        requestStatus = jsonData['request_status'];
        dateRequested = jsonData['date_requested'];
        timeRequested = jsonData['time_requested'];
        update();
      }
      else{
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

  Future<void> getAllExpenses() async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_all_expenses/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        expenses.assignAll(jsonData);
        for(var i in expenses){
          if(!expensesDates.contains(i['date_requested'])){
            expensesDates.add(i['date_requested']);
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

  Future<void> getAllExpensesToday() async {
    try {
      isLoading = true;
      const walletUrl = "https://taxinetghana.xyz/get_expenses_today/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        expensesToday.assignAll(jsonData);
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

  Future<void> getExpenseByDate(String dateRequested) async {
    try {
      isLoading = true;
      final walletUrl = "https://taxinetghana.xyz/get_expenses_get_by_date/$dateRequested/";
      var link = Uri.parse(walletUrl);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        datesRequested.assignAll(jsonData);
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