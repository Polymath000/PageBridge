import 'package:flutter/material.dart';
import 'package:quicknotion/core/utls/app_images.dart';

class BackgroundAuth extends StatelessWidget {
  const BackgroundAuth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Image(
        image: AssetImage(Assets.assetsImagesAuthBack),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
