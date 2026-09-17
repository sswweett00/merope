import 'package:flutter/widgets.dart';

enum PluginExtensionPoint {
  sidebarItem,
  messageComponent,
  contextMenu,
  commandPalette,
  settingsPanel,
  floatingPanel,
}

abstract class MeropePlugin {
  String get id;
  String get name;
  String get version;
  String get author;

  List<PluginExtensionPoint> get supportedExtensionPoints;

  void onInitialize();
  Widget buildExtensionWidget(PluginExtensionPoint extensionPoint,
      BuildContext context, Map<String, dynamic> params);
  void onDestroy();
}
