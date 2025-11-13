import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/item_size.dart';
import '../../domain/usecases/get_item_sizes.dart';

class AddItemFromMenuController extends GetxController {
  final GetItemSizes? _getItemSizes;
  bool _isLoading = false; // منع استدعاءات متعددة

  AddItemFromMenuController(this._getItemSizes);

  final RxInt quantity = 1.obs;
  final RxString itemId = ''.obs;
  final RxString itemName = ''.obs;
  final RxString itemPrice = ''.obs;
  final RxBool hasSize = false.obs;
  final RxInt selectedSizeIndex = 0.obs;
  final RxList<ItemSize> sizes = <ItemSize>[].obs;
  final RxBool isLoadingSizes = false.obs;
  final TextEditingController noteController = TextEditingController();

  void setItemDetails(String name, String price) {
    itemName.value = name;
    itemPrice.value = price;
  }

  void setSelectedSizeIndex(int index) {
    selectedSizeIndex.value = index;
  }

  Future<void> loadItemSizes(int itemId) async {
    if (_getItemSizes == null || _isLoading) return; // منع استدعاءات متعددة

    _isLoading = true;
    isLoadingSizes.value = true;
    try {
      final result = await _getItemSizes(itemId);
      result.fold(
        (failure) {
          Get.snackbar('خطأ', failure.message);
          sizes.value = [];
          hasSize.value = false;
        },
        (sizesList) {
          sizes.value = sizesList;
          hasSize.value = sizesList.isNotEmpty;
          if (sizesList.isNotEmpty) {
            selectedSizeIndex.value = 0;
          }
        },
      );
    } catch (e) {
      Get.snackbar('خطأ', 'خطأ غير متوقع: $e');
      sizes.value = [];
      hasSize.value = false;
    } finally {
      isLoadingSizes.value = false;
      _isLoading = false;
    }
  }

  ItemSize? get selectedSize {
    if (sizes.isEmpty || selectedSizeIndex.value >= sizes.length) {
      return null;
    }
    return sizes[selectedSizeIndex.value];
  }

  double get currentPrice {
    final selected = selectedSize;
    if (selected != null) {
      return selected.sizePrice;
    }
    // إذا لم يكن هناك مقاس محدد، استخدم السعر الأساسي
    return double.tryParse(itemPrice.value) ?? 0.0;
  }

  void incrementQuantity() {
    if (quantity.value < 99) {
      quantity.value++;
    }
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void addItem() {
    // Validation
    if (quantity.value < 1 || quantity.value > 99) {
      Get.snackbar('خطأ', 'الكمية يجب أن تكون بين 1 و 99');
      return;
    }

    // Print data to console
    print('Item Name: ${itemName.value}');
    print('Item Price: ${itemPrice.value}');
    print('Quantity: ${quantity.value}');
    print('Note: ${noteController.text}');
    if (hasSize.value) {
      print('Selected Size Index: ${selectedSizeIndex.value}');
    }

    // Close dialog
    Get.back();
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
