import 'package:expense_management/controllers/home_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class StatisticalView extends StatelessWidget {
  const StatisticalView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllers controller = Get.find<HomeControllers>();
    final currencyFormat = NumberFormat.decimalPattern('vi');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Thống kê chi tiêu", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return const Center(child: Text("Chưa có dữ liệu để thống kê"));
        }

        Map<String, double> categoryData = {};
        for (var item in controller.transactions) {
          if (item.isExpense) {
            categoryData[item.title] = (categoryData[item.title] ?? 0) + item.amount;
          }
        }

        if (categoryData.isEmpty) {
          return const Center(child: Text("Chưa có khoản chi nào"));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: categoryData.entries.map((entry) {
                      var firstMatch = controller.transactions.firstWhere((t) => t.title == entry.key);
                      return PieChartSectionData(
                        color: firstMatch.color,
                        value: entry.value,
                        title: '${(entry.value / controller.totalExpense.value * 100).toStringAsFixed(1)}%',
                        radius: 50,
                        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Chi tiết chi tiêu", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: categoryData.entries.map((entry) {
                    var firstMatch = controller.transactions.firstWhere((t) => t.title == entry.key);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: firstMatch.color, child: Icon(firstMatch.icon, color: Colors.white, size: 20)),
                        title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text("${currencyFormat.format(entry.value)} đ", 
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
