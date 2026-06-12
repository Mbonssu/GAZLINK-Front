import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Widget wrapper that hides/shows bottom navigation bar based on scroll direction
class HideOnScrollBottomNav extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Duration duration;
  final Curve curve;

  const HideOnScrollBottomNav({
    super.key,
    required this.child,
    required this.scrollController,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  State<HideOnScrollBottomNav> createState() => _HideOnScrollBottomNavState();
}

class _HideOnScrollBottomNavState extends State<HideOnScrollBottomNav> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      // Scrolling down - hide bottom nav
      if (_isVisible) {
        setState(() => _isVisible = false);
      }
    } else if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      // Scrolling up - show bottom nav
      if (!_isVisible) {
        setState(() => _isVisible = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: widget.duration,
      curve: widget.curve,
      offset: _isVisible ? Offset.zero : const Offset(0, 1),
      child: widget.child,
    );
  }
}
