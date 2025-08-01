import 'dart:ui';

import 'package:flutter/material.dart';

class AppGlassmorphismCardWidget extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final EdgeInsets margin;

  const AppGlassmorphismCardWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    // this.width = 300,
    // this.height = 200,
    this.borderRadius = 20,
    this.blur = 10,
    this.opacity = 0.1,
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.all(20),
    this.margin = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor.withOpacity(0.3),
                width: borderWidth,
              ),
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

// ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: BackdropFilter(
//                         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                         child: Container(
//                           width: 300,
//                           height: 200,
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.white.withOpacity(0.2),
//                               width: 1.5,
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.1),
//                                 blurRadius: 10,
//                                 spreadRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: Card(
//                             color: Colors.transparent,
//                             elevation: 0,
//                             child: Padding(
//                               padding: const EdgeInsets.all(20),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Glassmorphism Card',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                       fontWeight: FontWeight.bold,
//                                       shadows: [
//                                         Shadow(
//                                           color: Colors.black.withOpacity(0.3),
//                                           offset: const Offset(2, 2),
//                                           blurRadius: 5,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 10),
//                                   Text(
//                                     'A beautiful frosted glass effect',
//                                     style: TextStyle(
//                                       color: Colors.white.withOpacity(0.8),
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
