import 'package:flutter/material.dart';
import 'package:merope_ui/merope_ui.dart';
import '../../domain/models/community_model.dart';

class EventCard extends StatelessWidget {
  final CommunityEvent event;
  final Function(String)? onRsvp;

  const EventCard({
    super.key,
    required this.event,
    this.onRsvp,
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
            if (event.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: MeropeImage(
                  imageUrl: event.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.event)),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(event.startTime),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.locationName,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (event.ticketInfo.isRequired) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.confirmation_number,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${event.ticketInfo.currency} ${event.ticketInfo.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${event.ticketInfo.availableTickets} tickets available',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                    '${event.currentAttendees}/${event.maxAttendees} attending'),
                const Spacer(),
                if (onRsvp != null)
                  OutlinedButton(
                    onPressed: () => onRsvp?.call('attending'),
                    child: const Text('RSVP'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    String chipLabel;

    switch (event.status) {
      case EventStatus.draft:
        chipColor = Colors.grey;
        chipLabel = 'Draft';
        break;
      case EventStatus.published:
        chipColor = Colors.green;
        chipLabel = 'Published';
        break;
      case EventStatus.cancelled:
        chipColor = Colors.red;
        chipLabel = 'Cancelled';
        break;
      case EventStatus.completed:
        chipColor = Colors.blue;
        chipLabel = 'Completed';
        break;
    }

    return Chip(
      label: Text(chipLabel),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: chipColor, fontSize: 12),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
