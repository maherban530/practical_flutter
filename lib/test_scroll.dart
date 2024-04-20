import 'package:flutter/material.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

class ScrollSizingWidget extends StatefulWidget {
  const ScrollSizingWidget({Key? key}) : super(key: key);

  @override
  State<ScrollSizingWidget> createState() => _ScrollSizingWidgetState();
}

class _ScrollSizingWidgetState extends State<ScrollSizingWidget> {
  late final ScrollController _horizontal;
  late final ScrollController _vertical;

  @override
  void initState() {
    super.initState();
    _horizontal = ScrollController();
    _vertical = ScrollController();
  }

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scrollbar(
        controller: _horizontal,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        child: SingleChildScrollView(
          controller: _horizontal,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          child: SizedBox(
            height: 500,
            width: 1000,
            child: Scrollbar(
              controller: _vertical,
              scrollbarOrientation: ScrollbarOrientation.right,
              child: SingleChildScrollView(
                controller: _vertical,
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 1000,
                      color: Colors.red,
                    ),
                    Container(
                      height: 1000,
                      width: 1000,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
