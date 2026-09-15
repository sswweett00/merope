import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import '../../domain/models/community_model.dart';

class CommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
    this.onJoin,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              MeropeImage.avatar(
                imageUrl: community.avatarUrl,
                radius: 20,
                initials: community.name,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          community.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (community.isVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.verified, size: 16, color: Colors.blue),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      community.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.people, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${community.memberCount} members',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.category, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          community.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (onJoin != null && !community.isJoined)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ElevatedButton(
                    onPressed: onJoin,
                    child: const Text('Join'),
                  ),
                ),
              if (onLeave != null && community.isJoined)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: OutlinedButton(
                    onPressed: onLeave,
                    child: const Text('Leave'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
