import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wafy/core/utils/font_constants.dart';

/// أمثلة على استخدام ثوابت الخطوط
class FontUsageExamples {
  /// مثال على استخدام Poppins للنصوص الإنجليزية
  static Widget englishTextExample() {
    return Column(
      children: [
        // استخدام الثوابت المحددة مسبقاً
        Text(
          'English Text with Poppins Regular',
          style: FontConstants.poppinsRegularStyle.copyWith(fontSize: 16.sp),
        ),

        Text(
          'English Text with Poppins Bold',
          style: FontConstants.poppinsBoldStyle.copyWith(fontSize: 18.sp),
        ),

        // استخدام الدوال المساعدة
        Text(
          'Custom Poppins Style',
          style: FontConstants.poppinsStyle(
            weight: FontConstants.poppinsMedium,
            fontSize: 20.sp,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  /// مثال على استخدام Cairo للنصوص العربية
  static Widget arabicTextExample() {
    return Column(
      children: [
        // استخدام الثوابت المحددة مسبقاً
        Text(
          'نص عربي بخط Cairo العادي',
          style: FontConstants.cairoRegularStyle.copyWith(fontSize: 16.sp),
        ),

        Text(
          'نص عربي بخط Cairo العريض',
          style: FontConstants.cairoBoldStyle.copyWith(fontSize: 18.sp),
        ),

        // استخدام الدوال المساعدة
        Text(
          'نص عربي مخصص',
          style: FontConstants.cairoStyle(
            weight: FontConstants.cairoMedium,
            fontSize: 20.sp,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  /// مثال على استخدام مختلط
  static Widget mixedTextExample() {
    return Column(
      children: [
        // نص عربي
        Text(
          'السعر:',
          style: FontConstants.cairoStyle(
            fontSize: 16.sp,
            weight: FontConstants.cairoMedium,
          ),
        ),

        // سعر بالإنجليزية
        Text(
          '25.50 USD',
          style: FontConstants.poppinsStyle(
            fontSize: 18.sp,
            weight: FontConstants.poppinsBold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
