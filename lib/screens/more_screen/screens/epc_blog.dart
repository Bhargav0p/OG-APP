import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EpcBlog extends StatefulWidget {
  const EpcBlog({Key? key}) : super(key: key);

  @override
  State<EpcBlog> createState() => _EpcBlogState();
}

class _EpcBlogState extends State<EpcBlog> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: const Color(0xff282934),
            leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("EPC Blog", style: GoogleFonts.notoSans(color: Colors.white),),
          )),
      body: const WebView(
        initialUrl: "https://epcbits.com/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
