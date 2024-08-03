import 'package:flutter/material.dart';
import 'package:intellicook_mobile/constants/smooth_border_radius.dart';

class ShimmerContent extends StatelessWidget {
  const ShimmerContent({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: SmoothBorderRadiusConsts.s,
          color: Colors.white,
        ),
      ),
    );
  }
}
