import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mithon_4th_chatple/core/routes/app_routes.dart';
import 'package:mithon_4th_chatple/shared/styles/colors.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs;
    
    final List<Widget> pages = [
      // TODO: Add more pages as needed
      Center(
        child: ElevatedButton(
          onPressed: () => Get.toNamed(AppRoutes.chat),
          child: const Text('채팅 목록 보기'),
        ),
      ),
    ];

    ThemeColors colors = ThemeColors.of(context); 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.gray50,
        toolbarHeight: 18,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: colors.gray50,
      extendBody: true,
      body: Obx(() => pages[currentIndex.value]),
    );
  }
}
