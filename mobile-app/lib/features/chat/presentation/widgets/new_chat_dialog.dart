import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/chat_models.dart';
import '../../providers/chat_provider.dart';

class NewChatDialog extends ConsumerStatefulWidget {
  final Function(AvailableContact) onContactSelected;

  const NewChatDialog({
    super.key,
    required this.onContactSelected,
  });

  @override
  ConsumerState<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends ConsumerState<NewChatDialog> {
  String? _selectedRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final contacts = _selectedRole != null
        ? chatState.contacts.where((c) => c.role == _selectedRole).toList()
        : chatState.contacts;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Text(
                      'New Conversation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Role Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildRoleChip(null, 'All'),
                    const SizedBox(width: 8),
                    _buildRoleChip('DOCTOR', '👨‍⚕️ Doctors'),
                    const SizedBox(width: 8),
                    _buildRoleChip('TEACHER', '👩‍🏫 Teachers'),
                    const SizedBox(width: 8),
                    _buildRoleChip('TRAINER', '🧑‍🏭 Trainers'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Contacts List
              Expanded(
                child: chatState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : contacts.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: controller,
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              final contact = contacts[index];
                              return _ContactTile(
                                contact: contact,
                                onTap: () => widget.onContactSelected(contact),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleChip(String? role, String label) {
    final isSelected = _selectedRole == role;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedRole = selected ? role : null);
        ref.read(chatProvider.notifier).loadContacts(role: role);
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No contacts available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different filter',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final AvailableContact contact;
  final VoidCallback onTap;

  const _ContactTile({
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _getRoleColor(contact.role),
            child: Text(
              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (contact.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        contact.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          Text(contact.roleDisplay),
          if (contact.block != null) ...[
            const Text(' • '),
            Text(contact.block!),
          ],
        ],
      ),
      trailing: const Icon(Icons.message_outlined),
    );
  }

  Color _getRoleColor(String role) {
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
}
