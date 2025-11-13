# Company API Integration

## Overview

تم دمج API جديد لجلب معلومات الشركة في شاشة تسجيل الدخول.

## API Endpoint

- **URL**: `http://151.236.164.137:1004/api/Getcompinfo`
- **Method**: GET
- **Response**: معلومات الشركة (ID، الاسم، الشعار)

## Files Added/Modified

### New Files

1. `lib/features/auth/domain/entities/company.dart` - Company entity
2. `lib/features/auth/data/models/company_model.dart` - Company model for JSON serialization
3. `lib/features/auth/domain/usecases/get_comp_info.dart` - Use case for fetching company info

### Modified Files

1. `lib/core/network/api_constants.dart` - Added new API endpoint
2. `lib/core/network/api_client.dart` - Added getCompInfo method
3. `lib/features/auth/data/datasources/auth_remote_data_source.dart` - Added company data source method
4. `lib/features/auth/domain/repositories/auth_repository.dart` - Added company repository method
5. `lib/features/auth/data/repositories/auth_repository_impl.dart` - Implemented company repository method
6. `lib/features/auth/presentation/states/login_state.dart` - Added loadingCompInfo state
7. `lib/features/auth/presentation/controllers/login_controller.dart` - Added company info loading and storage
8. `lib/features/auth/presentation/bindings/login_binding.dart` - Added GetCompInfo use case
9. `lib/features/auth/presentation/pages/login_page.dart` - Added company info display

## Features

- جلب معلومات الشركة عند دخول شاشة تسجيل الدخول
- عرض شعار الشركة (إذا كان متوفراً) أو أيقونة افتراضية
- عرض اسم الشركة باللون الأبيض
- معالجة الأخطاء عند فشل جلب معلومات الشركة
- عرض حالة التحميل أثناء جلب البيانات

## UI Layout

- شعار التطبيق (wafy_logo.png) في الأعلى
- معلومات الشركة (الشعار والاسم) في المنتصف
- فورم تسجيل الدخول في الأسفل

## Error Handling

- معالجة أخطاء الشبكة
- معالجة أخطاء الخادم
- عرض رسائل خطأ واضحة للمستخدم
- fallback للقيم الافتراضية عند فشل جلب البيانات
