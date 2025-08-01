import 'dart:ui';

import 'package:flutter/material.dart';

class AppGlassmorphismExpansionTileWidget extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget> children;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final IconData? expandIcon;
  final Color? expandIconColor;

  const AppGlassmorphismExpansionTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.children = const [],
    this.borderRadius = 16,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.expandIcon = Icons.keyboard_arrow_down,
    this.expandIconColor,
  });

  @override
  State<AppGlassmorphismExpansionTileWidget> createState() => _AppGlassmorphismExpansionTileWidgetState();
}

class _AppGlassmorphismExpansionTileWidgetState extends State<AppGlassmorphismExpansionTileWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(widget.opacity),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.borderColor.withOpacity(0.3),
                width: widget.borderWidth,
              ),
            ),
            child: Column(
              children: [
                // Header
                InkWell(
                  onTap: _toggle,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Padding(
                    padding: widget.padding,
                    child: Row(
                      children: [
                        if (widget.leading != null) ...[
                          widget.leading!,
                          SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.title,
                              if (widget.subtitle != null) ...[
                                SizedBox(height: 4),
                                widget.subtitle!,
                              ],
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: widget.animationDuration,
                          child: Icon(
                            widget.expandIcon,
                            color: widget.expandIconColor ?? Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expandable content
                SizeTransition(
                  sizeFactor: _animation,
                  child: widget.children.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: widget.borderColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.children,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
