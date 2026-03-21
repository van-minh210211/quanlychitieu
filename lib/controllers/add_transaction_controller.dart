import 'package:expense_management/controllers/home_controllers.dart';
import 'package:expense_management/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionController extends GetxController {
  final HomeControllers homeController = Get.find<HomeControllers>();

  var isExpense = true.obs;
  var selectedCategory = "Ăn uống".obs;
  
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {"name": "Ăn uống", "icon": Icons.restaurant, "color": Colors.orange},
    {"name": "Di chuyển", "icon": Icons.directions_car, "color": Colors.blue},
    {"name": "Mua sắm", "icon": Icons.shopping_bag, "color": Colors.pink},
    {"name": "Giải trí", "icon": Icons.movie, "color": Colors.purple},
    {"name": "Khác", "icon": Icons.more_horiz, "color": Colors.grey},
  ];

  void changeType(bool value) => isExpense.value = value;
  void changeCategory(String categoryName) => selectedCategory.value = categoryName;

  void saveTransaction() {
    if (amountController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập số tiền", 
        backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    double amountValue = double.parse(amountController.text.replaceAll('.', ''));
    var categoryData = categories.firstWhere((cat) => cat['name'] == selectedCategory.value);

    // TẠO MODEL CHUẨN
    TransactionModel newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: selectedCategory.value,
      note: noteController.text,
      amount: amountValue,
      isExpense: isExpense.value,
      iconCode: (categoryData['icon'] as IconData).codePoint,
      colorValue: (categoryData['color'] as Color).value,
      date: DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
    );

    homeController.addTransaction(newTransaction);
    Get.back();
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
