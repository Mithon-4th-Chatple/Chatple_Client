import 'package:get/get.dart';
import 'package:mithon_4th_chatple/core/models/chat_message.dart';
import 'package:intl/intl.dart';

class ChatViewModel extends GetxController {
  // --- State ---
  // UI State
  final isAssignmentExpanded = true.obs;
  final isMajorExpanded = true.obs;
  final isGeneralExpanded = true.obs;
  final isSecondarySidebarVisible = true.obs;

  // Selected Class
  final selectedMajorClass = 1.obs; // 'UI/UX' as default
  final selectedGeneralClass = (-1).obs;

  // Selected Chat Room in the right sidebar
  final selectedSubChatType = 'notice'.obs; // 'notice' or 'assignment'
  final selectedAssignment = ''.obs;

  // --- Data ---
  final Map<String, RxList<ChatMessage>> _chatMessages = {};

  final List<String> majorClasses = [
    '가상현실콘텐츠',
    'UI/UX',
    'AR',
    '시각디자인',
  ];

  final List<String> generalClasses = [
    '과학',
    '진로 영어',
    '국어',
    '수학',
  ];

  final List<String> assignments = [
    '2-5. 키오스크 - UX 라이팅',
    '2-4. 키오스크 - 클론 디자인',
    '2-3. 키오스크 - UX/UI 가이드',
    '2-2. 키오스크 - 멘탈모델',
    '2-1. 키오스크 - 휴리스틱 평가',
  ];

  // --- Getters ---

  /// 현재 선택된 클래스의 이름
  String get currentClassName {
    if (selectedMajorClass.value != -1) {
      return majorClasses[selectedMajorClass.value];
    }
    if (selectedGeneralClass.value != -1) {
      return generalClasses[selectedGeneralClass.value];
    }
    return '';
  }

  /// 현재 활성화된 채팅방의 이름 (e.g., "UI/UX 공지방" or "2-5. 키오스크 - UX 라이팅")
  String get currentChatRoomName {
    if (selectedSubChatType.value == 'assignment' && selectedAssignment.isNotEmpty) {
      return selectedAssignment.value;
    }
    // Default to notice room of the current class
    return '$currentClassName 공지방';
  }

  /// 현재 채팅방의 메시지 목록
  RxList<ChatMessage> get currentMessages {
    return _chatMessages[currentChatRoomName] ?? <ChatMessage>[].obs;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeChatRooms();
  }

  void _initializeChatRooms() {
    // Initialize notice rooms for all classes
    for (var className in [...majorClasses, ...generalClasses]) {
      final roomName = '$className 공지방';
      _chatMessages[roomName] = <ChatMessage>[].obs;
    }

    // Initialize assignment rooms
    for (var assignmentName in assignments) {
      _chatMessages[assignmentName] = <ChatMessage>[].obs;
      _chatMessages[assignmentName]!.add(ChatMessage(
        id: 'welcome_$assignmentName',
        userId: 'system',
        userName: 'System',
        message: '$assignmentName 과제방에 오신걸 환영합니다!',
        timestamp: DateTime.now(),
      ));
    }

    // Add a sample message to the UI/UX notice room
    _chatMessages['UI/UX 공지방']!.add(ChatMessage(
      id: '1',
      userId: 'user1',
      userName: '유성윤',
      message: '예진쌤 안녕하세요',
      timestamp: DateTime(2025, 10, 25, 0, 41),
      readBy: 3,
    ));
  }

  // --- Actions ---

  void toggleAssignments() {
    isAssignmentExpanded.value = !isAssignmentExpanded.value;
  }

  void toggleMajorSection() {
    isMajorExpanded.value = !isMajorExpanded.value;
  }

  void toggleGeneralSection() {
    isGeneralExpanded.value = !isGeneralExpanded.value;
  }

  void toggleSecondarySidebar() {
    isSecondarySidebarVisible.value = !isSecondarySidebarVisible.value;
  }

  /// 오른쪽 사이드바에서 '공지방'을 선택했을 때
  void selectNoticeRoom() {
    selectedSubChatType.value = 'notice';
    selectedAssignment.value = '';
  }

  /// 오른쪽 사이드바에서 특정 '과제'를 선택했을 때
  void selectAssignment(String assignment) {
    if (selectedAssignment.value == assignment) {
      // Toggle off if the same assignment is clicked
      selectNoticeRoom();
    } else {
      selectedAssignment.value = assignment;
      selectedSubChatType.value = 'assignment';
    }
  }

  /// 왼쪽 사이드바에서 '전공' 클래스를 선택했을 때
  void selectMajorClass(int index) {
    if (selectedMajorClass.value != index) {
      selectedMajorClass.value = index;
      selectedGeneralClass.value = -1;
      // Reset to notice room when class changes
      selectNoticeRoom();
    }
  }

  /// 왼쪽 사이드바에서 '일반교과' 클래스를 선택했을 때
  void selectGeneralClass(int index) {
    if (selectedGeneralClass.value != index) {
      selectedGeneralClass.value = index;
      selectedMajorClass.value = -1;
      // Reset to notice room when class changes
      selectNoticeRoom();
    }
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'currentUser',
      userName: '유성윤',
      message: message,
      timestamp: DateTime.now(),
    );

    final roomMessages = _chatMessages[currentChatRoomName];
    if (roomMessages != null) {
      roomMessages.add(newMessage);
    }
  }

  void markAsComplete() {
    Get.snackbar(
      '완료',
      '과제가 완료로 표시되었습니다.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  String formatMessageTime(DateTime time) {
    return DateFormat('yyyy. MM. dd. a hh:mm', 'ko_KR').format(time);
  }
}
