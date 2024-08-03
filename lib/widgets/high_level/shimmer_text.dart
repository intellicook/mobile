import 'package:flutter/material.dart';
import 'package:intellicook_mobile/utils/extensions/text_span_extensions.dart';
import 'package:intellicook_mobile/widgets/high_level/shimmer_content.dart';

class ShimmerText extends StatelessWidget {
  const ShimmerText(
    this.text, {
    super.key,
    this.style,
    this.width,
    this.height,
  });

  final String text;
  final TextStyle? style;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final size = TextSpan(text: text, style: style).size(context);
    final width = this.width ?? size.width;
    final height = this.height ?? size.height;

    return ShimmerContent(
      width: width,
      height: height,
    );
  }
}
