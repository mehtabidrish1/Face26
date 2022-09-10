import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalSplitView extends StatefulWidget {
  final Widget left;
  final Widget right;
  // final double ratio;

  const VerticalSplitView({Key? key, required this.left, required this.right})
      : assert(left != null),
        assert(right != null),
        super(key: key);

  @override
  _VerticalSplitViewState createState() => _VerticalSplitViewState();
}

class _VerticalSplitViewState extends State<VerticalSplitView> {
  final _dividerWidth = 3.7.w;

  //from 0-1
  double _ratio = 0.25;
  double _maxWidth = 335; //385

  get _width1 => _ratio * _maxWidth;

  // get _width2 => (1 - _ratio) * _maxWidth;

  @override
  void initState() {
    super.initState();
    // _ratio = widget.ratio;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      assert(_ratio <= 1);
      assert(_ratio >= 0);

      return SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                // height: constraints.maxHeight,
                width: _width1 + 26,
                child: widget.left,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: Colors.white,
                  width: _dividerWidth,
                  height: constraints.maxHeight,
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
                  primary: true,
                  dragStartBehavior: DragStartBehavior.down,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  physics: NeverScrollableScrollPhysics(),
                  child: SizedBox(
                      child: widget.right,
                      width: MediaQuery.of(context).size.width),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                width: _width1,
                child: Container(),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: FloatingActionButton(
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
                  child: SizedBox(
                      child: Container(),
                      width: MediaQuery.of(context).size.width),
                ),
              ),
            ],
          )
        ]),
      );
    });
  }
}
