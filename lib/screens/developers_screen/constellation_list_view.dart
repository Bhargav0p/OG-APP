import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';

import 'demo_data.dart';
import 'constellation_list_renderer.dart';
import 'main.dart';
import 'styles.dart';
import 'package:flutter/material.dart';

class ConstellationListView extends StatefulWidget {
  static const route = "ConstellationListView";

  final List<ConstellationData> constellations;
  final void Function(double) onScrolled;
  final void Function(ConstellationData, bool) onItemTap;

  const ConstellationListView({Key? key,required this.onScrolled,required this.onItemTap, required this.constellations}) : super(key: key);

  @override
  _ConstellationListViewState createState() => _ConstellationListViewState();
}

class _ConstellationListViewState extends State<ConstellationListView> {
  double _prevScrollPos = 0;
  double _scrollVel = 0;

  @override
  Widget build(BuildContext context) {
    //Build list using data
    return Align(
      child: Container(
        width: 600,
        child: Stack(
          children: [
            //Scrolling list, draw this first so it's under the other content
            _buildScrollingList(),
            //Cover the list with black gradients on top & bottom
            _buildGradientOverlay(),
            //Top left text
            _buildHeaderText(),
            //Top right text
             _buildLocationText()
          ],
        ),
      ),
    );
  }

  Container _buildScrollingList() {
    var data = widget.constellations;
    //Seed our random number generator, so the padding is always consistent between runs (Designers are picky!)
    var rand = Random(1);
    return Container(
      //Wrap list in a NotificationListener, so we can detect scroll updates
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Padding(
          padding:  EdgeInsets.only(left: 10,right: 10),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: data.length,
            //Add some extra padding to the top & bottom of the list
            padding: EdgeInsets.only(top: 150, bottom: 200),
            itemBuilder: (context, index) {
              //Calculate random padding for each renderer as per the design. Design requested that the first item is not random, all others are
              double padding = (index == 0) ? 20 : rand.nextInt(4) * 20.0;
              //Create the list renderer, injecting it with some ConstellationData
              return ConstellationListRenderer(
                //Re-dispatch our tap event to anyone who is listening
                onTap: widget.onItemTap,
                redMode: index % 2 == 1,
                data: data[index],
                hzPadding: padding,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Positioned(
      width: 200,
      left: 40,
      top: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          Text(
            "MEET THE \nDEVELOPERS",
            style: TextStyle(color: Colors.white, fontSize: 23, fontFamily: 'sui-generis', height: 1.05, package: App.pkg),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    double firstGradientStop = .2;
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Color(0x0), Color(0x0), Colors.black],
                stops: [0, firstGradientStop, 1 - firstGradientStop, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
      ),
    );
  }

  Positioned _buildLocationText() {
    return Positioned(
      width: 120,
      right: 16,
      top: 30,
      child: SvgPicture.asset('lib/screens/developers_screen/assets/DVM_Logo.svg')
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    //Determine scrollVelocity and dispatch it to any listeners
    _scrollVel = notification.metrics.pixels - _prevScrollPos;
    if (widget.onScrolled != null) {
      widget.onScrolled(_scrollVel);
    }
    //print(notification.metrics.pixels - _prevScroll);
    _prevScrollPos = notification.metrics.pixels;
    //Return true to cancel the notification bubbling, we've handled it here.
    return true;
  }
}
