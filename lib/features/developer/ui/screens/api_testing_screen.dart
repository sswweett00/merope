import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_ui/theme/tokens/merope_tokens.dart';
import 'package:merope_ui/theme/theme_provider.dart';

class ApiTestingScreen extends ConsumerStatefulWidget {
  final String appId;

  const ApiTestingScreen({super.key, required this.appId});

  @override
  ConsumerState<ApiTestingScreen> createState() => _ApiTestingScreenState();
}

class _ApiTestingScreenState extends ConsumerState<ApiTestingScreen> {
  String _method = 'GET';
  final _urlController =
      TextEditingController(text: 'https://api.merope.dev/v10/developer/apps');
  final _bodyController =
      TextEditingController(text: jsonEncode({'sample': 'payload'}));
  final List<ApiHistoryEntry> _history = [];
  ApiHistoryEntry? _selected;
  String _response = '';
  int? _statusCode;
  bool _isLoading = false;
  final Dio _dio = Dio();

  final Map<String, String> _envVars = {
    'BASE_URL': 'https://api.merope.dev',
    'API_KEY': '••••••'
  };

  @override
  Widget build(BuildContext context) {
    final tokens = ref.watch(themeProvider).currentTokens;
    return Scaffold(
      backgroundColor: tokens.background,
      appBar: AppBar(
          backgroundColor: tokens.surface,
          title:
              Text('API Test Lab', style: TextStyle(color: tokens.textPrimary)),
          iconTheme: IconThemeData(color: tokens.textPrimary)),
      body: Row(
        children: [
          Expanded(flex: 5, child: _buildEditorPanel(tokens)),
          const SizedBox(width: 2),
          Expanded(flex: 3, child: _buildHistoryPanel(tokens)),
        ],
      ),
    );
  }

  Widget _buildEditorPanel(MeropeColorTokens tokens) {
    return Padding(
      padding: const EdgeInsets.all(MeropeTokens.space16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          _methodDropdown(tokens),
          const SizedBox(width: 12),
          Expanded(
              child: TextField(
            controller: _urlController,
            style:
                TextStyle(color: tokens.textPrimary, fontFamily: 'monospace'),
            decoration: InputDecoration(
                hintText: 'https://...',
                hintStyle: TextStyle(
                    color: tokens.textSecondary.withValues(alpha: 0.4)),
                filled: true,
                fillColor: tokens.background,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
                    borderSide: BorderSide(color: tokens.border))),
          )),
          const SizedBox(width: 12),
          _envVarsButton(tokens),
        ]),
        const SizedBox(height: 16),
        Text('Request Body',
            style: TextStyle(
                color: tokens.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Expanded(
            child: RepaintBoundary(
                child: _SyntaxHighlightEditor(
                    controller: _bodyController, tokens: tokens))),
        const SizedBox(height: 16),
        Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
                onPressed: _sendRequest,
                child: _isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: tokens.onPrimary))
                    : const Text('Send'))),
        if (_response.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Response',
              style: TextStyle(
                  color: tokens.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Expanded(
              flex: 2,
              child: RepaintBoundary(
                  child: _ResponseViewer(
                      response: _response,
                      statusCode: _statusCode,
                      tokens: tokens))),
        ],
      ]),
    );
  }

  Widget _methodDropdown(MeropeColorTokens tokens) {
    return DropdownButton<String>(
      value: _method,
      dropdownColor: tokens.surface,
      items: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE']
          .map((m) => DropdownMenuItem(
              value: m,
              child: Text(m,
                  style: TextStyle(
                      color: _methodColor(m, tokens),
                      fontWeight: FontWeight.bold))))
          .toList(),
      onChanged: (v) => setState(() => _method = v ?? 'GET'),
    );
  }

  Color _methodColor(String method, MeropeColorTokens tokens) {
    return switch (method) {
      'GET' => tokens.secondary,
      'POST' => Colors.orange,
      'PUT' => Colors.blue,
      'PATCH' => Colors.purple,
      'DELETE' => tokens.error,
      _ => tokens.textPrimary,
    };
  }

  Widget _envVarsButton(MeropeColorTokens tokens) {
    return IconButton(
        icon: Icon(Icons.code, color: tokens.textSecondary),
        tooltip: 'Environment Variables (${_envVars.length})',
        onPressed: _showEnvVars);
  }

  void _showEnvVars() {
    showModalBottomSheet(
      context: context,
      backgroundColor: MeropeColorTokens.darkDefault().surface,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(MeropeTokens.space16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Environment Variables',
              style: TextStyle(
                  color: MeropeColorTokens.darkDefault().textPrimary,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: MeropeTokens.space12),
          ..._envVars.entries
              .map((e) => Row(children: [
                    Expanded(
                        child: Text(e.key,
                            style: TextStyle(
                                color: MeropeColorTokens.darkDefault()
                                    .textSecondary))),
                    Expanded(
                        child: Text(e.value,
                            style: TextStyle(
                                color:
                                    MeropeColorTokens.darkDefault().textPrimary,
                                fontFamily: 'monospace'),
                            overflow: TextOverflow.ellipsis)),
                  ]))
              .toList(),
        ]),
      ),
    );
  }

  Future<void> _sendRequest() async {
    final resolvedUrl = _urlController.text;
    setState(() {
      _isLoading = true;
      _response = '';
      _statusCode = null;
    });
    HapticFeedback.selectionClick();
    try {
      final options = Options(headers: {
        'Authorization': 'Bearer ${_envVars['API_KEY'] ?? ''}',
        'Content-Type': 'application/json'
      });
      final response = await _dio.request(resolvedUrl,
          data: _bodyController.text.isNotEmpty ? _bodyController.text : null,
          options: options.copyWith(method: _method));
      final body = response.data is String
          ? response.data as String
          : jsonEncode(response.data);
      final entry = ApiHistoryEntry(
          method: _method,
          url: resolvedUrl,
          statusCode: response.statusCode ?? 0,
          response: body,
          timestamp: DateTime.now());
      setState(() {
        _response = body;
        _statusCode = response.statusCode;
        _history.insert(0, entry);
        _selected = entry;
      });
    } on DioException catch (e) {
      final body = e.response?.data?.toString() ?? e.message ?? 'Unknown error';
      final entry = ApiHistoryEntry(
          method: _method,
          url: resolvedUrl,
          statusCode: e.response?.statusCode ?? 0,
          response: body,
          timestamp: DateTime.now(),
          isError: true);
      setState(() {
        _response = body;
        _statusCode = e.response?.statusCode;
        _history.insert(0, entry);
        _selected = entry;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildHistoryPanel(MeropeColorTokens tokens) {
    return Container(
      decoration: BoxDecoration(
          color: tokens.surface,
          border: Border(left: BorderSide(color: tokens.border))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.all(MeropeTokens.space12),
            child: Text('History',
                style: TextStyle(
                    color: tokens.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14))),
        Expanded(
          child: _history.isEmpty
              ? Center(
                  child: Text('No requests yet',
                      style:
                          TextStyle(color: tokens.textSecondary, fontSize: 12)))
              : ListView.separated(
                  itemCount: _history.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: tokens.border, height: 1),
                  itemBuilder: (context, i) {
                    final e = _history[i];
                    return ListTile(
                      leading: CircleAvatar(
                          backgroundColor: _methodColor(e.method, tokens)
                              .withValues(alpha: 0.2),
                          child: Text(e.method,
                              style: TextStyle(
                                  color: _methodColor(e.method, tokens),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          radius: 14),
                      title: Text(e.url,
                          style: TextStyle(
                              color: tokens.textPrimary,
                              fontSize: 11,
                              fontFamily: 'monospace'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                          '${e.timestamp.hour}:${e.timestamp.minute.toString().padLeft(2, '0')} • ${e.statusCode}',
                          style: TextStyle(
                              color: tokens.textSecondary, fontSize: 10)),
                      trailing: Icon(Icons.chevron_right,
                          color: tokens.textSecondary.withValues(alpha: 0.5),
                          size: 14),
                      selected: _selected == e,
                      onTap: () => setState(() {
                        _selected = e;
                        _response = e.response;
                        _statusCode = e.statusCode;
                        _method = e.method;
                        _urlController.text = e.url;
                      }),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}

class ApiHistoryEntry {
  final String method;
  final String url;
  final int statusCode;
  final String response;
  final DateTime timestamp;
  final bool isError;

  const ApiHistoryEntry(
      {required this.method,
      required this.url,
      required this.statusCode,
      required this.response,
      required this.timestamp,
      this.isError = false});
}

class _SyntaxHighlightEditor extends StatefulWidget {
  final TextEditingController controller;
  final MeropeColorTokens tokens;

  const _SyntaxHighlightEditor(
      {required this.controller, required this.tokens});

  @override
  State<_SyntaxHighlightEditor> createState() => _SyntaxHighlightEditorState();
}

class _SyntaxHighlightEditorState extends State<_SyntaxHighlightEditor> {
  String _previewText = '';

  @override
  void initState() {
    super.initState();
    _previewText = widget.controller.text;
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant _SyntaxHighlightEditor old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      old.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
      _previewText = widget.controller.text;
    }
  }

  void _onChanged() {
    final next = widget.controller.text;
    if (next != _previewText) {
      setState(() => _previewText = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      TextField(
        controller: widget.controller,
        maxLines: null,
        expands: true,
        style:
            TextStyle(color: widget.tokens.textPrimary.withValues(alpha: 0.0)),
        cursorColor: widget.tokens.primary,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
              borderSide: BorderSide(color: widget.tokens.border)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          filled: true,
          fillColor: widget.tokens.background,
        ),
      ),
      Positioned.fill(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: SelectableText.rich(
              TextSpan(
                  style: TextStyle(fontFamily: 'monospace', fontSize: 13),
                  children:
                      _JsonSyntaxParser.highlight(_previewText, widget.tokens)),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    ]);
  }
}

class _ResponseViewer extends StatelessWidget {
  final String response;
  final int? statusCode;
  final MeropeColorTokens tokens;

  const _ResponseViewer(
      {required this.response, this.statusCode, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        (statusCode ?? 0) >= 400 ? tokens.error : tokens.onlineStatus;
    final spans = _JsonSyntaxParser.highlight(response, tokens);
    return Container(
      decoration: BoxDecoration(
          color: tokens.background,
          borderRadius: BorderRadius.circular(MeropeTokens.radiusSm),
          border: Border.all(color: tokens.border)),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('HTTP ${statusCode ?? 'N/A'}',
              style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
          const SizedBox(width: 8),
          Text(DateTime.now().millisecondsSinceEpoch.toString(),
              style: TextStyle(
                  color: tokens.textSecondary.withValues(alpha: 0.5),
                  fontSize: 10))
        ]),
        const SizedBox(height: 8),
        Expanded(
            child: SingleChildScrollView(
                child: SelectableText.rich(TextSpan(
                    style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    children: spans)))),
      ]),
    );
  }
}

class _JsonSyntaxParser {
  static List<InlineSpan> highlight(String input, MeropeColorTokens tokens) {
    final spans = <InlineSpan>[];
    final trim = input.trim();
    try {
      final parsed = jsonDecode(trim);
      spans.addAll(_formatValue(parsed, tokens));
    } catch (_) {
      spans.add(
          TextSpan(text: input, style: TextStyle(color: tokens.textPrimary)));
    }
    return spans;
  }

  static List<InlineSpan> _formatValue(dynamic value, MeropeColorTokens tokens,
      [int depth = 0]) {
    final List<InlineSpan> spans = [];
    const indent = '  ';
    if (value is Map) {
      if (value.isEmpty) {
        spans.add(TextSpan(
            text: '{}', style: TextStyle(color: tokens.textSecondary)));
        return spans;
      }
      spans.add(
          TextSpan(text: '{\n', style: TextStyle(color: tokens.textSecondary)));
      int i = 0;
      for (final entry in value.entries) {
        spans.add(TextSpan(
            text: indent * (depth + 1),
            style:
                TextStyle(color: tokens.textSecondary.withValues(alpha: 0.3))));
        spans.add(TextSpan(
            text: '"${entry.key}"',
            style: TextStyle(color: const Color(0xFF9FBF76))));
        spans.add(
            TextSpan(text: ': ', style: TextStyle(color: tokens.textPrimary)));
        spans.addAll(_formatValue(entry.value, tokens, depth + 1));
        spans.add(TextSpan(
            text: i == value.length - 1 ? '\n' : ',\n',
            style: TextStyle(color: tokens.textSecondary)));
        i++;
      }
      spans.add(TextSpan(
          text: indent * depth,
          style:
              TextStyle(color: tokens.textSecondary.withValues(alpha: 0.3))));
      spans.add(
          TextSpan(text: '}', style: TextStyle(color: tokens.textSecondary)));
    } else if (value is List) {
      if (value.isEmpty) {
        spans.add(TextSpan(
            text: '[]', style: TextStyle(color: tokens.textSecondary)));
        return spans;
      }
      spans.add(
          TextSpan(text: '[\n', style: TextStyle(color: tokens.textSecondary)));
      for (int i = 0; i < value.length; i++) {
        spans.add(TextSpan(
            text: indent * (depth + 1),
            style:
                TextStyle(color: tokens.textSecondary.withValues(alpha: 0.3))));
        spans.addAll(_formatValue(value[i], tokens, depth + 1));
        spans.add(TextSpan(
            text: i == value.length - 1 ? '\n' : ',\n',
            style: TextStyle(color: tokens.textSecondary)));
      }
      spans.add(TextSpan(
          text: indent * depth,
          style:
              TextStyle(color: tokens.textSecondary.withValues(alpha: 0.3))));
      spans.add(
          TextSpan(text: ']', style: TextStyle(color: tokens.textSecondary)));
    } else if (value is String) {
      spans.add(TextSpan(
          text: '"$value"', style: TextStyle(color: const Color(0xFF9FBF76))));
    } else if (value is bool) {
      spans.add(TextSpan(
          text: value.toString(), style: TextStyle(color: Colors.orange)));
    } else if (value is num) {
      spans.add(TextSpan(
          text: value.toString(),
          style: TextStyle(color: const Color(0xFFB5B1E7))));
    } else if (value == null) {
      spans.add(TextSpan(
          text: 'null', style: TextStyle(color: const Color(0xFFB5B1E7))));
    }
    return spans;
  }
}
