import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HpcBlog extends StatefulWidget {
  const HpcBlog({Key? key}) : super(key: key);

  @override
  State<HpcBlog> createState() => _HpcBlogState();
}

class _HpcBlogState extends State<HpcBlog> {
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
            title: Text("HPC Wall Mag", style: GoogleFonts.notoSans(color: Colors.white),),
          )),
      body: const WebView(
        initialUrl: "https://docs.google.com/document/d/15vFBS4JfZL27Qn8rVONvt_7qlNPv4nTHjo8gMGClX8I/edit",
        javascriptMode: JavascriptMode.disabled,
      ),
    );
  }
}
