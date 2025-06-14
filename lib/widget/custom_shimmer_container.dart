import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerContainer extends StatelessWidget {
  final double height;
  final double width;
  const CustomShimmerContainer({
    super.key,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child:  Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            width: double.infinity,
          ),
        )
    );
  }
}
