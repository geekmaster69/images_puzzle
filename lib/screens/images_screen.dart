import 'package:flutter/material.dart';

import '../widget/widget.dart';
import 'screens.dart';

class ImagesScreen extends StatelessWidget {
  final String category;
  const ImagesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecciona una imagen')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
          //  AppBannerAd(adUnitId: Environments.imageSelectorId),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: List.generate(10, (index) => index + 1).map((e) {
                  final path = 'assets/$category/$e.jpg';

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        useSafeArea: true,
                        isScrollControlled: true,
                        builder: (context) => _ImageOptions(path: path),
                      );
                    },
                    child: Image.asset(path, fit: .cover),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageOptions extends StatefulWidget {
  final String path;
  const _ImageOptions({required this.path});

  @override
  State<_ImageOptions> createState() => _ImageOptionsState();
}

class _ImageOptionsState extends State<_ImageOptions> {
  int _gridSize = 3;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          GameScoreWidget(path: widget.path, griSize: _gridSize,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(widget.path),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _diffChip("Fácil", 3),
              _diffChip("Medio", 4),
              _diffChip("Difícil", 5),
            ],
          ),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GameScreen(image: widget.path, gridSize: _gridSize),
                  ),
                );
              },
              child: Text('JUGAR!'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _diffChip(String label, int size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: _gridSize == size,
        onSelected: (val) => setState(() => _gridSize = size),
      ),
    );
  }
}
