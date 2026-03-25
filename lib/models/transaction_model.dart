import 'package:flutter/material.dart';

class TransactionModel {
  String id;
  String title;
  String note;
  String imgae;
  double amount;
  bool isExpense;
  int iconCode;
  int colorValue;
  String date;

  TransactionModel({
    required this.id,
    required this.title,
    required this.note,
    required this.imgae,
    required this.amount,
    required this.isExpense,
    required this.iconCode,
    required this.colorValue,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'imgae': imgae,
        'amount': amount,
        'isExpense': isExpense,
        'iconCode': iconCode,
        'colorValue': colorValue,
        'date': date,
      };


  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'],
        title: json['title'],
        note: json['note'],
        imgae: json['imgae'],
        amount: json['amount'],
        isExpense: json['isExpense'],
        iconCode: json['iconCode'],
        colorValue: json['colorValue'],
        date: json['date'],
      );

  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);
}
