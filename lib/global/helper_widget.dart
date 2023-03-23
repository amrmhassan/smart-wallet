// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HelperWidget extends StatefulWidget {
  final Color backgroundColor;
  final GlobalKey widgetKey;
  final EdgeInsets padding;
  final Widget? topOverlayChild;
  final bool show;

  const HelperWidget({
    Key? key,
    required this.backgroundColor,
    required this.widgetKey,
    this.padding = EdgeInsets.zero,
    this.topOverlayChild,
    required this.show,
  }) : super(key: key);

  @override
  State<HelperWidget> createState() => _HelperWidgetState();
}

class _HelperWidgetState extends State<HelperWidget> {
  Offset gOffset = Offset.zero;
  Size gSize = Size.zero;

  void trackPositionAndSize(bool updateSize) {
    Offset o = getWidgetOffset();
    if (updateSize) {
      Size s = getWidgetSize();
      setState(() {
        gOffset = o;
        gSize = s;
      });
    } else {
      setState(() {
        gOffset = o;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      trackPositionAndSize(true);
    });

    super.initState();
  }

  Offset getWidgetOffset() {
    try {
      final RenderObject renderBox =
          widget.widgetKey.currentContext!.findRenderObject() as RenderObject;
      var translation = renderBox.getTransformTo(null).getTranslation();
      Offset offset = Offset(translation.x, translation.y);
      return offset;
    } catch (e) {
      return Offset.zero;
    }
  }

  @override
  void didUpdateWidget(covariant HelperWidget oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      trackPositionAndSize(true);
    });

    super.didUpdateWidget(oldWidget);
  }

  Size getWidgetSize() {
    try {
      final Size size = widget.widgetKey.currentContext!.size as Size;

      return size;
    } catch (E) {
      return Size.zero;
    }
  }

  double getTopperHeight() {
    if (gOffset == Offset.zero) {
      return 0;
    }
    double x = (gOffset.dy - widget.padding.top);
    if (x < 0) {
      return 0;
    }
    return x;
  }

  double getRowHeight() {
    return gSize.height + widget.padding.top + widget.padding.bottom;
  }

  double getLeftRowWidth() {
    if (gOffset == Offset.zero) {
      return 0;
    }
    double x = gOffset.dx - widget.padding.left;
    if (x < 0) {
      return 0;
    }
    return x;
  }

  double getMarginWidth() {
    return gSize.width + widget.padding.right + widget.padding.left;
  }

  @override
  Widget build(BuildContext context) {
    return widget.show
        ? Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: getTopperHeight(),
                    width: double.infinity,
                    color: widget.backgroundColor,
                    child: widget.topOverlayChild,
                    // color: Colors.yellow,
                  ),
                  Row(
                    children: [
                      Container(
                        height: getRowHeight(),
                        width: getLeftRowWidth(),
                        color: widget.backgroundColor,
                        // color: Colors.red,
                      ),
                      Container(
                        //? i used this margin trick to allow the underlying widget to receive events
                        margin: EdgeInsets.only(right: getMarginWidth()),
                        width: 0,
                        height: getRowHeight(),
                        color: Colors.transparent,
                      ),
                      Expanded(
                        child: Container(
                          height: getRowHeight(),
                          color: widget.backgroundColor,
                          // color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: widget.backgroundColor,
                      // color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          )
        : SizedBox();
  }
}
