import 'package:get/get.dart';

extension ProportionScreenSizesDouble on double {
  // Get the proportionate height as per screen size
  double get height {
    // 812 is the layout height that designer use
    return (this / 812.0) * Get.height;
  }

  double get font {
    return this * 1.0;
  }

  // Get the proportionate height as per screen size
  double get width {
    // 375 is the layout width that designer use
    return (this / 375.0) * Get.width;
  }
}

extension ProportionScreenSizesInt on int {
  // Get the proportionate height as per screen size
  double get height {
    // 812 is the layout height that designer use
    return (this / 812.0) * Get.height;
  }

  // Get the proportionate height as per screen size
  double get width {
    // 375 is the layout width that designer use
    return (this / 375.0) * Get.width;
  }

  double get font {
    return this * 1.0;
  }
}
