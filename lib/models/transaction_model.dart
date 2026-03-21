import 'package:flutter/material.dart';

class TransactionModel {
  String id;
  String title;
  String note;
  double amount;
  bool isExpense;
  int iconCode;
  int colorValue;
  String date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.note,
    required this.amount,
    required this.isExpense,
    required this.iconCode,
    required this.colorValue,
    required this.date,
  });

  // Chuyển Object thành Map để lưu vào máy (Json)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'amount': amount,
        'isExpense': isExpense,
        'iconCode': iconCode,
        'colorValue': colorValue,
        'date': date,
      };

  // Chuyển Map từ máy thành Object để dùng trong code
  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'],
        title: json['title'],
        note: json['note'],
        amount: json['amount'],
        isExpense: json['isExpense'],
        iconCode: json['iconCode'],
        colorValue: json['colorValue'],
        date: json['date'],
      );

  // Hàm tiện ích lấy IconData và Color thật từ mã số
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);
}
