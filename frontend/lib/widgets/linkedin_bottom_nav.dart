import 'package:flutter/material.dart';

class LinkedInBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavItem> items;

  LinkedInBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  State<LinkedInBottomNav> createState() => _LinkedInBottomNavState();
}

class _LinkedInBottomNavState extends State<LinkedInBottomNav>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.items.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _animations = _animationControllers.map((controller) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Animer l'onglet actif au démarrage
    _animationControllers[widget.currentIndex].forward();
  }

  @override
  void didUpdateWidget(LinkedInBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _animationControllers[oldWidget.currentIndex].reverse();
      _animationControllers[widget.currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Color(0xFF1D4ED8);
    final inactiveColor = isDark ? Colors.grey[600] : Colors.grey[400];
    final backgroundColor = isDark ? Color(0xFF1A1A1A) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            widget.items.length,
            (index) => _buildNavItem(
              context,
              index,
              widget.items[index],
              primaryColor,
              inactiveColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    BottomNavItem item,
    Color activeColor,
    Color? inactiveColor,
  ) {
    final isActive = widget.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          widget.onTap(index);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget.onTap(index);
            },
            splashColor: activeColor.withValues(alpha: 0.2),
            highlightColor: activeColor.withValues(alpha: 0.1),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicateur de sélection animé
                  if (isActive)
                    ScaleTransition(
                      scale: _animations[index],
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: activeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  else
                    SizedBox(height: 4),
                  SizedBox(height: 8),
                  // Icône avec animation de couleur
                  AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      final color = Color.lerp(
                        inactiveColor,
                        activeColor,
                        _animations[index].value,
                      );
                      return Icon(
                        item.icon,
                        color: color,
                        size: 24,
                      );
                    },
                  ),
                  SizedBox(height: 4),
                  // Label avec animation de couleur et taille
                  AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      final color = Color.lerp(
                        inactiveColor,
                        activeColor,
                        _animations[index].value,
                      );
                      final scale = 0.8 + (_animations[index].value * 0.2);
                      return Transform.scale(
                        scale: scale,
                        child: Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
                            color: color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final IconData icon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.label,
  });
}
