import 'package:flutter/material.dart';
import 'package:image_puzzle/config/constants/environments.dart';
import 'package:image_puzzle/screens/images_screen.dart';
import 'package:image_puzzle/widget/app_banner.dart';

class PuzzleMenu extends StatefulWidget {
  const PuzzleMenu({super.key});

  @override
  State<PuzzleMenu> createState() => _PuzzleMenuState();
}

class _PuzzleMenuState extends State<PuzzleMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle Images'), centerTitle: true),
      body: Column(
        children: [
          AppBannerAd(adUnitId: Environments.bannerId,),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.all(6),
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              children: [
                ImagesMenuItem(title: 'Colores', category: 'colors'),
                ImagesMenuItem(title: 'Aves', category: 'birds'),
                ImagesMenuItem(title: 'Oceano', category: 'ocean'),
                ImagesMenuItem(title: 'Animales', category: 'animals'),
                ImagesMenuItem(title: 'Globos', category: 'balloons'),
                ImagesMenuItem(title: 'Dibujos', category: 'drawer'),
                ImagesMenuItem(title: 'Granja', category: 'farm'),
                ImagesMenuItem(title: 'Flores', category: 'flower'),
                ImagesMenuItem(title: 'Estaciones', category: 'seasons'),
                ImagesMenuItem(title: 'Estatuas', category: 'statue'),
                ImagesMenuItem(title: 'Urbano', category: 'urban'),
                ImagesMenuItem(title: 'Mascotas', category: 'pets'),
                ImagesMenuItem(title: 'Paisajes', category: 'landscapes'),
                ImagesMenuItem(title: 'Coches', category: 'cars'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagesMenuItem extends StatelessWidget {
  final String title;

  final String category;
  const ImagesMenuItem({
    super.key,
    required this.title,

    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagesScreen(category: category),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(12),
            child: Image.asset(
              'assets/$category/1.jpg',
              fit: .cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          Positioned.fill(
            child: Align(
              alignment: .bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12),
                  ),
                ),
                child: Text(title, textAlign: .center),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
