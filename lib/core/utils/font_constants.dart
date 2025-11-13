import 'package:flutter/material.dart';

class FontConstants {
  // Font families
  static const String poppins = 'Poppins';
  static const String cairo = 'Cairo';

  // Poppins font weights
  static const FontWeight poppinsThin = FontWeight.w100;
  static const FontWeight poppinsExtraLight = FontWeight.w200;
  static const FontWeight poppinsLight = FontWeight.w300;
  static const FontWeight poppinsRegular = FontWeight.w400;
  static const FontWeight poppinsMedium = FontWeight.w500;
  static const FontWeight poppinsSemiBold = FontWeight.w600;
  static const FontWeight poppinsBold = FontWeight.w700;
  static const FontWeight poppinsExtraBold = FontWeight.w800;
  static const FontWeight poppinsBlack = FontWeight.w900;

  // Cairo font weights
  static const FontWeight cairoLight = FontWeight.w300;
  static const FontWeight cairoRegular = FontWeight.w400;
  static const FontWeight cairoMedium = FontWeight.w500;
  static const FontWeight cairoSemiBold = FontWeight.w600;
  static const FontWeight cairoBold = FontWeight.w700;
  static const FontWeight cairoExtraBold = FontWeight.w800;
  static const FontWeight cairoBlack = FontWeight.w900;

  // Common text styles
  static const TextStyle poppinsRegularStyle = TextStyle(
    fontFamily: poppins,
    fontWeight: poppinsRegular,
  );

  static const TextStyle poppinsBoldStyle = TextStyle(
    fontFamily: poppins,
    fontWeight: poppinsBold,
  );

  static const TextStyle poppinsMediumStyle = TextStyle(
    fontFamily: poppins,
    fontWeight: poppinsMedium,
  );

  static const TextStyle cairoRegularStyle = TextStyle(
    fontFamily: cairo,
    fontWeight: cairoRegular,
  );

  static const TextStyle cairoBoldStyle = TextStyle(
    fontFamily: cairo,
    fontWeight: cairoBold,
  );

  static const TextStyle cairoMediumStyle = TextStyle(
    fontFamily: cairo,
    fontWeight: cairoMedium,
  );

  // Helper methods
  static TextStyle poppinsStyle({
    FontWeight? weight,
    double? fontSize,
    Color? color,
    FontStyle? style,
  }) {
    return TextStyle(
      fontFamily: poppins,
      fontWeight: weight ?? poppinsRegular,
      fontSize: fontSize,
      color: color,
      fontStyle: style,
    );
  }

  static TextStyle cairoStyle({
    FontWeight? weight,
    double? fontSize,
    Color? color,
    FontStyle? style,
  }) {
    return TextStyle(
      fontFamily: cairo,
      fontWeight: weight ?? cairoRegular,
      fontSize: fontSize,
      color: color,
      fontStyle: style,
    );
  }
}
