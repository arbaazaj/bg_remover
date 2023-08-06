import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remove_background/remove_background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BG Remover',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BG Remover'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoaded = false;
  ui.Image? image;
  late ByteData pngBytes;

  @override
  void initState() {
    super.initState();
    getUiImage();
  }

  // Get the image from the images directory
  getUiImage() async {
    ByteData data = await rootBundle.load('images/test_image.jpg');
    image = await decodeImageFromList(data.buffer.asUint8List());
    await getPNG();
    setState(() {
      isLoaded = true;
    });
  }

  getPNG() async {
    pngBytes = (await image?.toByteData(format: ui.ImageByteFormat.png))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isLoaded
                ? Image.memory(Uint8List.view(pngBytes.buffer))
                : const Icon(Icons.image),
            const Text('Example remove background image'),
            isLoaded
                ? TextButton(
                    onPressed: () async {
                      pngBytes = await cutImage(context: context, image: image!);
                      setState(() {});
                    },
                    child: const Text('Cutout Image'),
                  )
                : const SizedBox()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.photo),
        onPressed: () {},
      ),
    );
  }
}
