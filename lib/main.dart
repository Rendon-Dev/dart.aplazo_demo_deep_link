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
    // Precargar la URL de Aplazo para testing
    _webviewUrlController.text = '';
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
  String? _errorMessage;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (String url) {
                debugPrint('WebView: Página iniciando carga: $url');
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
              },
              onPageFinished: (String url) {
                debugPrint('WebView: Página cargada exitosamente: $url');
                setState(() {
                  _isLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('WebView error: ${error.description}');
                debugPrint('Error code: ${error.errorCode}');

                String errorMsg = _getErrorMessage(error);
                setState(() {
                  _isLoading = false;
                  _errorMessage = errorMsg;
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                debugPrint('WebView: Navegando a: ${request.url}');
                return NavigationDecision.navigate;
              },
              onUrlChange: (UrlChange change) {
                debugPrint('WebView: URL cambiada a: ${change.url}');
              },
            ),
          )
          ..setUserAgent(
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          )
          ..enableZoom(false);

    _loadUrlWithRetry();
  }

  String _getErrorMessage(WebResourceError error) {
    switch (error.errorCode) {
      case -2: // ERROR_HOST_LOOKUP
        return 'Error de conexión: No se pudo resolver el host';
      case -6: // ERROR_CONNECT
        return 'Error de conexión: No se pudo conectar al servidor';
      case -8: // ERROR_TIMEOUT
        return 'Error de conexión: Tiempo de espera agotado';
      case -106: // ERROR_INTERNET_DISCONNECTED
        return 'Error de conexión: Sin conexión a internet';
      case -105: // ERROR_CONNECTION_REFUSED
        return 'Error de conexión: Conexión rechazada por el servidor';
      case -7: // ERROR_FAILED
        return 'Error de conexión: Fallo en la carga de la página';
      default:
        return 'Error ${error.errorCode}: ${error.description}';
    }
  }

  void _loadUrlWithRetry() {
    if (_retryCount >= _maxRetries) {
      setState(() {
        _errorMessage =
            'Se agotaron los intentos de conexión. Verifica tu conexión a internet.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _retryCount++;
    debugPrint(
      'WebView: Intento $_retryCount de $_maxRetries para cargar: ${widget.url}',
    );

    // Agregar delay progresivo entre reintentos
    if (_retryCount > 1) {
      Future.delayed(Duration(seconds: _retryCount), () {
        if (mounted) {
          _performLoadRequest();
        }
      });
    } else {
      _performLoadRequest();
    }
  }

  void _performLoadRequest() {
    // Configurar headers más permisivos y compatibles
    _controller.loadRequest(
      Uri.parse(widget.url),
      headers: {
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'Accept-Language': 'es-MX,es;q=0.9,en;q=0.8',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
        'Sec-Fetch-Dest': 'document',
        'Sec-Fetch-Mode': 'navigate',
        'Sec-Fetch-Site': 'none',
        'Sec-Fetch-User': '?1',
        'Cache-Control': 'max-age=0',
        'DNT': '1',
        'User-Agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      },
    );
  }

  void _retryLoad() {
    _loadUrlWithRetry();
  }

  void _resetAndRetry() {
    setState(() {
      _retryCount = 0;
    });
    _loadUrlWithRetry();
  }

  void _openInExternalBrowser() async {
    try {
      final uri = Uri.parse(widget.url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showSnackBar('Error al abrir en navegador externo: $e');
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
      appBar: AppBar(
        title: const Text('WebView'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          if (_errorMessage == null)
            WebViewWidget(controller: _controller)
          else
            _buildErrorWidget(),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error al cargar la página',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Error desconocido',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                const Text(
                  'Sugerencias:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Verifica tu conexión a internet\n• Intenta cargar la página nuevamente\n• Si persiste, abre en navegador externo',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                if (_retryCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Intento $_retryCount de $_maxRetries',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _retryLoad,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _openInExternalBrowser,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Abrir externo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_retryCount > 0)
            OutlinedButton.icon(
              onPressed: _resetAndRetry,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reiniciar y reintentar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange),
              ),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Volver'),
          ),
        ],
      ),
    );
  }
}
