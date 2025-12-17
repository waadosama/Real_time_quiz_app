import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String text;
  final String? imagePath;
  final String? imageBase64;
  final IconData? icon;
  final VoidCallback? onTap;
 static const Color mainGreen = Color(0xFF0D4726);
  final Color tileFill;

  const CourseCard({
    super.key,
    required this.text,
    this.imagePath,
    this.imageBase64,
    this.icon,
    this.onTap,

   // this.mainGreen = const Color(0xFF0D4726),
    this.tileFill = const Color(0xFFF2E6D1),
  });

  /// Check if a string is a base64 image
  bool _isBase64Image(String? data) {
    if (data == null || data.isEmpty) return false;

    // Check if it's a data URI format
    if (data.startsWith('data:image')) return true;

    // Check if it's an asset path
    if (data.startsWith('assets/') ||
        data.startsWith('http://') ||
        data.startsWith('https://')) {
      return false;
    }

    // Check for base64 image signatures (common image formats)
    // PNG: iVBORw0KGgo
    // JPEG: /9j/4AAQ
    // GIF: R0lGODlh
    // WebP: UklGR
    final base64Signatures = [
      'iVBORw0KGgo', // PNG
      '/9j/4AAQ', // JPEG
      'R0lGODlh', // GIF
      'UklGR', // WebP
    ];

    // Check if it's a long string (likely base64) and matches image signatures
    if (data.length > 50) {
      for (var signature in base64Signatures) {
        if (data.startsWith(signature)) {
          return true;
        }
      }
      // If it's very long and contains only base64 characters, it's likely base64
      if (data.length > 200 && RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(data)) {
        return true;
      }
    }

    return false;
  }

  /// Decode base64 image string
  Uint8List? _decodeBase64Image(String base64String) {
    try {
      // Handle data URI format: data:image/png;base64,<base64data>
      String base64Data = base64String;
      if (base64String.contains(',')) {
        base64Data = base64String.split(',')[1];
      }
      return base64Decode(base64Data);
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
      return null;
    }
  }

  Widget _buildImage() {
    // Priority: base64 field > imagePath (if base64) > imagePath (if asset) > icon
    String? base64Data = imageBase64;

    // If imageBase64 is not provided, check if imagePath is actually a base64 string
    if (base64Data == null && imagePath != null && _isBase64Image(imagePath)) {
      base64Data = imagePath;
    }

    // Try to display base64 image
    if (base64Data != null) {
      final imageBytes = _decodeBase64Image(base64Data);
      if (imageBytes != null) {
        return Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.broken_image,
              size: 50,
              color: mainGreen,
            ),
          ),
        );
      }
    }

    // If imagePath is provided and not a base64 string, use it as asset path
    if (imagePath != null && !_isBase64Image(imagePath)) {
      return Image.asset(
        imagePath!,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.grey[300],
          child: Icon(
            Icons.broken_image,
            size: 50,
            color: mainGreen,
          ),
        ),
      );
    }

    if (icon != null) {
      return Container(
        color: Colors.grey[300],
        width: double.infinity,
        child: Icon(
          icon,
          size: 48,
          color: mainGreen,
        ),
      );
    }

    // Default icon if nothing is provided
    return Container(
      color: Colors.grey[300],
      width: double.infinity,
      child: Icon(
        Icons.school,
        size: 50,
        color: Colors.grey,
      ),
    );
  }

  @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         color: tileFill,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildImage(),
//             Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: mainGreen,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child:  _buildImage(),
              ),
            ),
            SizedBox(
              height: 56,
              child: Center(
                child: Text(
                 text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: mainGreen,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
