import 'package:shared_preferences/shared_preferences.dart';

// Mock printer device for now
class PrinterDevice {
  final String name;
  final String address;

  PrinterDevice({required this.name, required this.address});
}

class PosPrinterService {
  static const String _lastPrinterKey = 'last_printer_address';

  Future<List<PrinterDevice>> scanForPrinters() async {
    try {
      // Mock implementation - return sample printers for demo
      return [
        PrinterDevice(name: 'طابعة 1', address: '00:11:22:33:44:55'),
        PrinterDevice(name: 'طابعة 2', address: '00:11:22:33:44:66'),
      ];
    } catch (e) {
      return [];
    }
  }

  Future<bool> connectToPrinter(PrinterDevice device) async {
    try {
      // Mock implementation - simulate connection delay
      await Future.delayed(const Duration(seconds: 1));
      await _saveLastPrinter(device);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> printOrder(Map<String, dynamic> orderData) async {
    try {
      // Mock implementation - show success message
      print('''
طلب رقم: ${orderData['orderId']}
رقم الطاولة: ${orderData['tableNumber']}
-----------------------------
${orderData['items'].map((item) => '${item['name']} x${item['quantity']} ${item['price']} د.ع').join('\n')}
-----------------------------
المجموع: ${orderData['total']} د.ع
      ''');

      // Simulate printing delay
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      throw Exception('فشل في الطباعة: $e');
    }
  }

  Future<PrinterDevice?> getLastConnectedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.getString(_lastPrinterKey);
    if (address != null) {
      return PrinterDevice(name: 'آخر طابعة', address: address);
    }
    return null;
  }

  Future<void> _saveLastPrinter(PrinterDevice device) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPrinterKey, device.address);
  }
}
