import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GeneralInfo extends StatefulWidget {
  const GeneralInfo({Key? key}) : super(key: key);

  @override
  State<GeneralInfo> createState() => _GeneralInfoState();
}

class _GeneralInfoState extends State<GeneralInfo> {
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
            title: Text(
              "General Info",
              style: GoogleFonts.notoSans(color: Colors.white),
            ),
          )),
      body: const WebView(
        initialUrl:
            "https://docs.google.com/document/d/1v9IAO-CeLMbZNK6w38ySMgDxBJB3FoiQP7xiglJt434/edit#heading=h.bo1kt97hko8q",
        javascriptMode: JavascriptMode.disabled,
      ),
    );
  }
}
