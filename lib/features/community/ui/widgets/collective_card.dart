import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import '../../domain/models/community_model.dart';

class CollectiveCard extends StatelessWidget {
  final Collective collective;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;

  const CollectiveCard({
    super.key,
    required this.collective,
    this.onTap,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MeropeImage.avatar(
                    imageUrl: collective.icon,
                    radius: 20,
                    initials: collective.name,
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
                                collective.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (collective.isOfficial)
                              const Icon(Icons.verified,
                                  size: 16, color: Colors.blue),
                          ],
                        ),
                        Text(
                          collective.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                collective.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.psychology, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    collective.influence.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.people, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${collective.memberCount} members',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (onJoin != null)
                    TextButton(
                      onPressed: onJoin,
                      child: const Text('Join'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildStatCard('Threads', collective.stats.totalThreads),
                  const SizedBox(width: 8),
                  _buildStatCard('Replies', collective.stats.totalReplies),
                  const SizedBox(width: 8),
                  _buildStatCard('Activity', collective.stats.weeklyActivity),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
