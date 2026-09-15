import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import '../../domain/models/community_model.dart';

class ThreadCard extends StatelessWidget {
  final CollectiveThread thread;
  final Function(bool)? onResonate;
  final VoidCallback? onReply;
  final VoidCallback? onPin;
  final VoidCallback? onLock;
  final VoidCallback? onViewStats;

  const ThreadCard({
    super.key,
    required this.thread,
    this.onResonate,
    this.onReply,
    this.onPin,
    this.onLock,
    this.onViewStats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                MeropeImage.avatar(
                  imageUrl: thread.authorAvatar,
                  radius: 20,
                  initials: thread.authorName,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              thread.authorName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (thread.isPinned)
                            const Icon(Icons.push_pin, size: 16, color: Colors.orange),
                          if (thread.isLocked)
                            const Icon(Icons.lock, size: 16, color: Colors.red),
                          if (thread.isAnnouncement)
                            const Icon(Icons.announcement, size: 16, color: Colors.blue),
                        ],
                      ),
                      Text(
                        _formatDate(thread.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              thread.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              thread.content,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (thread.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: thread.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    labelStyle: const TextStyle(fontSize: 12),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _buildActionButton(
                  icon: Icons.thumb_up,
                  label: thread.resonance.toString(),
                  onTap: () => onResonate?.call(true),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.thumb_down,
                  label: '',
                  onTap: () => onResonate?.call(false),
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.comment,
                  label: thread.replyCount.toString(),
                  onTap: onReply,
                ),
                const SizedBox(width: 16),
                _buildActionButton(
                  icon: Icons.visibility,
                  label: thread.viewCount.toString(),
                  onTap: onViewStats,
                ),
                const Spacer(),
                if (onPin != null)
                  IconButton(
                    icon: Icon(thread.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                    onPressed: onPin,
                    tooltip: thread.isPinned ? 'Unpin' : 'Pin',
                  ),
                if (onLock != null)
                  IconButton(
                    icon: Icon(thread.isLocked ? Icons.lock : Icons.lock_open),
                    onPressed: onLock,
                    tooltip: thread.isLocked ? 'Unlock' : 'Lock',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
