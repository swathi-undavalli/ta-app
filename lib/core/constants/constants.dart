import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> dashboardDrawerKey = GlobalKey();

class AppColors {
  static const BackgroundColors background = BackgroundColors();
  static const TextColors text = TextColors();
  static const IconColors iconColor = IconColors();
}

class BackgroundColors {
  const BackgroundColors();
  Color get white => Colors.white;
  Color get black => Colors.black;
  Color get datesBlue => const Color(0xffF4FDFF);
  Color get lightBlue => const Color(0xffF8FAFC);
  Color get lightSkyBlue => const Color(0xffB3E9F0);
  Color get skyBlue => const Color(0xff02D2F9);
  Color get grey => const Color(0xffC4C4C4);
  Color get lightBlack => Colors.black45;
  Color get datesRed => Colors.red.withOpacity(0.5);
  Color get red => Colors.red;
  Color get datesYellow => Colors.yellow.withOpacity(0.5);
  Color get datesGreen => Colors.green.withOpacity(0.5);
}

class TextColors {
  const TextColors();
  Color get lightSkyBlue => const Color(0xffB3E9F0);
  Color get black => Colors.black;
  Color get white => Colors.white;
  Color get grey => const Color(0xffC4C4C4);
  Color get green => Colors.green;
  Color get orange => Colors.orange;
  Color get darkgrey => const Color(0xff6B6868);
  Color get skyBlue => const Color(0xff02D2F9);
  Color get red => Colors.red;
}

class IconColors {
  const IconColors();
  Color get grey => const Color(0x3f909090);
  Color get black => Colors.black;
}

class AppFonts {
  static const String nunito = 'Nunito';
}

class FontSize {
  static const double title = 40;
  static const double message = 20;
  static const double small = 12;
  static const double textSize = 16;
}

class RegularExpressions {
  static RegExp emailRegularExpression = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static RegExp passwordRegularExpression = RegExp(
    r'^(?=.\d)(?=.[A-Z])(?=.[a-z])(?=.[a-zA-Z!#₹$@^%&? ])[a-zA-Z0-9!#₹$@^%&?]{8,}$',
  );
  static RegExp findingDateRegularExpression = RegExp(
    r'^(?:\d{1,2}(?:(?:-|/)|(?:th|st|nd|rd)?\s))?(?:(?:(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)(?:(?:-|/)|(?:,|\.)?\s)?)?(?:\d{1,2}(?:(?:-|/)|(?:th|st|nd|rd)?\s))?)(?:\d{2,4})$',
  );
  static RegExp findingCertificatesRegularExpression = RegExp(
    r'^[A-Z]([a-z]+|\.)(?:\s+[A-Z]([a-z]+|\.))*(?:\s+[a-z][a-z\-]+){0,2}\s+[A-Z]([a-z]+|\.)$',
  );
  static RegExp findingDate1RegularExpression =
      RegExp(r'^(19|20)\d\d([- /.])(0[1-9]|1[012])\2(0[1-9]|[12][0-9]|3[01])$');
  static RegExp findingLongNumbersRegularExpression = RegExp(r'^(\d\d\d\d)$');
}

const String placeHolderImage =
    'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=';

const bannerTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontFamily: 'Nunito', // Replace with AppFonts.nunito if available
  fontSize: 12,
);

final bannerContainerDecoration = BoxDecoration(
  color: Colors.black,
  borderRadius: BorderRadius.circular(8),
);

const bannerButtonStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
