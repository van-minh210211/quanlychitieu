import 'dart:io';
import 'package:expense_management/controllers/add_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTransactionView extends StatelessWidget {
  const AddTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final AddTransactionController controller = Get.put(AddTransactionController());

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
          "Thêm giao dịch",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
              children: [
                _buildTypeButton(
                  title: "Khoản chi",
                  isSelected: controller.isExpense.value,
                  activeColor: Colors.redAccent,
                  onTap: () => controller.changeType(true),
                ),
                const SizedBox(width: 16),
                _buildTypeButton(
                  title: "Khoản thu",
                  isSelected: !controller.isExpense.value,
                  activeColor: Colors.green,
                  onTap: () => controller.changeType(false),
                ),
              ],
            )),
            const SizedBox(height: 32),
            Obx(() => Text(
              controller.isExpense.value ? "Số tiền chi tiêu" : "Số tiền thu nhập",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            )),
            const SizedBox(height: 8),
            Obx(() => TextField(
              controller: controller.amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CurrencyInputFormatter(),
              ],
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: controller.isExpense.value ? Colors.redAccent : Colors.green,
              ),
              decoration: const InputDecoration(
                hintText: "0",
                suffixText: "VNĐ",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            )),
            const Divider(height: 32, thickness: 1),
            
            // NÚT CHỤP ẢNH (CHỈ HIỆN KHI LÀ KHOẢN CHI)
            Obx(() {
              if (controller.isExpense.value) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Hình ảnh minh chứng", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => controller.takePhoto(),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!, width: 1),
                        ),
                        child: controller.imagePath.value.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text("Chụp ảnh hóa đơn", style: TextStyle(color: Colors.grey)),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(controller.imagePath.value),
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              }
              return const SizedBox();
            }),

            const Text("Danh mục", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              // SỬA LỖI Ở ĐÂY: Thêm Obx bao quanh ListView và dùng controller.currentList
              child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.currentList.length,
                itemBuilder: (context, index) {
                  final cat = controller.currentList[index];
                  return Obx(() {
                    bool isSelected = controller.selectedCategory.value == cat['name'];
                    return GestureDetector(
                      onTap: () => controller.changeCategory(cat['name']),
                      child: Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? cat['color'].withOpacity(0.15) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected ? Border.all(color: cat['color'], width: 2) : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(cat['icon'], color: isSelected ? cat['color'] : Colors.grey, size: 28),
                            const SizedBox(height: 8),
                            Text(cat['name'], style: TextStyle(fontSize: 12, color: isSelected ? Colors.black : Colors.grey, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          ],
                        ),
                      ),
                    );
                  });
                },
              )),
            ),
            const SizedBox(height: 32),
            const Text("Ghi chú", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Obx(() => TextField(
              controller: controller.noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Bạn đã chi tiêu vào việc gì?",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.edit_note, color: controller.isExpense.value ? Colors.redAccent : Colors.green, size: 28),
              ),
            )),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(() => ElevatedButton(
                onPressed: () => controller.saveTransaction(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isExpense.value ? Colors.redAccent : Colors.green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("LƯU GIAO DỊCH", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({required String title, required bool isSelected, required Color activeColor, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withOpacity(0.1) : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? activeColor : Colors.transparent, width: 2),
          ),
          child: Center(child: Text(title, style: TextStyle(color: isSelected ? activeColor : Colors.grey, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) return newValue;
    double value = double.parse(newValue.text);
    final formatter = NumberFormat.decimalPattern('vi');
    String newText = formatter.format(value);
    return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
  }
}
