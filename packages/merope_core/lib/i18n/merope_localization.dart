import 'package:flutter/material.dart';

class MeropeLocalization {
  final Locale locale;
  MeropeLocalization(this.locale);

  static const LocalizationsDelegate<MeropeLocalization> delegate = _MeropeLocalizationDelegate();

  static MeropeLocalization of(BuildContext context) {
    return Localizations.of<MeropeLocalization>(context, MeropeLocalization)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'privacy': 'Privacy',
      'security': 'Security',
      'chat': 'Chats',
      'edit': 'Edit',
      'delete': 'Delete',
      'reply': 'Reply',
      'forward': 'Forward',
      'pin': 'Pin',
      'search': 'Search',
      'ghost_mode': 'Ghost Mode',
      'last_seen': 'Last Seen',
      'biometric_lock': 'Biometric Access',
      'wallet': 'Wallet',
      'transfer': 'Transfer',
      'marketplace': 'Marketplace',
      'edit_profile': 'Edit Profile',
      'username': 'Username',
      'bio': 'Bio',
      'save': 'Save',
      'language': 'Language',
      'appearance': 'Interface',
      'data_storage': 'Data & Storage',
      'network_usage': 'Network Usage',
      'clear_cache': 'Clear Cache',
      'low_data_mode': 'Data Saver',
      'xp': 'Experience',
      'level': 'Level',
      'reputation': 'Reputation',
      'streak': 'Streak',
      'proposal': 'Proposal',
      'vote': 'Vote',
      'discussion': 'Discussion',
      'tally': 'Tally',
      'orbit_remix': 'Orbit Remix',
      'ai_studio': 'AI Studio',
      'voice_wave': 'Voice Wave',
      'escrow': 'Escrow',
      'release_funds': 'Release Funds',
      'auction': 'Auction',
      'milestone': 'Milestone',
      'boost': 'Boost',
      'neural_sync': 'Neural Sync',
      'verified_node': 'Verified Node',
      'influence_score': 'Influence Score',
      'synergy_wave': 'Synergy Wave',
      'atomic_tx': 'Atomic Transaction',
    },
    'tr': {
// ... existing tr dictionary ...
      'milestone': 'Kilometre Taşı',
      'boost': 'Öne Çıkar',
      'neural_sync': 'Sinirsel Senkronizasyon',
      'verified_node': 'Doğrulanmış Düğüm',
      'influence_score': 'Etki Puanı',
      'synergy_wave': 'Sinerji Dalgası',
      'atomic_tx': 'Atomik İşlem',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _MeropeLocalizationDelegate extends LocalizationsDelegate<MeropeLocalization> {
  const _MeropeLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<MeropeLocalization> load(Locale locale) async => MeropeLocalization(locale);

  @override
  bool shouldReload(_MeropeLocalizationDelegate old) => false;
}
