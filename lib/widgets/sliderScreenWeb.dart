import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalSplitViewWeb extends StatefulWidget {
  final Widget left;
  final Widget right;
  // final double ratio;

  const VerticalSplitViewWeb(
      {Key? key, required this.left, required this.right})
      : assert(left != null),
        assert(right != null),
        super(key: key);

  @override
  _VerticalSplitViewState createState() => _VerticalSplitViewState();
}

class _VerticalSplitViewState extends State<VerticalSplitViewWeb> {
  final _dividerWidth = 3.7.w;

  //from 0-1
  double _ratio = 0.25;
  double _maxWidth = 662.w;
  //385

  // get _width1 => _ratio * _maxWidth;

  // get _width2 => (1 - _ratio) * _maxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      double _width1 = _ratio * _maxWidth;
      assert(_ratio <= 1);
      assert(_ratio >= 0);

      return SizedBox(
        // height: constraints.maxHeight,
        // width: constraints.maxWidth,
        height: 710.h,
        width: 712.w,
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                // height: constraints.maxHeight,
                width: _width1 + 19,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: Colors.white,
                  width: _dividerWidth,
                  height: 710,
                ),
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    print("hello ${_ratio}");
                    _ratio += details.delta.dx / _maxWidth;
                    // if (_width1 > 285) _width1 = 285;
                    if (_ratio > 1)
                      _ratio = 1;
                    else if (_ratio < 0.0) _ratio = 0.0;
                  });
                },
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  primary: true,
                  dragStartBehavior: DragStartBehavior.down,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  child: Container(child: widget.right, width: 712.w),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(width: _width1),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: FloatingActionButton(
                  mini: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: () {},
                  child: Image.asset(
                    "assets/icons/dragButton.png",
                  ),
                ),
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    _ratio += details.delta.dx / _maxWidth;
                    if (_ratio > 1)
                      _ratio = 1;
                    else if (_ratio < 0.0) _ratio = 0.0;
                  });
                },
              ),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  primary: true,
                  dragStartBehavior: DragStartBehavior.down,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(width: 712.w),
                ),
              ),
            ],
          )
        ]),
      );
    });
  }
}
