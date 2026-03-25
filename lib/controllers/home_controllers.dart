import 'package:expense_management/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeControllers extends GetxController {
  final _storage = GetStorage();
  final String _key = 'transactions';

  var selectedIndex = 0.obs;
  var totalBalance = 0.0.obs;
  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  var transactions = <TransactionModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }


  void fetchTransactions() {
    List? storedData = _storage.read<List>(_key);
    if (storedData != null) {
      transactions.value = storedData
          .map((e) => TransactionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    updateSummary();
  }
  void addTransaction(TransactionModel transaction) {
    transactions.insert(0, transaction);
    saveToDisk();
    updateSummary();
  }
  void deleteTransaction(int index) {
    transactions.removeAt(index);
    saveToDisk();
    updateSummary();
  }
  void saveToDisk() {
    _storage.write(_key, transactions.map((e) => e.toJson()).toList());
  }
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
