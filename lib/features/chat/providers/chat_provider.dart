import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../core/services/api_service.dart';
import '../../../core/services/local_storage_service.dart';

final chatMessagesProvider = StateNotifierProvider.family<ChatNotifier, List<dynamic>, String>((ref, recipientId) {
  final api = ref.watch(apiServiceProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return ChatNotifier(api, storage, recipientId);
});

class ChatNotifier extends StateNotifier<List<dynamic>> {
  final ApiService _api;
  final LocalStorageService _storage;
  final String _recipientId;
  late IO.Socket _socket;
  late String _chatId;

  ChatNotifier(this._api, this._storage, this._recipientId) : super([]) {
    _init();
  }

  Future<void> _init() async {
    // 1. Load History
    try {
      final response = await _api.get('/chats/$_recipientId');
      state = response['data'] ?? [];
    } catch (e) {
      print('Error loading chat history: $e');
    }

    // 2. Setup WebSocket
    final token = await _storage.getToken();
    _socket = IO.io('http://10.0.2.2:5000', IO.OptionBuilder()
      .setTransports(['websocket'])
      .setAuth({'token': token})
      .build());

    // Create consistent chatId
    final myId = "CURRENT_USER_ID"; // In real app, get from authProvider
    final ids = [myId, _recipientId]..sort();
    _chatId = ids.join('_');

    _socket.onConnect((_) {
      _socket.emit('join_chat', _chatId);
    });

    _socket.on('receive_message', (data) {
      if (data['chatId'] == _chatId) {
        state = [...state, data];
      }
    });

    _socket.connect();
  }

  Future<void> sendMessage(String content) async {
    try {
      // 1. Persist to DB
      final response = await _api.post('/chats', {
        'recipientId': _recipientId,
        'content': content,
      });

      // 2. Broadcast via Socket
      final messageData = response['data'];
      _socket.emit('send_message', messageData);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    _socket.disconnect();
    super.dispose();
  }
}
