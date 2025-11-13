import 'package:dio/dio.dart';

/// استخراج رسالة الخطأ الفعلية من DioException
String extractErrorMessage(DioException e) {
  // محاولة استخراج الرسالة من response.data
  if (e.response?.data != null) {
    if (e.response!.data is String) {
      final errorString = e.response!.data as String;
      // إذا كانت الرسالة تحتوي على "Internal server error:"، نستخرج الجزء بعدها
      if (errorString.contains('Internal server error:')) {
        final parts = errorString.split('Internal server error:');
        if (parts.length > 1) {
          return parts[1].trim();
        }
      }
      return errorString;
    } else if (e.response!.data is Map) {
      final data = e.response!.data as Map;
      // البحث عن الرسالة في مفاتيح مختلفة محتملة
      if (data.containsKey('message')) {
        return data['message'].toString();
      } else if (data.containsKey('error')) {
        return data['error'].toString();
      } else if (data.containsKey('Message')) {
        return data['Message'].toString();
      } else if (data.containsKey('Error')) {
        return data['Error'].toString();
      }
    }
  }

  // إذا لم توجد رسالة في data، استخدم statusMessage
  if (e.response?.statusMessage != null &&
      e.response!.statusMessage!.isNotEmpty) {
    return e.response!.statusMessage!;
  }

  // كحل أخير، استخدم message من DioException
  return e.message ?? 'خطأ في الخادم';
}

