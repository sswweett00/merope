import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/theme_provider.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/widgets/merope_card.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: 'merope_user');
    _bioController = TextEditingController(
        text:
            'Architect of digital waves. Exploring the intersection of neural networks and social synergy. 🌊⚡🌀');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;

    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        backgroundColor: tokens.surface,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kaydet',
                style: TextStyle(
                    color: tokens.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(MeropeTokens.space24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: tokens.primary,
                    child: const Text('M',
                        style: TextStyle(fontSize: 40, color: Colors.white)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: tokens.surface, shape: BoxShape.circle),
                      child: Icon(Icons.camera_alt,
                          color: tokens.primary, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MeropeTokens.space32),
            MeropeCard(
              color: tokens.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          labelText: 'Kullanıcı Adı',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _bioController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText: 'Biyografi', border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
