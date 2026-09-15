import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/god_image_service.dart';

class GodImage extends StatelessWidget {
  final String godId;
  final String? fallbackPath;
  final BoxFit fit;
  final double iconSize;

  const GodImage({
    super.key,
    required this.godId,
    this.fallbackPath,
    this.fit = BoxFit.cover,
    this.iconSize = 60,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: GodImageService.resolve(godId, fallbackPath: fallbackPath),
      builder: (context, snapshot) {
        final path = snapshot.data ?? fallbackPath;
        if (path == null) return _placeholder();

        return Image.asset(
          path,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        );
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.primaryFixed,
      child: Center(
        child: Icon(
          Icons.temple_hindu_rounded,
          size: iconSize,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
