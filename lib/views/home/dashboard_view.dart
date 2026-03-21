import 'package:expense_management/controllers/home_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllers controller = Get.find<HomeControllers>();
    final currencyFormat = NumberFormat.decimalPattern('vi');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xin chào!', style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('Nhà phát triển', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildBalanceCard(
              currencyFormat.format(controller.totalBalance.value),
              currencyFormat.format(controller.totalIncome.value),
              currencyFormat.format(controller.totalExpense.value),
            )),
            const SizedBox(height: 24),
            const Text('Giao dịch gần đây', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.transactions.isEmpty) return const Center(child: Text("Chưa có giao dịch nào"));
                return ListView.builder(
                  itemCount: controller.transactions.length > 5 ? 5 : controller.transactions.length,
                  itemBuilder: (context, index) {
                    final item = controller.transactions[index];
                    return _buildTransactionItem(
                      item.icon,
                      item.title,
                      item.date,
                      "${item.isExpense ? '-' : '+'}${currencyFormat.format(item.amount)}đ",
                      item.color,
                      item.isExpense,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(String balance, String income, String expense) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.green[700], borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng số dư', style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 8),
          Text('$balance đ', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIncomeExpenseInfo(Icons.arrow_downward, 'Thu nhập', '+$income đ'),
              _buildIncomeExpenseInfo(Icons.arrow_upward, 'Chi tiêu', '-$expense đ'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseInfo(IconData icon, String label, String amount) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Text(amount, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionItem(IconData icon, String title, String date, String amount, Color iconColor, bool isExpense) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isExpense ? Colors.redAccent : Colors.green)),
      ),
    );
  }
}
