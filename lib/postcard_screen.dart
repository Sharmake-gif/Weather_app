import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PostcardScreen extends StatefulWidget {
  final String location;
  final String description;
  final double temperature;

  const PostcardScreen({
    Key? key,
    required this.location,
    required this.description,
    required this.temperature,
  }) : super(key: key);

  @override
  State<PostcardScreen> createState() => _PostcardScreenState();
}

class _PostcardScreenState extends State<PostcardScreen> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _sharePostcard() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final imagePath = File('${directory.path}/postcard.png');
      await imagePath.writeAsBytes(pngBytes);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text:
            'Weather in ${widget.location}: ${widget.temperature.toStringAsFixed(1)}°C, ${widget.description}',
      );
    } catch (e) {
      print('Error sharing postcard: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to share postcard')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Postcard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.blue[50],
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.location,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepOrange,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.description.toUpperCase(),
                      style: const TextStyle(fontSize: 18, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _sharePostcard,
              icon: const Icon(Icons.share),
              label: const Text('Share Postcard'),
            ),
          ],
        ),
      ),
    );
  }
}
