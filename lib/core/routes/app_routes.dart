import 'package:get/get.dart';
import 'package:mithon_4th_chatple/presentation/views/main_page.dart';
import 'package:mithon_4th_chatple/presentation/views/chat/chat_page.dart';

class AppRoutes {
  static const String main = '/';
  static const String login = '/login';
  static const String chat = '/chat';

  static List<GetPage> routes = [
    GetPage(
      name: main,
      page: () => const MainPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: chat,
      page: () => const ChatPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
