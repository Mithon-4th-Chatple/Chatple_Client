# 채팅 기능 MVP

## 📁 구조

```
lib/
├── core/
│   ├── models/
│   │   ├── chat_message.dart        # 채팅 메시지 모델
│   │   └── chat_room.dart           # 채팅방 모델
│   ├── services/
│   │   └── chat_service.dart        # 채팅 API 서비스
│   └── routes/
│       └── app_routes.dart          # 라우팅 설정
├── presentation/
│   ├── viewmodels/
│   │   ├── chat_list_viewmodel.dart # 채팅방 목록 뷰모델
│   │   └── chat_room_viewmodel.dart # 채팅방 뷰모델
│   └── views/
│       └── chat/
│           ├── chat_list_page.dart  # 채팅방 목록 화면
│           └── chat_room_page.dart  # 채팅방 화면
```

## 🚀 기능

### 1. 채팅방 목록 (ChatListPage)
- 채팅방 목록 표시
- 마지막 메시지 및 시간 표시
- 읽지 않은 메시지 개수 배지
- Pull to Refresh
- 채팅방 클릭 시 채팅방 화면으로 이동

### 2. 채팅방 (ChatRoomPage)
- 메시지 목록 표시
- 실시간 메시지 전송
- 자동 스크롤 (메시지 전송 시 하단으로)
- 메시지 입력창
- 시간 표시 (HH:mm 형식)

## 🔧 백엔드 연동 가이드

### 1. 환경 설정

`assets/config/.env` 파일에 API URL 추가:
```env
API_BASE_URL=https://your-api-url.com
WS_BASE_URL=wss://your-websocket-url.com
```

### 2. API 연동

`lib/core/services/chat_service.dart` 파일에서 TODO 부분을 실제 API 호출로 교체:

#### 채팅방 목록 조회
```dart
Future<List<ChatRoom>> getChatRooms() async {
  final response = await http.get(
    Uri.parse('$baseUrl/chat/rooms'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((json) => ChatRoom.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load chat rooms');
  }
}
```

#### 메시지 목록 조회
```dart
Future<List<ChatMessage>> getMessages(String roomId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/chat/rooms/$roomId/messages'),
    headers: {'Authorization': 'Bearer $token'},
  );
  
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((json) => ChatMessage.fromJson(json))
        .toList();
  } else {
    throw Exception('Failed to load messages');
  }
}
```

#### 메시지 전송
```dart
Future<ChatMessage> sendMessage({
  required String roomId,
  required String content,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/chat/rooms/$roomId/messages'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'content': content}),
  );
  
  if (response.statusCode == 201) {
    return ChatMessage.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to send message');
  }
}
```

### 3. WebSocket 연동 (실시간 메시지)

필요한 패키지 추가:
```yaml
dependencies:
  web_socket_channel: ^2.4.0
```

WebSocket 연결 구현:
```dart
import 'package:web_socket_channel/web_socket_channel.dart';

Stream<ChatMessage> connectToRoom(String roomId) {
  final channel = WebSocketChannel.connect(
    Uri.parse('$wsUrl/chat/rooms/$roomId'),
  );
  
  return channel.stream.map((data) {
    return ChatMessage.fromJson(jsonDecode(data));
  });
}
```

뷰모델에서 WebSocket 구독:
```dart
StreamSubscription? _messageSubscription;

@override
void onInit() {
  super.onInit();
  loadMessages();
  _subscribeToMessages();
}

void _subscribeToMessages() {
  _messageSubscription = _chatService.connectToRoom(roomId).listen(
    (message) {
      messages.add(message);
      _scrollToBottom();
    },
    onError: (error) {
      print('WebSocket error: $error');
    },
  );
}

@override
void onClose() {
  _messageSubscription?.cancel();
  messageController.dispose();
  scrollController.dispose();
  super.onClose();
}
```

## 📝 모델 구조

### ChatRoom
```json
{
  "id": "string",
  "name": "string",
  "lastMessage": "string?",
  "lastMessageTime": "DateTime?",
  "unreadCount": "int",
  "thumbnailUrl": "string?"
}
```

### ChatMessage
```json
{
  "id": "string",
  "content": "string",
  "senderId": "string",
  "senderName": "string",
  "timestamp": "DateTime",
  "isMe": "bool",
  "imageUrl": "string?"
}
```

## 🎨 추후 추가 기능

- [ ] 이미지/파일 전송
- [ ] 메시지 읽음 표시
- [ ] 타이핑 표시
- [ ] 메시지 검색
- [ ] 채팅방 나가기/삭제
- [ ] 푸시 알림
- [ ] 메시지 답장
- [ ] 이모지 반응

## 🧪 테스트

현재는 Mock 데이터로 동작합니다. 앱을 실행하면:
1. 메인 페이지에서 "채팅 목록 보기" 버튼 클릭
2. 2개의 샘플 채팅방 표시
3. 채팅방 클릭 시 샘플 메시지 표시
4. 메시지 전송 가능 (Mock)

백엔드 API가 준비되면 `chat_service.dart`의 TODO 부분을 실제 API 호출로 교체하세요.
