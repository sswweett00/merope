import 'package:flutter/material.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';

class MediaPickerSheet extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onFileTap;
  final VoidCallback onLocationTap;
  final VoidCallback? onGifTap;
  final VoidCallback? onStickerTap;

  const MediaPickerSheet({
    super.key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onFileTap,
    required this.onLocationTap,
    this.onGifTap,
    this.onStickerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MeropeTokens.space24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(MeropeTokens.radiusLg)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: MeropeTokens.space16,
            runSpacing: MeropeTokens.space16,
            alignment: WrapAlignment.spaceAround,
            children: [
              _MediaOption(
                icon: Icons.camera_alt,
                label: 'Kamera',
                color: Colors.blue,
                onTap: onCameraTap,
              ),
              _MediaOption(
                icon: Icons.photo_library,
                label: 'Galeri',
                color: Colors.purple,
                onTap: onGalleryTap,
              ),
              _MediaOption(
                icon: Icons.gif_box_rounded,
                label: 'GIF',
                color: Colors.pink,
                onTap: onGifTap ?? () {},
              ),
              _MediaOption(
                icon: Icons.sticky_note_2_rounded,
                label: 'Sticker',
                color: Colors.teal,
                onTap: onStickerTap ?? () {},
              ),
              _MediaOption(
                icon: Icons.insert_drive_file,
                label: 'Dosya',
                color: Colors.orange,
                onTap: onFileTap,
              ),
              _MediaOption(
                icon: Icons.location_on,
                label: 'Konum',
                color: Colors.green,
                onTap: onLocationTap,
              ),
            ],
          ),
          const SizedBox(height: MeropeTokens.space16),
        ],
      ),
    );
  }
}

class _MediaOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MediaOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
