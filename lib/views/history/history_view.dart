import 'package:expense_management/controllers/home_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllers controller = Get.find<HomeControllers>();
    final currencyFormat = NumberFormat.decimalPattern('vi');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Lịch sử giao dịch", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return const Center(child: Text("Chưa có giao dịch nào"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final item = controller.transactions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color),
                ),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item.date),
                trailing: Text(
                  "${item.isExpense ? '-' : '+'}${currencyFormat.format(item.amount)}đ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: item.isExpense ? Colors.redAccent : Colors.green,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
