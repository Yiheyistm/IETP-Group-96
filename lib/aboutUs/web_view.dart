import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelmetWebView extends StatefulWidget {
  final String? url;

  const HelmetWebView({super.key, this.url});
  @override
  _HelmetWebViewState createState() => _HelmetWebViewState();
}

class _HelmetWebViewState extends State<HelmetWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..setBackgroundColor(const Color(0x00000000)) // Set background color
      ..loadRequest(Uri.parse(widget.url ??
          'https://smart-helmet-landing-page.vercel.app/')); // Load the initial URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller, // Use the WebViewController
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh',
        backgroundColor: Colors.black26,
        onPressed: () {
          _controller.reload(); // Reload the WebView
        },
        child: const Icon(
          Icons.refresh,
          color: Colors.amber,
        ),
      ),
    );
  }
}
