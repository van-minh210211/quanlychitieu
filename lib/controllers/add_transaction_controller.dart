import 'package:expense_management/controllers/home_controllers.dart';
import 'package:expense_management/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class AddTransactionController extends GetxController {
  final HomeControllers homeController = Get.find<HomeControllers>();

  var isExpense = true.obs;
  var selectedCategory = "Ăn uống".obs;
  var imagePath = "".obs; 
  
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Danh mục cho Khoản chi
  final List<Map<String, dynamic>> categories = [
    {"name": "Ăn uống", "icon": Icons.restaurant, "color": Colors.orange},
    {"name": "Di chuyển", "icon": Icons.directions_car, "color": Colors.blue},
    {"name": "Mua sắm", "icon": Icons.shopping_bag, "color": Colors.pink},
    {"name": "Giải trí", "icon": Icons.movie, "color": Colors.purple},
    {"name": "Khác", "icon": Icons.more_horiz, "color": Colors.grey},
  ];

  // Danh mục cho Khoản thu
  final List<Map<String, dynamic>> categories2 = [
    {"name": "Lương", "icon": Icons.payments, "color": Colors.green},
    {"name": "Affiliate", "icon": Icons.monetization_on, "color": Colors.amber},
    {"name": "Thưởng", "icon": Icons.card_giftcard, "color": Colors.redAccent},
    {"name": "Khác", "icon": Icons.more_horiz, "color": Colors.grey},
  ];

  // Hàm lấy danh sách đang hoạt động
  List<Map<String, dynamic>> get currentList => isExpense.value ? categories : categories2;

  void changeType(bool value) {
    isExpense.value = value;
    // Khi đổi tab, đặt lại danh mục được chọn là mục đầu tiên của danh sách đó
    selectedCategory.value = currentList[0]['name'];
    
    if (!value) imagePath.value = ""; 
  }

  void changeCategory(String categoryName) => selectedCategory.value = categoryName;

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      imagePath.value = photo.path;
    }
  }

  void saveTransaction() {
    if (amountController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập số tiền", 
        backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    double amountValue = double.parse(amountController.text.replaceAll('.', ''));
    
    // Tìm thông tin danh mục từ danh sách đang dùng
    var categoryData = currentList.firstWhere((cat) => cat['name'] == selectedCategory.value);

    TransactionModel newTransaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: selectedCategory.value,
      note: noteController.text,
      imgae: imagePath.value,
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
