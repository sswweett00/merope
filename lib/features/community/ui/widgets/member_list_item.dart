import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import '../../domain/models/community_model.dart';

class MemberListItem extends StatelessWidget {
  final CommunityMember member;
  final Function(String)? onPromote;
  final Function(String)? onBan;

  const MemberListItem({
    super.key,
    required this.member,
    this.onPromote,
    this.onBan,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: MeropeImage.avatar(
        imageUrl: member.avatarUrl,
        radius: 20,
        initials: member.username,
      ),
      title: Row(
        children: [
          Text(member.username),
          if (member.badges.isNotEmpty) ...[
            const SizedBox(width: 8),
            ...member.badges.map((badge) => Chip(
              label: Text(badge),
              labelStyle: const TextStyle(fontSize: 10),
              backgroundColor: Colors.blue.withValues(alpha: 0.1),
            )),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Role: ${member.role.name}'),
          Row(
            children: [
              Icon(Icons.post_add, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${member.postCount} posts'),
              const SizedBox(width: 16),
              Icon(Icons.comment, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${member.commentCount} comments'),
              const SizedBox(width: 16),
              Icon(Icons.star, size: 12, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${member.reputation} rep'),
            ],
          ),
        ],
      ),
      trailing: _buildTrailing(context),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'promote':
            _showPromoteDialog(context);
            break;
          case 'ban':
            _showBanDialog(context);
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'promote',
          child: Text('Change Role'),
        ),
        const PopupMenuItem(
          value: 'ban',
          child: Text('Ban Member'),
        ),
      ],
    );
  }

  void _showPromoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CommunityRole.values.map((role) {
            return ListTile(
              title: Text(role.name),
              onTap: () {
                Navigator.pop(context);
                onPromote?.call(role.name);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showBanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ban Member'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Reason for ban'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onBan?.call('Violation of community guidelines');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ban'),
          ),
        ],
      ),
    );
  }
}
