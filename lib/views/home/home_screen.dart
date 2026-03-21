import 'package:expense_management/controllers/home_controllers.dart';
import 'package:expense_management/views/add_transaction/add_transaction_view.dart';
import 'package:expense_management/views/history/history_view.dart';
import 'package:expense_management/views/home/dashboard_view.dart';
import 'package:expense_management/views/statistical/statistical_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllers controller = Get.put(HomeControllers());

    final List<Widget> _pages = [
      const DashboardView(),
      const HistoryView(),
      const StatisticalView(),
    ];

    return Scaffold(
      body: Obx(() => _pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.changeTabIndex(index),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Giao dịch'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Thống kê'),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddTransactionView()),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
