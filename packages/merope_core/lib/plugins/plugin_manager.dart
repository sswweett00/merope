import 'package:flutter/widgets.dart';
import 'plugin_contract.dart';

class PluginManager {
  final Map<String, MeropePlugin> _plugins = {};
  final Map<PluginExtensionPoint, List<MeropePlugin>> _extensionMap = {};

  static final PluginManager _instance = PluginManager._internal();
  factory PluginManager() => _instance;
  PluginManager._internal();

  void registerPlugin(MeropePlugin plugin) {
    if (_plugins.containsKey(plugin.id)) {
      debugPrint('Plugin ${plugin.id} already registered.');
      return;
    }

    _plugins[plugin.id] = plugin;
    for (final point in plugin.supportedExtensionPoints) {
      _extensionMap.putIfAbsent(point, () => []).add(plugin);
    }

    try {
      plugin.onInitialize();
      debugPrint('Plugin ${plugin.name} v${plugin.version} registered.');
    } catch (e) {
      _plugins.remove(plugin.id);
      for (final list in _extensionMap.values) {
        list.remove(plugin);
      }
      debugPrint('Plugin ${plugin.name} failed to initialize: $e');
    }
  }

  void unregisterPlugin(String pluginId) {
    final plugin = _plugins.remove(pluginId);
    if (plugin != null) {
      for (final list in _extensionMap.values) {
        list.remove(plugin);
      }
      plugin.onDestroy();
      debugPrint('Plugin $pluginId unregistered.');
    }
  }

  List<MeropePlugin> getPluginsFor(PluginExtensionPoint point) {
    return _extensionMap[point] ?? [];
  }

  List<Widget> buildExtensions(
    PluginExtensionPoint point,
    BuildContext context,
    Map<String, dynamic> params,
  ) {
    return getPluginsFor(point)
        .map((p) => p.buildExtensionWidget(point, context, params))
        .toList();
  }
}
