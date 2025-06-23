import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_network/image_network.dart';

class CircleImageWidget extends ConsumerWidget {
  /// The URL of the image to display
  final String imageUrl;

  /// The diameter of the circular image container
  final double size;

  /// Width of the gradient border
  final double borderWidth;

  /// Colors for the gradient border effect
  final List<Color>? gradientColors;

  /// Shadow configuration for depth effect
  final List<BoxShadow>? shadows;

  /// Placeholder widget shown during loading
  final Widget? placeholder;

  /// Widget shown when image fails to load
  final Widget? errorWidget;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Cache duration for network images (mobile only)
  final Duration? cacheMaxAge;

  /// Animation duration for state transitions
  final Duration animationDuration;

  /// Custom hero tag for hero animations
  final String? heroTag;

  const CircleImageWidget({
    super.key,
    required this.imageUrl,
    this.size = 70.0,
    this.borderWidth = 3.0,
    this.gradientColors,
    this.shadows,
    this.placeholder,
    this.errorWidget,
    this.semanticLabel,
    this.cacheMaxAge,
    this.animationDuration = const Duration(milliseconds: 300),
    this.heroTag,
  })  : assert(size > 0, 'Size must be positive'),
        assert(borderWidth >= 0, 'Border width must be non-negative');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate inner size accounting for border and padding
    final innerSize = size - (borderWidth * 2) - 4; // 4px total padding

    // Default gradient colors based on theme
    final effectiveGradientColors = gradientColors ??
        [
          colorScheme.primary,
          colorScheme.primary.withOpacity(0.7),
          colorScheme.secondary.withOpacity(0.5),
        ];

    // Default shadow configuration
    final effectiveShadows = shadows ??
        [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
        ];

    Widget imageWidget = _buildImageWidget(context, innerSize);

    // Wrap in hero if heroTag is provided
    if (heroTag != null) {
      imageWidget = Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    return Semantics(
      label: semanticLabel ?? 'Profile image',
      image: true,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: effectiveGradientColors,
          ),
          boxShadow: effectiveShadows,
        ),
        child: Padding(
          padding: EdgeInsets.all(borderWidth),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor,
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: ClipOval(
                child: imageWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the appropriate image widget based on platform and configuration
  Widget _buildImageWidget(BuildContext context, double imageSize) {
    if (kIsWeb) {
      return _buildWebImage(context, imageSize);
    } else {
      return _buildMobileImage(context, imageSize);
    }
  }

  /// Builds image widget optimized for web platform using ImageNetwork
  Widget _buildWebImage(BuildContext context, double imageSize) {
    return ImageNetwork(
      image: imageUrl,
      width: imageSize,
      height: imageSize,
      fitWeb: BoxFitWeb.cover,
      onLoading: _buildPlaceholder(context, imageSize),
      onError: _buildErrorWidget(context, imageSize),
      duration: animationDuration.inMilliseconds,
      curve: Curves.easeInOut,
      debugPrint: kDebugMode,
      fitAndroidIos: BoxFit.cover,
    );
  }

  /// Builds image widget optimized for mobile platforms with caching
  Widget _buildMobileImage(BuildContext context, double imageSize) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: imageSize,
      height: imageSize,
      fit: BoxFit.cover,
      maxHeightDiskCache:
          (imageSize * MediaQuery.of(context).devicePixelRatio).round(),
      maxWidthDiskCache:
          (imageSize * MediaQuery.of(context).devicePixelRatio).round(),
      fadeInDuration: animationDuration,
      fadeOutDuration: animationDuration,
      placeholder: (context, url) => _buildPlaceholder(context, imageSize),
      errorWidget: (context, url, error) {
        debugPrint('Cached image load error: $error');
        return _buildErrorWidget(context, imageSize);
      },
    );
  }

  /// Builds the loading placeholder widget
  Widget _buildPlaceholder(BuildContext context, double imageSize) {
    if (placeholder != null) return placeholder!;

    final theme = Theme.of(context);
    return Container(
      width: imageSize,
      height: imageSize,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      child: Center(
        child: SizedBox(
          width: imageSize * 0.3,
          height: imageSize * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the error state widget
  Widget _buildErrorWidget(BuildContext context, double imageSize) {
    if (errorWidget != null) return errorWidget!;

    final theme = Theme.of(context);
    return Container(
      width: imageSize,
      height: imageSize,
      color: theme.colorScheme.errorContainer.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.person_outline_rounded,
          size: imageSize * 0.4,
          color: theme.colorScheme.onErrorContainer.withOpacity(0.6),
        ),
      ),
    );
  }
}

/// Extension for additional utility methods
extension ProfessionalCircleImageWidgetExtensions on CircleImageWidget {
  /// Creates a small variant (40px) suitable for list items
  static CircleImageWidget small({
    Key? key,
    required String imageUrl,
    String? semanticLabel,
    String? heroTag,
  }) {
    return CircleImageWidget(
      key: key,
      imageUrl: imageUrl,
      size: 40.0,
      borderWidth: 2.0,
      semanticLabel: semanticLabel,
      heroTag: heroTag,
    );
  }

  /// Creates a medium variant (70px) suitable for cards and profiles
  static CircleImageWidget medium({
    Key? key,
    required String imageUrl,
    String? semanticLabel,
    String? heroTag,
  }) {
    return CircleImageWidget(
      key: key,
      imageUrl: imageUrl,
      size: 70.0,
      borderWidth: 3.0,
      semanticLabel: semanticLabel,
      heroTag: heroTag,
    );
  }

  /// Creates a large variant (120px) suitable for profile pages
  static CircleImageWidget large({
    Key? key,
    required String imageUrl,
    String? semanticLabel,
    String? heroTag,
  }) {
    return CircleImageWidget(
      key: key,
      imageUrl: imageUrl,
      size: 120.0,
      borderWidth: 4.0,
      semanticLabel: semanticLabel,
      heroTag: heroTag,
    );
  }
}
