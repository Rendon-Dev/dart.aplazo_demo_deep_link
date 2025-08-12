import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open URL',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OpenUrlScreen(),
    );
  }
}

class OpenUrlScreen extends StatefulWidget {
  const OpenUrlScreen({super.key});

  @override
  State<OpenUrlScreen> createState() => _OpenUrlScreenState();
}

class _OpenUrlScreenState extends State<OpenUrlScreen> {
  final TextEditingController _externalUrlController = TextEditingController();
  final TextEditingController _webviewUrlController = TextEditingController();
  static const platform = MethodChannel(
    'com.example.aplazo_demo_deep_link/deeplink',
  );

  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  Future<void> _handleDeepLink() async {
    try {
      final String? initialLink = await platform.invokeMethod('getInitialLink');
      if (initialLink != null) {
        _processDeepLink(initialLink);
      }
    } on PlatformException catch (e) {
      debugPrint("Error getting initial link: ${e.message}");
    }
  }

  void _processDeepLink(String link) {
    final uri = Uri.parse(link);
    if (uri.scheme == 'cashi' && uri.host == 'deeplink') {
      final action = uri.queryParameters['action'];
      final url = uri.queryParameters['url'];

      if (action == 'openUrl' && url != null) {
        setState(() {
          _externalUrlController.text = url;
        });
        _showSnackBar('URL cargada desde deeplink: $url');
      }
    }
  }

  Future<void> _openExternalUrl() async {
    final url = _externalUrlController.text.trim();
    if (url.isEmpty) {
      _showSnackBar('Por favor ingresa una URL');
      return;
    }

    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showSnackBar('Error al abrir la URL: $e');
    }
  }

  void _openWebView() {
    final url = _webviewUrlController.text.trim();
    if (url.isEmpty) {
      _showSnackBar('Por favor ingresa una URL');
      return;
    }

    try {
      final uri = Uri.parse(url);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WebViewScreen(url: uri.toString()),
        ),
      );
    } catch (e) {
      _showSnackBar('Error: URL inválida');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                'Open URL',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 60),

              // Primer input - Open app
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _externalUrlController,
                      decoration: InputDecoration(
                        hintText: 'Open app',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _openExternalUrl,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Open app',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Segundo input - Open webview
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _webviewUrlController,
                      decoration: InputDecoration(
                        hintText: 'Open webview',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _openWebView,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Open webview',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _externalUrlController.dispose();
    _webviewUrlController.dispose();
    super.dispose();
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
