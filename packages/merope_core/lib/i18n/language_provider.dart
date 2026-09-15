import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLanguage extends Notifier<String> {
  @override
  String build() {
    return 'tr'; // Default Turkish
  }

  void setLanguage(String code) {
    state = code;
  }
}

final appLanguageProvider = NotifierProvider<AppLanguage, String>(AppLanguage.new);
