import 'package:flutter/material.dart';

/// Shows an image in fullscreen with zoom capability
void showFullScreenImage(BuildContext context, String imagePath, String title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image with black background
            Container(
              color: Colors.black,
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon:
                    const Icon(Icons.close, color: Colors.cyanAccent, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Title
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.black.withOpacity(0.5),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
