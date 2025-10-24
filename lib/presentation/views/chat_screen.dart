import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mithon_4th_chatple/core/models/chat_message.dart';
import 'package:mithon_4th_chatple/presentation/viewmodels/chat_viewmodel.dart';
import 'package:mithon_4th_chatple/shared/styles/colors.dart';

class ChatScreen extends StatefulWidget {
	const ChatScreen({super.key});

	@override
	State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
	late final ChatViewModel viewModel;
	late final TextEditingController _textController;
	final ScrollController _scrollController = ScrollController();

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
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final colors = ThemeColors.of(context);
		return Scaffold(
			backgroundColor: colors.lightHover,
			body: SafeArea(
				child: Row(
					children: [
						_buildLeftSidebar(colors),
						Expanded(
							child: Container(
								margin: const EdgeInsets.fromLTRB(24, 24, 24, 24),
								decoration: BoxDecoration(
									color: colors.gray0,
									borderRadius: BorderRadius.circular(20),
									border: Border.all(color: colors.gray50, width: 1),
								),
								child: Row(
									children: [
										Obx(() {
											if (!viewModel.isSecondarySidebarVisible.value) {
												return const SizedBox.shrink();
											}
											return _buildSecondarySidebar(colors);
										}),
										Expanded(child: _buildChatArea(colors)),
										Obx(() {
											final isAssignment = viewModel.selectedSubChatType.value == 'assignment' && 
																				viewModel.selectedAssignment.value.isNotEmpty;
											if (isAssignment) {
												return _buildFixedAssignmentPanel(colors);
											}
											return const SizedBox.shrink();
										}),
									],
								),
							),
						),
					],
				),
			),
		);
	}

	Widget _buildLeftSidebar(ThemeColors colors) {
		return Container(
			width: 310,
			color: colors.lightHover,
			child: Column(
				children: [
					const SizedBox(height: 61),
					Container(
						width: 140,
						height: 140,
						decoration: BoxDecoration(
							color: colors.gray60,
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
						color: colors.gray50,
					),
					const SizedBox(height: 37),
					Expanded(
						child: SingleChildScrollView(
							padding: const EdgeInsets.symmetric(horizontal: 40),
							child: Column(
								children: [
									_buildCategorySection('전공', viewModel.majorClasses, true),
									const SizedBox(height: 37),
									_buildCategorySection('일반교과', viewModel.generalClasses, false),
								],
							),
						),
					),
				],
			),
		);
	}

	Widget _buildCategorySection(String title, List<String> items, bool isMajor) {
		return Obx(() {
			final isExpanded = isMajor ? viewModel.isMajorExpanded.value : viewModel.isGeneralExpanded.value;
			
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					GestureDetector(
						onTap: isMajor ? viewModel.toggleMajorSection : viewModel.toggleGeneralSection,
						child: Container(
							padding: const EdgeInsets.all(10),
							decoration: BoxDecoration(
								color: const Color(0xFF31A37F),
								borderRadius: BorderRadius.circular(12),
							),
							child: Row(
								children: [
									Text(
										title,
										style: const TextStyle(
											fontFamily: 'Pretendard',
											fontWeight: FontWeight.w500,
											fontSize: 16,
											color: Colors.white,
										),
									),
									const Spacer(),
									Icon(
										isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
										size: 12,
										color: Colors.white,
									),
								],
							),
						),
					),
					if (isExpanded) ...[
						const SizedBox(height: 15),
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
											padding: const EdgeInsets.symmetric(vertical: 10),
											decoration: BoxDecoration(
												color: isSelected ? const Color(0xFFEBF8F4) : Colors.white,
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
						}).toList(),
					],
				],
			);
		});
	}

	Widget _buildSecondarySidebar(ThemeColors colors) {
		return Container(
			width: 325,
			decoration: BoxDecoration(
				color: colors.gray20,
				borderRadius: const BorderRadius.only(
					topLeft: Radius.circular(20),
					bottomLeft: Radius.circular(20),
				),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Padding(
						padding: const EdgeInsets.fromLTRB(29, 22, 29, 0),
						child: Obx(() {
							return Row(
								children: [
									Expanded(
										child: Text(
											viewModel.currentClassName.isEmpty ? 'UIUX 엔지니어링' : viewModel.currentClassName,
											style: const TextStyle(
												fontFamily: 'Pretendard',
												fontWeight: FontWeight.w500,
												fontSize: 20,
												color: Color(0xFF1C1C1C),
											),
										),
									),
									GestureDetector(
										onTap: viewModel.toggleSecondarySidebar,
										child: const Icon(Icons.keyboard_double_arrow_left, size: 22, color: Color(0xFF1C1C1C)),
									),
								],
							);
						}),
					),
					Padding(
						padding: const EdgeInsets.fromLTRB(27, 26, 27, 0),
						child: Container(
							width: double.infinity,
							padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(12),
							),
							child: const Column(
								mainAxisSize: MainAxisSize.min,
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									Text(
										'조예진 선생님',
										style: TextStyle(
											fontFamily: 'Pretendard',
											fontWeight: FontWeight.w600,
											fontSize: 20,
											color: Color(0xFF575757),
										),
									),
									SizedBox(height: 11),
									Text(
										'미림마이스터고등학교',
										style: TextStyle(
											fontFamily: 'Pretendard',
											fontWeight: FontWeight.w500,
											fontSize: 15,
											color: Color(0xFF575757),
										),
									),
								],
							),
						),
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
						child: Container(
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(12),
							),
							child: Column(
								children: [
									_buildScheduleItem('10/24', '4-1. 주제선정 및 리서치...', const Color(0xFFFF7878), true),
									_buildScheduleItem('10/24', '4-1. 주제선정 및 리서치...', const Color(0xFF55DD97), true),
									_buildScheduleItem('10/24', '4-1. 주제선정 및 리서치...', const Color(0xFF55DD97), false),
								],
							),
						),
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
														color: isNoticeSelected ? const Color(0xFFE1F4EE) : Colors.white,
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
						decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
					),
				],
			),
		);
	}

	Widget _buildAssignmentSection() {
		return Obx(() {
			final isExpanded = viewModel.isAssignmentExpanded.value;
			return Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					GestureDetector(
						onTap: viewModel.toggleAssignments,
						child: Container(
							padding: const EdgeInsets.all(10),
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(12),
							),
							child: Row(
								children: [
									const Text(
										'과제',
										style: TextStyle(
											fontFamily: 'Pretendard',
											fontWeight: FontWeight.w500,
											fontSize: 16,
											color: Color(0xFF575757),
										),
									),
									const Spacer(),
									Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 11, color: const Color(0xFF666666)),
								],
							),
						),
					),
					if (isExpanded) ...[
						const SizedBox(height: 11),
						...viewModel.assignments.map((assignment) {
							return Obx(() {
								final isSelected = viewModel.selectedAssignment.value == assignment;
								return Padding(
									padding: const EdgeInsets.only(bottom: 11),
									child: GestureDetector(
										onTap: () => viewModel.selectAssignment(assignment),
										child: Container(
											padding: const EdgeInsets.all(10),
											decoration: BoxDecoration(
												color: isSelected ? const Color(0xFFE1F4EE) : const Color(0xFFFAFFFD),
												borderRadius: BorderRadius.circular(12),
											),
											child: Text(
												assignment,
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
						}).toList(),
					],
				],
			);
		});
	}

	Widget _buildChatArea(ThemeColors colors) {
		return Column(
			children: [
				_buildAssignmentHeader(colors),
				const SizedBox(height: 24),
				Expanded(
					child: Obx(() {
						final messages = viewModel.currentMessages;
						if (messages.isEmpty) {
							return _buildEmptyState(viewModel.currentChatRoomName);
						}
						return ListView.builder(
							controller: _scrollController,
							reverse: true,
							padding: const EdgeInsets.symmetric(horizontal: 37, vertical: 36),
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
					padding: const EdgeInsets.fromLTRB(37, 0, 37, 36),
					child: _buildMessageInput(),
				),
			],
		);
	}

	Widget _buildAssignmentHeader(ThemeColors colors) {
		return Padding(
			padding: const EdgeInsets.fromLTRB(37, 36, 37, 0),
			child: Obx(() {
				final isAssignment = viewModel.selectedSubChatType.value == 'assignment' && viewModel.selectedAssignment.value.isNotEmpty;
				final title = isAssignment ? viewModel.selectedAssignment.value : viewModel.currentChatRoomName;
				return Container(
					padding: const EdgeInsets.all(36),
					decoration: BoxDecoration(
						borderRadius: BorderRadius.circular(12),
						border: Border.all(color: colors.gray100, width: 1),
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						mainAxisSize: MainAxisSize.min,
						children: [
							Row(
								children: [
									Expanded(
										child: Text(
											title,
											style: const TextStyle(
												fontFamily: 'Pretendard',
												fontWeight: FontWeight.w500,
												fontSize: 20,
												color: Color(0xFF0D0D0D),
											),
										),
									),
									Container(
										width: 32,
										height: 32,
										alignment: Alignment.center,
										decoration: BoxDecoration(
											color: colors.gray0,
											borderRadius: BorderRadius.circular(16),
										),
										child: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF4A4A4A)),
									),
								],
							),
							const SizedBox(height: 8),
							const Text(
								'10월 24일 11:59',
								style: TextStyle(
									fontFamily: 'Pretendard',
									fontWeight: FontWeight.w500,
									fontSize: 16,
									color: Color(0xFF36B58D),
								),
							),
							const SizedBox(height: 24),
							Row(
								children: [
									Container(
										width: 43,
										height: 43,
										decoration: BoxDecoration(color: colors.gray50, shape: BoxShape.circle),
									),
									const SizedBox(width: 12),
									Container(
										width: 43,
										height: 43,
										decoration: BoxDecoration(color: colors.gray50, shape: BoxShape.circle),
									),
									const SizedBox(width: 12),
									Container(
										width: 43,
										height: 43,
										decoration: BoxDecoration(color: colors.gray50, shape: BoxShape.circle),
										child: const Icon(Icons.workspace_premium_outlined, color: Color(0xFFFFC300), size: 24),
									),
								],
							),
							const SizedBox(height: 30),
							Row(
								children: [
									Expanded(
										child: OutlinedButton.icon(
											onPressed: () {},
											icon: const Icon(Icons.add, size: 20, color: Color(0xFF36B58D)),
											label: const Text(
												'추가 또는 만들기',
												style: TextStyle(
													fontFamily: 'Pretendard',
													fontWeight: FontWeight.w400,
													fontSize: 16,
													color: Color(0xFF36B58D),
												),
											),
											style: OutlinedButton.styleFrom(
												side: const BorderSide(color: Color(0xFF36B58D), width: 1),
												padding: const EdgeInsets.symmetric(vertical: 14),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
											),
										),
									),
									const SizedBox(width: 12),
									Expanded(
										child: ElevatedButton(
											onPressed: viewModel.markAsComplete,
											style: ElevatedButton.styleFrom(
												backgroundColor: const Color(0xFF36B58D),
												padding: const EdgeInsets.symmetric(vertical: 14),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
												elevation: 0,
											),
											child: const Text(
												'완료로 표시',
												style: TextStyle(
													fontFamily: 'Pretendard',
													fontWeight: FontWeight.w400,
													fontSize: 16,
													color: Colors.white,
												),
											),
										),
									),
								],
							),
						],
					),
				);
			}),
		);
	}

	Widget _buildEmptyState(String roomName) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 37),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					const SizedBox(height: 3, child: ColoredBox(color: Color(0xFFD9D9D9))),
					const SizedBox(height: 40),
					Text(
						'$roomName\n방에 오신 걸 환영합니다!',
						textAlign: TextAlign.left,
						style: const TextStyle(
							fontFamily: 'Pretendard',
							fontWeight: FontWeight.w600,
							fontSize: 36,
							color: Color(0xFF3B3B3B),
						),
					),
					const SizedBox(height: 16),
					const Text(
						'2513정지영 / 2614 조세연 / 2610 유성윤 님께서 계신 방이에요',
						style: TextStyle(
							fontFamily: 'Pretendard',
							fontWeight: FontWeight.w400,
							fontSize: 16,
							color: Color(0xFF575757),
						),
					),
				],
			),
		);
	}

	Widget _buildChatMessage(ChatMessage message) {
		if (message.userId == 'system') {
			return Center(
				child: Text(
					message.message,
					style: const TextStyle(
						fontFamily: 'Pretendard',
						fontWeight: FontWeight.w500,
						fontSize: 16,
						color: Color(0xFF666666),
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
					decoration: const BoxDecoration(color: Color(0xFFB0B0B0), shape: BoxShape.circle),
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
				if (message.readBy != null && message.readBy! > 0) _buildReadReceipts(message.readBy!),
			],
		);
	}

	Widget _buildReadReceipts(int count) {
		final visibleCount = count > 3 ? 3 : count;
		return Row(
			mainAxisSize: MainAxisSize.min,
			children: [
				...List.generate(
					visibleCount,
					(index) => Padding(
						padding: const EdgeInsets.only(left: 4),
						child: CircleAvatar(radius: 12, backgroundColor: Colors.grey.shade300),
					),
				),
				if (count > 3)
					Padding(
						padding: const EdgeInsets.only(left: 4),
						child: Text(
							'+${count - 3}',
							style: const TextStyle(fontSize: 12, color: Colors.grey),
						),
					),
			],
		);
	}

	Widget _buildMessageInput() {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(12),
				border: Border.all(color: const Color(0xFFB0B0B0), width: 1),
			),
			child: Row(
				children: [
					Container(
						width: 38,
						height: 38,
						alignment: Alignment.center,
						child: const Icon(Icons.add, color: Color(0xFF666666), size: 22),
					),
					const SizedBox(width: 10),
					Expanded(
						child: TextField(
							controller: _textController,
							decoration: const InputDecoration(
								hintText: '공지방에 보낼 메시지를 입력하세요',
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
								if (value.trim().isEmpty) return;
								viewModel.sendMessage(value);
								_textController.clear();
							},
						),
					),
					IconButton(
						onPressed: () {
							final value = _textController.text.trim();
							if (value.isEmpty) return;
							viewModel.sendMessage(value);
							_textController.clear();
						},
						icon: const Icon(Icons.send_rounded, color: Color(0xFF36B58D), size: 24),
					),
				],
			),
		);
	}
}
