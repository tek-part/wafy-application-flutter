import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wafy/app/routes/app_pages.dart';
import 'package:wafy/app/routes/app_routes.dart';
import 'package:wafy/app/bindings/initial_binding.dart';
import 'package:wafy/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  await Hive.initFlutter();

  // فتح صناديق Hive
  await Hive.openBox('auth');
  await Hive.openBox('menu');


  // تهيئة SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Wafy',
          theme: AppTheme.light,
          locale: const Locale('ar'),
          textDirection: TextDirection.rtl,
          debugShowCheckedModeBanner: false,
          getPages: AppPages.pages,
          initialBinding: InitialBinding(),
          initialRoute: Routes.splash,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
