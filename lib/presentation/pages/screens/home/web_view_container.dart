import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({super.key});
  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {

  bool _isLoading = true;
    late WebViewController _controller; 

    @override
  void initState() {
    super.initState();
    // Initialize the WebView controller and set up the navigation delegate
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          setState(() {
            _isLoading = false; // Set _isLoading to false when page finishes loading
          });
        },
      ))
      ..loadRequest(Uri.parse('https://zingphotography.com'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: StaticAppBar.homeAppBar(context, "Zing Photography", false, ""),
           body: 
           _isLoading
          ? Center(child: CircularProgressIndicator(color: blueColor))
          : WebViewWidget(controller: _controller),

    );
  }
}