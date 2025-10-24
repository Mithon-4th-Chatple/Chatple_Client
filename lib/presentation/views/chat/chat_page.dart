import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mithon_4th_chatple/presentation/viewmodels/chat_viewmodel.dart';
import 'package:mithon_4th_chatple/core/models/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final ChatViewModel viewModel;
  late final TextEditingController _textController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _leftSidebarScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    viewModel = Get.put(ChatViewModel());
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _leftSidebarScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showLeftSidebar = screenWidth > 1200;
    final showRightSidebar = screenWidth > 900;
    final showAssignmentPanel = screenWidth > 1600;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Row(
            children: [
              if (showLeftSidebar) 
                const SizedBox(width: 310),
              Expanded(
                child: Row(
                  children: [
                    if (showRightSidebar)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(21),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            border: Border.all(color: const Color(0xFFBFBFBF), width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              _buildRightSidebar(),
                              Expanded(child: _buildChatContent()),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(child: _buildMainContent()),
                    if (showAssignmentPanel) _buildFixedAssignmentPanel(),
                  ],
                ),
              ),
            ],
          ),
          if (showLeftSidebar)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: _buildLeftSidebar(),
            ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 310,
      color: const Color(0xFFE1F4EE),
      child: Column(
        children: [
          const SizedBox(height: 61),
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFB0B0B0),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '유성윤 학생',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Color(0xFF575757),
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            '미림마이스터고등학교',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFF575757),
            ),
          ),
          const SizedBox(height: 38),
          Container(
            width: 227,
            height: 2,
            color: const Color(0xFFBFBFBF),
          ),
          const SizedBox(height: 37),
          Expanded(
            child: Scrollbar(
              controller: _leftSidebarScrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _leftSidebarScrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      Obx(() => _buildCategorySection(
                            '전공',
                            [
                              '가상현실콘텐츠',
                              'UI/UX',
                              'AR',
                              '시각디자인',
                            ],
                            isExpanded: viewModel.isMajorExpanded.value,
                            onToggle: viewModel.toggleMajorSection,
                          )),
                      const SizedBox(height: 37),
                      Obx(() => _buildCategorySection(
                            '일반교과',
                            [
                              '과학',
                              '진로 영어',
                              '국어',
                              '수학',
                            ],
                            isExpanded: viewModel.isGeneralExpanded.value,
                            onToggle: viewModel.toggleGeneralSection,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    String title,
    List<String> items, {
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    final isMajor = title == '전공';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF31A37F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                  color: const Color(0xFFFFFFFF),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        if (isExpanded)
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            
            return Obx(() {
              final isSelected = isMajor 
                  ? viewModel.selectedMajorClass.value == index
                  : viewModel.selectedGeneralClass.value == index;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    if (isMajor) {
                      viewModel.selectMajorClass(index);
                    } else {
                      viewModel.selectGeneralClass(index);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFC1E8DC) : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF575757),
                      ),
                    ),
                  ),
                ),
              );
            });
          }),
      ],
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 325,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 29),
            child: Obx(() => Row(
              children: [
                Text(
                  viewModel.currentClassName,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Color(0xFF1C1C1C),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: 22,
                  color: Color(0xFF1C1C1C),
                ),
              ],
            )),
          ),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Obx(() => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewModel.currentTeacherName,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Color(0xFF575757),
                    ),
                  ),
                  const SizedBox(height: 11),
                  Text(
                    viewModel.currentTeacherSchool,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFF575757),
                    ),
                  ),
                ],
              ),
            )),
          ),
          const SizedBox(height: 34),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 27),
            child: Text(
              '일정',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF575757),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Obx(() {
              final items = viewModel.currentScheduleItems;
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < items.length; i++)
                      _buildScheduleItem(
                        items[i].date,
                        items[i].title,
                        Color(items[i].dotColor),
                        i < items.length - 1,
                      ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: 34),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 27),
            child: Text(
              '채팅',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF575757),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() {
                      final isNoticeSelected = viewModel.selectedSubChatType.value == 'notice';
                      return GestureDetector(
                        onTap: viewModel.selectNoticeRoom,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isNoticeSelected ? const Color(0xFFE1F4EE) : const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '공지방',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF575757),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    _buildAssignmentSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String date, String title, Color dotColor, bool hasBorder) {
    return Container(
      height: 39,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        border: hasBorder
            ? const Border(bottom: BorderSide(color: Color(0xFFDEDEDE), width: 1))
            : null,
      ),
      child: Row(
        children: [
          Text(
            date,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Color(0xFF31A37F),
            ),
          ),
          const SizedBox(width: 27),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentSection() {
    // Always-expanded assignment list (no toggle)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '과제',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF575757),
            ),
          ),
        ),
        const SizedBox(height: 11),
        ...viewModel.currentAssignments.map((title) {
          return Obx(() {
            final isSelected = viewModel.selectedAssignment.value == title;
            return Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: GestureDetector(
                onTap: () => viewModel.selectAssignment(title),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFE1F4EE) : const Color(0xFFFAFFFD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xFF575757),
                    ),
                  ),
                ),
              ),
            );
          });
        }),
      ],
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFBFBFBF), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: _buildChatContent(),
    );
  }

  Widget _buildChatContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth > 1200 
            ? (constraints.maxWidth * 0.15).clamp(40.0, 365.0)
            : 40.0;
        
        return Column(
          children: [
            Expanded(
              child: Obx(() {
                final messages = viewModel.currentMessages;
                
                if (messages.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 3,
                            constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.8,
                            ),
                            color: const Color(0xFFD9D9D9),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            '${viewModel.currentChatRoomName} 방에 오신 걸 환영합니다!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              fontSize: constraints.maxWidth > 800 ? 36 : 24,
                              color: const Color(0xFF3B3B3B),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '2513정지영 / 2614 조세연 / 2610 유성윤 님께서 계신 방이에요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: constraints.maxWidth > 800 ? 20 : 16,
                              color: const Color(0xFF575757),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 36,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final reversedIndex = messages.length - 1 - index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: _buildChatMessage(messages[reversedIndex]),
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 30),
              child: _buildMessageInput(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChatMessage(ChatMessage message) {
    final bool isSystemMessage = message.userId == 'system';

    if (isSystemMessage) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            message.message,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF666666),
            ),
          ),
        ),
      );
    }
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFFB0B0B0),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    message.userName,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      height: 1.6,
                      letterSpacing: -0.4,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    viewModel.formatMessageTime(message.timestamp),
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.57,
                      letterSpacing: -0.28,
                      color: Color(0xFF575757),
                    ),
                  ),
                ],
              ),
              Text(
                message.message,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  height: 1.33,
                  letterSpacing: -0.48,
                  color: Color(0xFF2E2E2E),
                ),
              ),
            ],
          ),
        ),
        if (message.readBy != null && message.readBy! > 0)
          _buildReadReceipts(message.readBy!),
      ],
    );
  }

  Widget _buildReadReceipts(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          count.clamp(0, 3),
          (index) => Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
        ),
        if (count > 3)
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              '+${count - 3}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            child: const Icon(
              Icons.add,
              color: Color(0xFF666666),
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: '메시지 입력',
                hintStyle: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Color(0xFFB0B0B0),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: Color(0xFF0D0D0D),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  viewModel.sendMessage(value);
                  _textController.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedAssignmentPanel() {
    return Container(
      width: 466,
      margin: const EdgeInsets.only(right: 36, top: 36, bottom: 36),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF757575), width: 1),
      ),
      child: Obx(() {
        final selectedAssignment = viewModel.selectedAssignment.value;
        
        if (selectedAssignment.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text(
                '과제를 선택해주세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(37),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedAssignment,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFF0D0D0D),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => viewModel.isAssignmentDetailExpanded.value = !viewModel.isAssignmentDetailExpanded.value,
                      child: Icon(
                        viewModel.isAssignmentDetailExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: const Color(0xFF4A4A4A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => viewModel.selectedAssignment.value = '',
                      child: const Icon(
                        Icons.close,
                        color: Color(0xFF4A4A4A),
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Obx(() => Text(
                  viewModel.currentAssignmentDueText,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF36B58D),
                  ),
                )),
                const SizedBox(height: 27),
                Row(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 43,
                      height: 43,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 43,
                      height: 43,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.star,
                          color: Color(0xFFFFC300),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                // 상세 내용 divider
                const SizedBox(height: 20),
                Container(height: 1, color: const Color(0xFFDEDEDE)),
                const SizedBox(height: 12),
                // 상세 내용 (토글)
                Obx(() {
                  if (!viewModel.isAssignmentDetailExpanded.value) return const SizedBox.shrink();
                  final detail = viewModel.currentAssignmentDetail;
                  if (detail.isEmpty) return const SizedBox.shrink();
                  return Text(
                    detail,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF4A4A4A),
                      height: 1.6,
                    ),
                  );
                }),
                const SizedBox(height: 20),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF36B58D), width: 1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Color(0xFF36B58D),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '추가 또는 만들기',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0xFF36B58D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                GestureDetector(
                  onTap: viewModel.markAsComplete,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF36B58D),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      '완료로 표시',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}