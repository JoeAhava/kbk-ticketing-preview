import 'package:flutter/material.dart';

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;
  final double width;

  const MySeparator({this.height = 1,this.width = 10.0, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = width;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          direction: Axis.horizontal,
        );
      },
    );
  }
}