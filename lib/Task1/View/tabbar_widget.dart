import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Task2/View/design_strip_view.dart';
import '../../test_scroll.dart';

class CustomTabView extends StatefulWidget {
  const CustomTabView({
    super.key,
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;

  @override
  CustomTabsState createState() => CustomTabsState();
}

class CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation!.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition!;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && widget.onPositionChange != null) {
              widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation!.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => const ScrollSizingWidget()),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(() => DesignStripView()),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              TabBar(
                isScrollable: true,
                controller: controller,
                tabAlignment: TabAlignment.start,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                indicator: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                ),
                tabs: List.generate(
                  widget.itemCount,
                  (index) => widget.tabBuilder(context, index),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
              (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  void onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);
      }
    }
  }

  void onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller.animation!.value);
    }
  }
}
