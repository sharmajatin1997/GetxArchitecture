import 'package:flutter/material.dart';

class SizeHelper {
  SizeHelper._();

  static late double screenWidth;
  static late double screenHeight;

  static bool isMobile = false;
  static bool isTablet = false;
  static bool isDesktop = false;

  //==== Call once per screen ====
  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;

    screenWidth = size.width;
    screenHeight = size.height;

    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1024;
    isDesktop = screenWidth >= 1024;
  }

  //==== Adaptive spacing (no scaling explosion) ====
  static double space(double value) {
    if (isDesktop) return value * 1.2;
    if (isTablet) return value * 1.1;
    return value; // mobile
  }

  //==== Adaptive text size ====
  static double text(double value) {
    if (isDesktop) return value * 1.15;
    if (isTablet) return value * 1.08;
    return value;
  }

  //==== Adaptive radius ====
  static double radius(double value) {
    if (isDesktop) return value * 1.2;
    if (isTablet) return value * 1.1;
    return value;
  }

  static double p4 = space(4);
  static double p6 = space(6);
  static double p8 = space(8);
  static double p10 = space(10);
  static double p12 = space(12);
  static double p14 = space(14);
  static double p16 = space(16);
  static double p18 = space(18);
  static double p20 = space(20);
  static double p22 = space(22);
  static double p24 = space(24);
  static double p26 = space(26);
  static double p28 = space(28);
  static double p30 = space(30);
  static double p50 = space(50);

  static double r2 = radius(2);
  static double r4 = radius(4);
  static double r6 = radius(6);
  static double r8 = radius(8);
  static double r10 = radius(10);
  static double r12 = radius(12);
  static double r14 = radius(14);
  static double r16 = radius(16);
  static double r18 = radius(18);
  static double r20 = radius(20);
  static double r22 = radius(22);
  static double r24 = radius(24);

  static double icon2 = space(2);
  static double icon4 = space(4);
  static double icon6 = space(6);
  static double icon8 = space(8);
  static double icon10 = space(10);
  static double icon12 = space(12);
  static double icon14 = space(14);
  static double icon16 = space(16);
  static double icon18 = space(18);
  static double icon22 = space(20);
  static double icon24 = space(22);
  static double icon26 = space(24);

  static double text2 = text(2);
  static double text4 = text(4);
  static double text6 = text(6);
  static double text8 = text(8);
  static double text10 = text(10);
  static double text12 = text(12);
  static double text14 = text(14);
  static double text16 = text(16);
  static double text18 = text(18);
  static double text20 = text(20);
  static double text22 = text(22);
  static double text24 = text(24);

  static SizedBox h(double value) => SizedBox(height: space(value));

  static SizedBox w(double value) => SizedBox(width: space(value));
}
