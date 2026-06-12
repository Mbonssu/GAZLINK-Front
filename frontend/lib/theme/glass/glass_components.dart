import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'glass_background.dart';
import 'glass_constants.dart';

class GlassScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;
  final SystemUiOverlayStyle? statusBarStyle;
  final bool wrapBodyInSafeArea;
  final bool applyBodyGlass;
  final EdgeInsetsGeometry bodyPadding;
  final List<Color>? gradient;

  const GlassScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBody = true,
    this.resizeToAvoidBottomInset = true,
    this.statusBarStyle,
    this.wrapBodyInSafeArea = false,
    this.applyBodyGlass = false,
    this.bodyPadding = GlassConstants.pagePadding,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final overlay = statusBarStyle ??
        (brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark);

    Widget content = body;

    if (wrapBodyInSafeArea) {
      content = SafeArea(child: content);
    }

    if (applyBodyGlass) {
      content = Padding(
        padding: bodyPadding,
        child: GlassCard(
          radius: GlassConstants.radiusL,
          padding: EdgeInsets.zero,
          child: content,
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: extendBody,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        body: GlassBackground(
          gradient: gradient,
          child: content,
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double height;
  final double blur;
  final Color? backgroundColor;  // ← AJOUTEZ CETTE LIGNE
  final Color? foregroundColor; 

  const GlassAppBar({
    super.key,
    required this.title,
    this.backgroundColor,        // ← AJOUTEZ CETTE LIGNE
    this.foregroundColor, 
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.height = kToolbarHeight,
    // this.blur = GlassConstants.blur, required Color backgroundColor, required int elevation, required Color foregroundColor,
    this.blur = GlassConstants.blur,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // 5.1: Implémenter la détection du brightness dans GlassAppBar
    final brightness = Theme.of(context).brightness;
    final shouldBlur = GlassConstants.shouldApplyBlur(brightness);
    final titleColor = GlassConstants.titleColor(brightness);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      title: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                ) ??
            TextStyle(
              color: titleColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
        child: title,
      ),
      // 5.2: Implémenter le rendu conditionnel du BackdropFilter
      flexibleSpace: ClipRect(
        child: shouldBlur
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                child: _buildAppBarContainer(brightness),
              )
            : _buildAppBarContainer(brightness),
      ),
    );
  }

  // Méthode helper pour le container de l'AppBar
  Widget _buildAppBarContainer(Brightness brightness) {
     // Si une couleur de fond personnalisée est fournie, l'utiliser
  final bgColor = backgroundColor ?? GlassConstants.adaptiveStrongSurfaceColor(brightness);
  final fgColor = foregroundColor ?? GlassConstants.titleColor(brightness);
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(color: GlassConstants.borderColor(brightness)),
        ),
      ),
    );
  }
}

class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;
  final double blur;
  final VoidCallback? onTap;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin = EdgeInsets.zero,
    this.radius = GlassConstants.radiusM,
    this.blur = GlassConstants.blur,
    this.onTap,
    this.color,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // 2.1: Implémenter la détection du brightness dans GlassCard
    final brightness = Theme.of(context).brightness;
    final shouldBlur = GlassConstants.shouldApplyBlur(brightness);
    
    // Utiliser la couleur adaptative (opaque en clair, transparente en sombre)
    final baseColor = widget.color ?? GlassConstants.adaptiveSurfaceColor(brightness);
    final hoverOpacityBoost = _hovered ? 0.06 : 0.0;
    final color = baseColor.withValues(
      alpha: (baseColor.a + hoverOpacityBoost).clamp(0.0, 1.0),
    );

    return Container(
      margin: widget.margin,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          duration: GlassConstants.motionFast,
          scale: _hovered ? 1.01 : 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            // 2.2: Implémenter le rendu conditionnel du BackdropFilter
            child: shouldBlur
                ? BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
                    child: _buildContainer(brightness, color),
                  )
                : _buildContainer(brightness, color),
          ),
        ),
      ),
    );
  }

  // Méthode helper pour éviter la duplication de code
  Widget _buildContainer(Brightness brightness, Color color) {
    return AnimatedContainer(
      duration: GlassConstants.motionFast,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(
          color: GlassConstants.borderColor(brightness),
        ),
        boxShadow: [
          BoxShadow(
            color: GlassConstants.shadowColor(brightness),
            blurRadius: 20,
            spreadRadius: -2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          splashColor: Colors.white.withValues(alpha: 0.16),
          highlightColor: Colors.black.withValues(alpha: 0.10),
          hoverColor: Colors.white.withValues(alpha: 0.05),
          child: Padding(
            padding: widget.padding,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class GlassListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;

  const GlassListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.margin = const EdgeInsets.only(bottom: 8),
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: margin,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
      ),
    );
  }
}

class GlassButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.radius = GlassConstants.radiusS,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // 4.1: Implémenter la détection du brightness dans GlassButton
    final brightness = Theme.of(context).brightness;
    final shouldBlur = GlassConstants.shouldApplyBlur(brightness);
    final enabled = widget.onPressed != null;
    
    // Pour les boutons actifs en mode clair, utiliser une couleur accent avec alpha=0.85 pour une meilleure visibilité
    // Pour les boutons désactivés, utiliser GlassConstants.adaptiveSurfaceColor(brightness)
    final base = enabled
        ? GlassConstants.accent.withValues(alpha: brightness == Brightness.dark ? 0.30 : 0.85)
        : GlassConstants.adaptiveSurfaceColor(brightness);

    final color = base.withValues(
      alpha: (base.a + (_hovered && enabled ? 0.08 : 0.0)).clamp(0.0, 1.0),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: GlassConstants.motionFast,
        scale: _hovered && enabled ? 1.015 : 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          // 4.2: Implémenter le rendu conditionnel du BackdropFilter
          child: shouldBlur
              ? BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: GlassConstants.blur,
                    sigmaY: GlassConstants.blur,
                  ),
                  child: _buildContainer(brightness, color),
                )
              : _buildContainer(brightness, color),
        ),
      ),
    );
  }

  // Créer une méthode helper _buildContainer(Brightness brightness, Color color) pour éviter la duplication
  Widget _buildContainer(Brightness brightness, Color color) {
    return AnimatedContainer(
      duration: GlassConstants.motionFast,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(widget.radius),
        border: Border.all(
          color: GlassConstants.borderColor(brightness),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          splashColor: Colors.white.withValues(alpha: 0.18),
          highlightColor: Colors.black.withValues(alpha: 0.12),
          child: Padding(
            padding: widget.padding,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: GlassConstants.titleColor(brightness),
                    fontWeight: FontWeight.w700,
                  ),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassDialog extends StatelessWidget {
  final Widget child;

  const GlassDialog({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      child: GlassCard(
        radius: GlassConstants.radiusL,
        child: child,
      ),
    );
  }
}
