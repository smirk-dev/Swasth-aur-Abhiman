import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_models.dart';
import '../../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final ChatRoom room;

  const ChatRoomScreen({
    super.key,
    required this.room,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).loadMessages(widget.room.id);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final messages = chatState.getMessagesForRoom(widget.room.id);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (_getParticipantRole() != null)
                    Text(
                      _getParticipantRole()!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[300],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showRoomInfo(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: chatState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? _buildEmptyMessages()
                    : _buildMessagesList(messages),
          ),

          // Message Input
          MessageInput(
            isSending: chatState.isSending,
            onSend: (message) => _sendMessage(message),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final participant = widget.room.participants.isNotEmpty
        ? widget.room.participants.first
        : null;

    return CircleAvatar(
      radius: 18,
      backgroundColor: _getRoleColor(participant?.role),
      child: Text(
        widget.room.name.isNotEmpty
            ? widget.room.name[0].toUpperCase()
            : '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No messages yet',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Start the conversation!',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<Message> messages) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true, // Latest messages at bottom
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = _isMyMessage(message);
        final showAvatar = index == messages.length - 1 ||
            messages[index + 1].senderId != message.senderId;

        return MessageBubble(
          message: message,
          isMe: isMe,
          showAvatar: showAvatar && !isMe,
        );
      },
    );
  }

  String? _getParticipantRole() {
    if (widget.room.participants.isNotEmpty) {
      return widget.room.participants.first.roleDisplay;
    }
    return null;
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'DOCTOR':
        return Colors.green;
      case 'TEACHER':
        return Colors.blue;
      case 'TRAINER':
        return Colors.orange;
      case 'ADMIN':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  bool _isMyMessage(Message message) {
    // In production, compare with current user ID
    // For now, assume odd indices are from current user
    return false; // Placeholder
  }

  Future<void> _sendMessage(String content) async {
    await ref.read(chatProvider.notifier).sendMessage(widget.room.id, content);
    
    // Scroll to bottom after sending
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showRoomInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chat Info',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Participants
            const Text(
              'Participants',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.room.participants.map((p) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getRoleColor(p.role),
                    child: Text(
                      p.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(p.name),
                  subtitle: Text(p.roleDisplay),
                  trailing: p.isOnline
                      ? Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
