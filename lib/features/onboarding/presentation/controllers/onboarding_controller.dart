import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/core/utils/app_images.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, dynamic>> pages = [
    {
      'title':
          'تصفّح خريطة الطاولات بوضوح وتعرف على حالتها في لحظة – مشغولة، متاحة، أو بانتظار الخدمة.',
      'description': 'ابدأ الطلب بضغطة واحدة على الطاولة المناسبة.',
      'image': AppImages.onboarding1,
    },
    {
      'title':
          'استعرض قائمة الطعام المصنفة بطريقة ذكية، أضف الطلبات بسرعة، وعدّل الكميات أو الملاحظات حسب رغبة الزبون.',
      'description': 'سهولة وسرعة في كل خطوة.',
      'image': AppImages.onboarding2,
    },
    {
      'title': 'بعد مراجعة الطلب، يتم إرساله فورًا إلى المطبخ بدون تأخير.',
      'description': 'وداعًا للأخطاء الورقية – كل شيء إلكتروني وآمن.',
      'image': AppImages.onboarding3,
    },
  ];

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(Routes.login);
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
