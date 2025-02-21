import 'package:flutter/material.dart';
import 'package:green_genie/config/theme.dart';

Container emissionCardSkeleton({
  required double height,
  required double width,
}) =>
    Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: white, borderRadius: BorderRadius.all(Radius.circular(16.0))),
      height: height * 0.32,
      width: width,
      child: CircularProgressIndicator(),
    );
