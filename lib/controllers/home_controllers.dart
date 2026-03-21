import 'package:expense_management/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeControllers extends GetxController {
  final _storage = GetStorage();
  final String _key = 'expense_data_v4'; // Sử dụng Key mới cho cấu trúc Model chuẩn

  var selectedIndex = 0.obs;
  var totalBalance = 0.0.obs;
  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  
  // Danh sách các TransactionModel thực tế
  var transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  // Tải dữ liệu từ bộ nhớ máy
  void fetchTransactions() {
    List? storedData = _storage.read<List>(_key);
    if (storedData != null) {
      transactions.value = storedData
          .map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    updateSummary();
  }

  // Thêm giao dịch mới (Dùng Model)
  void addTransaction(TransactionModel transaction) {
    transactions.insert(0, transaction);
    saveToDisk();
    updateSummary();
  }

  // Xóa giao dịch
  void deleteTransaction(int index) {
    transactions.removeAt(index);
    saveToDisk();
    updateSummary();
  }

  // Lưu xuống máy
  void saveToDisk() {
    _storage.write(_key, transactions.map((e) => e.toJson()).toList());
  }

  // Tự động tính toán số dư
  void updateSummary() {
    double income = 0;
    double expense = 0;

    for (var item in transactions) {
      if (item.isExpense) {
        expense += item.amount;
      } else {
        income += item.amount;
      }
    }

    totalIncome.value = income;
    totalExpense.value = expense;
    totalBalance.value = income - expense;
  }
}
