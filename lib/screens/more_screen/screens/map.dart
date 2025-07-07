import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BitsMap extends StatefulWidget {
  const BitsMap({Key? key}) : super(key: key);

  @override
  State<BitsMap> createState() => _BitsMapState();
}

class _BitsMapState extends State<BitsMap> {
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
            backgroundColor: Color(0xff282934),
            leading: IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("Map", style: GoogleFonts.notoSans(color: Colors.white),),
          )),
      body: const WebView(
        initialUrl: "https://map.epcbits.com/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
