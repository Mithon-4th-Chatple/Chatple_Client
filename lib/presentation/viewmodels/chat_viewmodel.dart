import 'package:get/get.dart';
import 'package:mithon_4th_chatple/core/models/chat_message.dart';
import 'package:intl/intl.dart';
import 'package:mithon_4th_chatple/core/models/schedule_item.dart';
import 'package:mithon_4th_chatple/core/models/teacher_info.dart';

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

  // 클래스별 과제 목록
  final Map<String, List<String>> _classAssignments = {
    '가상현실콘텐츠': [
      '2-5. 키오스크 - UX 라이팅',
      '2-4. 키오스크 - 클론 디자인',
      '2-3. 키오스크 - UX/UI 가이드',
      '2-2. 키오스크 - 멘탈모델',
      '2-1. 키오스크 - 휴리스틱 평가',
    ],
    'UI/UX': [
      '2-5. 키오스크 - UX 라이팅',
      '2-4. 키오스크 - 클론 디자인',
      '2-3. 키오스크 - UX/UI 가이드',
      '2-2. 키오스크 - 멘탈모델',
      '2-1. 키오스크 - 휴리스틱 평가',
    ],
    'AR': [
      '2-3. 키오스크 - UX/UI 가이드',
      '2-2. 키오스크 - 멘탈모델',
      '2-1. 키오스크 - 휴리스틱 평가',
    ],
    '시각디자인': [
      '2-4. 키오스크 - 클론 디자인',
      '2-3. 키오스크 - UX/UI 가이드',
    ],
    '과학': [
      '탐구 계획서 작성',
      '그래프 분석 과제',
    ],
    '진로 영어': [
      '자기소개서 영어',
    ],
    '국어': [
      '논술 초안 제출',
    ],
    '수학': [
      '함수 프로젝트',
    ],
  };

  // --- Per-assignment metadata ---
  // 클래스별 담당 선생님
  final Map<String, TeacherInfo> _classTeachers = const {
    '가상현실콘텐츠': TeacherInfo(name: '한가상 선생님', school: '미림마이스터고등학교'),
    'UI/UX': TeacherInfo(name: '조예진 선생님', school: '미림마이스터고등학교'),
    'AR': TeacherInfo(name: '박증강 선생님', school: '미림마이스터고등학교'),
    '시각디자인': TeacherInfo(name: '이시디 선생님', school: '미림마이스터고등학교'),
    '과학': TeacherInfo(name: '김과학 선생님', school: '미림마이스터고등학교'),
    '진로 영어': TeacherInfo(name: '오영어 선생님', school: '미림마이스터고등학교'),
    '국어': TeacherInfo(name: '정국어 선생님', school: '미림마이스터고등학교'),
    '수학': TeacherInfo(name: '최수학 선생님', school: '미림마이스터고등학교'),
  };

  // 클래스별 일정 (과제 선택과 무관, 클래스에 고정)
  final Map<String, List<ScheduleItem>> _classSchedules = {
    '가상현실콘텐츠': [
      ScheduleItem(date: '10/24', title: 'VR 인터랙션 기초', dotColor: 0xFF55DD97),
      ScheduleItem(date: '10/27', title: 'Unity 입력 시스템', dotColor: 0xFFFF7878),
      ScheduleItem(date: '10/30', title: '프로토타입 점검', dotColor: 0xFF55DD97),
    ],
    'UI/UX': [
      ScheduleItem(date: '10/24', title: '4-1. 주제선정 및 리서치...', dotColor: 0xFFFF7878),
      ScheduleItem(date: '10/24', title: '4-1. 주제선정 및 리서치...', dotColor: 0xFF55DD97),
      ScheduleItem(date: '10/24', title: '4-1. 주제선정 및 리서치...', dotColor: 0xFF55DD97),
    ],
    'AR': [
      ScheduleItem(date: '10/25', title: 'ARKit 기초', dotColor: 0xFF55DD97),
      ScheduleItem(date: '10/27', title: '이미지 트래킹', dotColor: 0xFFFF7878),
      ScheduleItem(date: '10/29', title: 'AR UX 가이드', dotColor: 0xFF55DD97),
    ],
    '시각디자인': [
      ScheduleItem(date: '10/24', title: '타이포그래피 스터디', dotColor: 0xFF55DD97),
      ScheduleItem(date: '10/26', title: '그리드 시스템', dotColor: 0xFFFF7878),
      ScheduleItem(date: '10/28', title: '포트폴리오 리뷰', dotColor: 0xFF55DD97),
    ],
    '과학': [
      ScheduleItem(date: '10/24', title: '탐구 계획서 작성', dotColor: 0xFF55DD97),
      ScheduleItem(date: '10/26', title: '그래프 분석', dotColor: 0xFFFF7878),
    ],
    '진로 영어': [
      ScheduleItem(date: '10/25', title: '자기소개서 초안', dotColor: 0xFF55DD97),
    ],
    '국어': [
      ScheduleItem(date: '10/24', title: '논술 주제 연구', dotColor: 0xFF55DD97),
    ],
    '수학': [
      ScheduleItem(date: '10/27', title: '함수 프로젝트', dotColor: 0xFFFF7878),
    ],
  };

  final Map<String, String> _assignmentDueText = {
    '2-5. 키오스크 - UX 라이팅': '10월 28일 23:59',
    '2-4. 키오스크 - 클론 디자인': '10월 29일 23:59',
    '2-3. 키오스크 - UX/UI 가이드': '10월 30일 23:59',
    '2-2. 키오스크 - 멘탈모델': '10월 28일 18:00',
    '2-1. 키오스크 - 휴리스틱 평가': '10월 27일 12:00',
  };

  // 과제 상세 설명 (Figma 참고 텍스트)
  final Map<String, String> _assignmentDetails = {
    '2-4. 키오스크 - 클론 디자인':
        '1. 수행방법\n\n- 샘플 이미지를 참고하여 클론 디자인 완성(트레이싱 절대 금지)\n- 이미지 소스는 첨부한 파일 사용\n\n2. 제출방법★\n파일형식 : JPG\n파일명 : 학번_이름_UIUX_키오스크_#4_클론디자인\n분량 : 1p.\n기한 : 10월 13일 (월) 24:00 (마감 10분 전 제출)\n\n※ 수행평가 안내\n위 과제는 수행평가의 세부 평가 항목으로 활용됩니다.\n작업과정 및 결과물은 과목별 세부능력 및 \n특기사항의 참고자료로 활용됩니다.',
  };

  // 상세 패널 토글 상태
  final isAssignmentDetailExpanded = true.obs;

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

  /// 현재 활성화된 채팅방 표시명 (e.g., "UI/UX 공지방" or 과제 제목)
  String get currentChatRoomName {
    if (selectedSubChatType.value == 'assignment' && selectedAssignment.isNotEmpty) {
      return selectedAssignment.value;
    }
    return '$currentClassName 공지방';
  }

  /// 내부 메시지 저장용 키 (클래스 구분 포함)
  String get _currentRoomKey {
    if (selectedSubChatType.value == 'assignment' && selectedAssignment.isNotEmpty) {
      return '$currentClassName::${selectedAssignment.value}';
    }
    return '$currentClassName 공지방';
  }

  /// 현재 채팅방의 메시지 목록
  RxList<ChatMessage> get currentMessages {
    return _chatMessages[_currentRoomKey] ?? <ChatMessage>[].obs;
  }

  /// 현재 화면(공지/과제)에 따라 표시할 선생님 이름
  String get currentTeacherName {
    final teacher = _classTeachers[currentClassName];
    return teacher?.name ?? '담당 선생님';
  }

  /// 현재 화면(공지/과제)에 따라 표시할 학교명
  String get currentTeacherSchool {
    final teacher = _classTeachers[currentClassName];
    return teacher?.school ?? '미림마이스터고등학교';
  }

  /// 현재 클래스의 과제 목록 (공지/과제 전환과 무관하게 고정)
  List<String> get currentAssignments => _classAssignments[currentClassName] ?? const [];

  /// 현재 클래스에 고정된 일정 목록 (과제 선택과 무관)
  List<ScheduleItem> get currentScheduleItems {
    final classItems = _classSchedules[currentClassName];
    if (classItems != null && classItems.isNotEmpty) return classItems;
    return _defaultScheduleItems;
  }

  /// 선택된 과제의 마감 텍스트
  String get currentAssignmentDueText {
    if (selectedSubChatType.value == 'assignment' && selectedAssignment.isNotEmpty) {
      return _assignmentDueText[selectedAssignment.value] ?? '마감일 없음';
    }
    return '마감일 없음';
  }

  String get currentAssignmentDetail {
    if (selectedSubChatType.value == 'assignment' && selectedAssignment.isNotEmpty) {
      return _assignmentDetails[selectedAssignment.value] ?? '';
    }
    return '';
  }

  // 기본(공지방)에서 사용할 일정 아이템들
  List<ScheduleItem> get _defaultScheduleItems => const [
        ScheduleItem(date: '10/24', title: '4-1. 주제선정 및 리서치...', dotColor: 0xFFFF7878),
        ScheduleItem(date: '10/24', title: '4-1. 주제선정 및 리서치...', dotColor: 0xFF55DD97),
        ScheduleItem(date: '10/24', title: '4-1. 주제선정 및 리서치...', dotColor: 0xFF55DD97),
      ];

  @override
  void onInit() {
    super.onInit();
    _initializeChatRooms();
  }

  void _initializeChatRooms() {
    // Initialize notice rooms for all classes
    for (var className in [...majorClasses, ...generalClasses]) {
      final noticeKey = '$className 공지방';
      _chatMessages[noticeKey] = <ChatMessage>[].obs;
    }

    // Initialize assignment rooms per class
    for (var className in [...majorClasses, ...generalClasses]) {
      final assignments = _classAssignments[className] ?? const [];
      for (var assignmentName in assignments) {
        final key = '$className::$assignmentName';
        _chatMessages[key] = <ChatMessage>[].obs;
        _chatMessages[key]!.add(ChatMessage(
          id: 'welcome_${className}_$assignmentName',
          userId: 'system',
          userName: 'System',
          message: '$assignmentName 과제방에 오신걸 환영합니다!',
          timestamp: DateTime.now(),
        ));
      }
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
      // 과제 선택 초기화 (클래스가 바뀌면 기존 선택을 비움)
      selectedAssignment.value = '';
    }
  }

  /// 왼쪽 사이드바에서 '일반교과' 클래스를 선택했을 때
  void selectGeneralClass(int index) {
    if (selectedGeneralClass.value != index) {
      selectedGeneralClass.value = index;
      selectedMajorClass.value = -1;
      // Reset to notice room when class changes
      selectNoticeRoom();
      // 과제 선택 초기화 (클래스가 바뀌면 기존 선택을 비움)
      selectedAssignment.value = '';
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

    final roomMessages = _chatMessages[_currentRoomKey];
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
