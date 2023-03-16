import 'package:flutter/material.dart';

class CustomCardClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path path = Path();
    double widthReference = 0;
    double widthIncrement = 35;

    while(widthReference <= size.width){
      path.quadraticBezierTo(widthReference + (widthIncrement/2) , 20, widthReference + widthIncrement, 0);
      widthReference += widthIncrement;
    }

    path.lineTo(size.width, (size.height/2) + 55);
    path.quadraticBezierTo(size.width-30, size.height/2 + 70 , size.width, size.height/ 2 + 85);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.lineTo(0, size.height/2 + 85);
    path.quadraticBezierTo(30, size.height/2 + 70, 0, size.height/2 + 55);
    path.lineTo(0, 0);

    return path;

  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}

