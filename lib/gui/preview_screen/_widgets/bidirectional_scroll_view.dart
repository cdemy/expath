import 'package:flutter/material.dart';

/// A widget that provides bidirectional scrolling with visible scrollbars
class BidirectionalScrollView extends StatefulWidget {
  final Widget child;

  const BidirectionalScrollView({
    super.key,
    required this.child,
  });

  @override
  State<BidirectionalScrollView> createState() => _BidirectionalScrollViewState();
}

class _BidirectionalScrollViewState extends State<BidirectionalScrollView> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _horizontalController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalController,
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          controller: _verticalController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _verticalController,
            scrollDirection: Axis.vertical,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }
}