import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gazlink_app/theme/glass/glass_constants.dart';

class TelegramNavItemData {
  final IconData icon;
  final String label;

  const TelegramNavItemData({
    required this.icon,
    required this.label,
  });
}

class TelegramLiquidNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<TelegramNavItemData> items;
  final double horizontalMargin;
  final double bottomMargin;
  final Color activeColor;
  final Color inactiveColor;

  const TelegramLiquidNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.horizontalMargin = 14,
    this.bottomMargin = 14,
    this.activeColor = const Color.fromARGB(255, 92, 114, 236),
    this.inactiveColor = const Color(0xFF9AA8B4),
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final surfaceStart = brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.42)
        : Colors.white.withValues(alpha: 0.58);
    final surfaceEnd = brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.28)
        : Colors.white.withValues(alpha: 0.34);

    return SafeArea(
      top: false,
      minimum: EdgeInsets.fromLTRB(
        horizontalMargin,
        0,
        horizontalMargin,
        bottomMargin,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GlassConstants.radiusL),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: GlassConstants.strongBlur,
            sigmaY: GlassConstants.strongBlur,
          ),
          child: Container(
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GlassConstants.radiusL),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  surfaceStart,
                  surfaceEnd,
                ],
              ),
              border: Border.all(
                color: GlassConstants.borderColor(brightness),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: GlassConstants.shadowColor(brightness),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: List.generate(
                items.length,
                (index) => _TelegramLiquidNavItem(
                  item: items[index],
                  isActive: currentIndex == index,
                  onTap: () => onTap(index),
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TelegramLiquidNavItem extends StatefulWidget {
  final TelegramNavItemData item;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const _TelegramLiquidNavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  State<_TelegramLiquidNavItem> createState() => _TelegramLiquidNavItemState();
}

class _TelegramLiquidNavItemState extends State<_TelegramLiquidNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: widget.isActive ? 1 : 0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        builder: (context, progress, _) {
          final brightness = Theme.of(context).brightness;
          final iconColor = Color.lerp(
            widget.inactiveColor,
            widget.activeColor,
            progress,
          )!;
          final iconScale = 1 + (0.18 * progress);
          final indicatorWidth = 6 + (14 * progress);
          final bgOpacity = widget.isActive
              ? (brightness == Brightness.dark ? 0.24 : 0.16)
              : (_isHovered ? 0.08 : 0.0);

          return Material(
            type: MaterialType.transparency,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(28),
                splashColor: widget.activeColor.withValues(alpha: 0.20),
                hoverColor: widget.activeColor.withValues(alpha: 0.06),
                highlightColor: widget.activeColor.withValues(alpha: 0.08),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        width: 46,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              widget.activeColor.withValues(alpha: bgOpacity),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Transform.scale(
                          scale: iconScale,
                          child: Icon(
                            widget.item.icon,
                            color: iconColor,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: widget.isActive
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: iconColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        width: widget.isActive ? indicatorWidth : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: widget.activeColor.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
