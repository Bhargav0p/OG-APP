import 'dart:math' as math;

import 'package:apogee_2022/screens/orders/order_screen_viewmodel.dart';
import 'package:apogee_2022/widgets/loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'repo/model/order_card_model.dart';

class OrderStatus extends StatefulWidget {
  OrderCardModel orderCardModel;

  OrderStatus({required this.orderCardModel, Key? key}) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus>
    with TickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late Animation<double> _animation;
  late double progress;
  late Stream<DocumentSnapshot> collectionStream;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  @override
  void initState() {
    isLoading.value = true;
    print('went into in init');
    print('new order id');
    print(widget.orderCardModel.orderId);
    collectionStream = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderCardModel.orderId.toString())
        .snapshots();
    setProgress(widget.orderCardModel.status);
    print(progress);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    print('reaches first animation2222');
    isLoading.value = false;

    _controller.forward();
    print('done');
    widget.orderCardModel.status2.value = widget.orderCardModel.status;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  setProgress(int status) {
    if (status >= 4) {
      progress = 0;
    } else {
      progress = (status + 1) / 4;
    }
  }

  Future<void> regularAnimation(double start) async {
    print('reaches first animation');
    setProgress(widget.orderCardModel.status);
    _controller.reset();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: start, end: progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    print('reaches first animation2');
    await _controller.forward();
    widget.orderCardModel.status2.value = widget.orderCardModel.status;
    print('reaches first animation3');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (context, bool value, child) {
          if (value) {
            return const Loader();
          } else {
            return StreamBuilder<DocumentSnapshot>(
                stream: collectionStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Loader();
                  } else {
                    if (snapshot.data != null &&
                        snapshot.data!.data() is Map<String, dynamic>) {
                      Map<String, dynamic> data =
                          snapshot.data!.data()! as Map<String, dynamic>;
                      if (data.containsKey('status')) {
                        int newStatus = data['status'] as int;
                        if (widget.orderCardModel.status != newStatus) {
                          int oldStatus = widget.orderCardModel.status;
                          print("Old status: $oldStatus");
                          print("New status: $newStatus");
                          print('notify');
                          widget.orderCardModel.status = newStatus;
                          print('went here inside');
                          regularAnimation(
                              oldStatus == 4 ? 0 : (oldStatus + 1) / 4);
                          if (newStatus == 3 ||
                              newStatus == 4 && oldStatus < 3) {
                            try {
                              OrderScreenViewModel.pastOrders
                                  .add(widget.orderCardModel);
                              OrderScreenViewModel.ongoingOrders
                                  .remove(widget.orderCardModel);
                            } catch (e) {
                              print(e);
                            }
                          } else if (newStatus < 3 && oldStatus >= 3) {
                            try {
                              OrderScreenViewModel.pastOrders
                                  .remove(widget.orderCardModel);
                              OrderScreenViewModel.ongoingOrders
                                  .add(widget.orderCardModel);
                            } catch (e) {
                              print(e);
                            }
                          }
                        }
                      }
                    }
                  }
                  return AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        print('reaches animated builder');
                        print(_animation.value);
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              painter: _ProgressPainter(_animation.value),
                              size: Size(270.r, 270.r),
                            ),
                            _buildCenterContent(_animation.value),
                          ],
                        );
                      });
                });
          }
        });
  }

  Widget _buildCenterContent(double progress) {
    String imagePath;
    String text;
    if (progress == 0) {
      imagePath = 'assets/images/cancelled.svg';
      text = 'Order Cancelled';
    } else if (progress > 0 && progress <= 1 / 4) {
      imagePath = 'assets/images/pending.svg';
      text = 'Order Pending';
    } else if (progress > 1 / 4 && progress <= 2 / 4) {
      imagePath = 'assets/images/preparing.svg';
      text = 'Preparing..';
    } else if (progress > 2 / 4 && progress <= 3 / 4) {
      imagePath = 'assets/images/ready.svg';
      text = 'Ready to Pickup!';
    } else {
      imagePath = 'assets/images/delivered.svg';
      text = 'Order Delivered!';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imagePath,
          width: 80.w,
          height: 110.h,
        ),
        SizedBox(height: 20.h),
        Text(text,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: 21.10749053955078.sp,
                letterSpacing: -0.6361207365989685,
                fontWeight: FontWeight.w500,
                height: 1))
      ],
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Paint _paint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 30.0.r;

  _ProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = 270.r / 2;
    const double startAngle = -math.pi / 2;
    final double endAngle = 2 * math.pi * progress + startAngle;

    // Draw the unfilled part
    _paint.shader = null;
    _paint.color = const Color(0xFF1C2038);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      endAngle,
      2 * math.pi - (endAngle - startAngle),
      false,
      _paint,
    );

    // Draw the filled arc
    _paint.shader = const LinearGradient(
      colors: [
        Color(0xFF265CB9),
        Color(0xFF9855D9),
        Color(0xFF2D56BB),
      ],
      stops: [
        0.0,
        0.5,
        1.0,
      ],
    ).createShader(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius / 2));
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      startAngle,
      endAngle - startAngle,
      false,
      _paint,
    );
    if (progress != 1 && progress != 0) {
      _paint.color = Colors.white;
      _paint.style = PaintingStyle.fill;
      _paint.shader = null;

      // Calculate the position of the first dot
      final double dot1X = radius + radius * math.cos(endAngle - 0.04);
      final double dot1Y = radius + radius * math.sin(endAngle - 0.04);

      // Calculate the position of the second dot
      final double dot2X = radius + radius * math.cos(startAngle + 0.04);
      final double dot2Y = radius + radius * math.sin(startAngle + 0.04);
      canvas.drawCircle(
        Offset(dot1X, dot1Y),
        9.82 / 2.r,
        _paint,
      );
      canvas.drawCircle(
        Offset(dot2X, dot2Y),
        9.82 / 2.r,
        _paint,
      );
    }
    // Draw the two ellipses
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
