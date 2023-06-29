import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  var controller = WebViewController();

  void readResponse() async {
    var html = await controller
        .runJavaScriptReturningResult("window.document.body.innerText");
    String jsonString =
        html.toString().replaceAll('"', '').replaceAll('\\', '"');

    Map<String, dynamic> jsonData = json.decode(jsonString);

    print(jsonData['socialId']);
    print(jsonData['message']);
  }

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            print(url);
            if (url.contains("callback?")) {
              readResponse();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('https://test.com/auth/kakao'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView Example'),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
