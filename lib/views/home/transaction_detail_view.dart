import 'dart:io';
import 'package:expense_management/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionDetailView extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.decimalPattern('vi');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Chi tiết giao dịch",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: transaction.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(transaction.icon, color: transaction.color, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    transaction.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${transaction.isExpense ? '-' : '+'}${currencyFormat.format(transaction.amount)}đ",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: transaction.isExpense ? Colors.redAccent : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
             SizedBox(height: 40),
            _buildDetailRow("Ngày thực hiện", transaction.date),
             Divider(height: 32),
            _buildDetailRow("Loại giao dịch", transaction.isExpense ? "Khoản chi" : "Khoản thu"),
             Divider(height: 32),
            

             Text(
              "Ghi chú",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
             SizedBox(height: 8),
            Text(
              transaction.note.isEmpty ? "Không có ghi chú" : transaction.note,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
             SizedBox(height: 32),
            if (transaction.imgae.isNotEmpty) ...[
              const Text(
                "Hình ảnh minh chứng",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(transaction.imgae),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: const Center(child: Text("Không tìm thấy ảnh")),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
