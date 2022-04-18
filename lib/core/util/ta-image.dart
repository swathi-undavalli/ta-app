import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octo_image/octo_image.dart';

class TAImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final String semanticsLabel;
  final Color color;
  final BoxFit fit;
  final double borderRadius;
  const TAImage(
      this.image, {
        Key key,
        this.height,
        this.width,
        this.borderRadius,
        this.semanticsLabel,
        this.color,
        this.fit = BoxFit.contain,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: _getImage(),
    );
  }

  _getImage() {
    if (image.startsWith("http") && image.endsWith(".svg")) {
      return SvgPicture.network(
        image,
        height: height,
        width: width,
        color: color,
        fit: fit,
        semanticsLabel: semanticsLabel,
      );
    } else if (image.endsWith(".svg")) {
      return SvgPicture.asset(
        image,
        height: height,
        width: width,
        color: color,
        fit: fit,
        semanticsLabel: semanticsLabel,
      );
    } else if (image.startsWith("http")) {
      return OctoImage(
        image: CachedNetworkImageProvider(image),
        errorBuilder:
        OctoError.icon(color: Colors.red, icon: Icons.image_not_supported),
        color: color,
        fit: fit,
        height: height,
        width: width,
      );
    } else if (image.startsWith('images')) {
      return Image.asset(
        image,
        height: height,
        width: width,
        color: color,
        fit: fit,
      );
    } else {
      return SizedBox(
        width: width ?? 0,
        height: height ?? 0,
      );
    }
  }
}
