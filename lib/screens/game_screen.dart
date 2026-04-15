import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_puzzle/screens/home.dart';

import '../config/config.dart';
import '../widget/widget.dart';

class GameScreen extends StatefulWidget {
  final String image;
  final int gridSize;

  const GameScreen({super.key, required this.image, required this.gridSize});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  RewardedAd? _rewardedAd;
  bool _isAdLoaded = false;
  late List<int> _board;
  int? _firstIndex;
  int _hintsLeft = 3;
  bool _isSolved = false;
  double? _aspectRatio;
  late Stopwatch _stopwatch;
  late Timer _timer;
  int _moveCount = 0;
  String _timeDisplay = "00:00";

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    // Actualizamos el string del tiempo cada segundo
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _stopwatch.isRunning) {
        setState(() {
          final minutes = _stopwatch.elapsed.inMinutes
              .remainder(60)
              .toString()
              .padLeft(2, '0');
          final seconds = _stopwatch.elapsed.inSeconds
              .remainder(60)
              .toString()
              .padLeft(2, '0');
          _timeDisplay = "$minutes:$seconds";
        });
      }
    });
    _initGame();
    _loadImageInfo();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: Environments.rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (error) {
          debugPrint('Error al cargar anuncio: $error');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El anuncio no está listo aún...")),
      );
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd(); // Cargamos el siguiente para la próxima vez
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        // ¡AQUÍ ENTREGAMOS LA RECOMPENSA!
        setState(() {
          _hintsLeft++; // Añadimos una pista extra
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Ganaste 1 pista extra!")),
        );
      },
    );
    _rewardedAd = null;
    _isAdLoaded = false;
  }

  // Modificamos el método de usar pista para que abra el anuncio si no quedan
  void _handleHintButton() {
    if (_hintsLeft > 0) {
      _useHint(); // Tu función actual que gasta la pista
    } else {
      _showRewardedAd(); // Si no hay pistas, mostramos el anuncio
    }
  }

  void _loadImageInfo() {
    final Image image = Image.asset(widget.image);
    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            if (mounted) {
              setState(() {
                _aspectRatio = info.image.width / info.image.height;
              });
            }
          }),
        );
  }

  void _initGame() {
    int total = widget.gridSize * widget.gridSize;
    _board = List.generate(total, (i) => i);
    _board.shuffle();
    _firstIndex = null;
    _isSolved = false;
  }

  void _onTap(int index) {
    if (_isSolved) return;

    if (_firstIndex == null) {
      setState(() => _firstIndex = index);
    } else {
      if (_firstIndex != index) {
        setState(() {
          int temp = _board[_firstIndex!];
          _board[_firstIndex!] = _board[index];
          _board[index] = temp;
          _firstIndex = null;
          _moveCount++;
          _checkWin();
        });
      } else {
        setState(() => _firstIndex = null);
      }
    }
  }

  void _checkWin() {
    for (int i = 0; i < _board.length; i++) {
      if (_board[i] != i) return;
    }

    _stopwatch.stop(); // Detener el tiempo inmediatamente
    setState(() => _isSolved = true);

    // Mostrar el diálogo después de un pequeño delay para que vean el puzzle armado
    Future.delayed(const Duration(milliseconds: 500), () {
      showVictoryDialog(
        context,
        gridSize: widget.gridSize,
        moveCount: _moveCount,
        seconds: _stopwatch.elapsed.inSeconds,
        timeDisplay: _timeDisplay,
        path: widget.image,hintsLeft: _hintsLeft
      
      );
    });
  }

  void _useHint() {
    if (_hintsLeft <= 0 || _isSolved) return;

    int firstBadIndex = -1;
    for (int i = 0; i < _board.length; i++) {
      if (_board[i] != i) {
        firstBadIndex = i;
        break;
      }
    }

    if (firstBadIndex != -1) {
      int correctPieceId = firstBadIndex;
      int currentPosOfCorrectPiece = _board.indexOf(correctPieceId);

      setState(() {
        int temp = _board[firstBadIndex];
        _board[firstBadIndex] = _board[currentPosOfCorrectPiece];
        _board[currentPosOfCorrectPiece] = temp;
        _hintsLeft--;
        _firstIndex = null;
        _checkWin();
      });
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_aspectRatio == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tiempo! $_timeDisplay'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              label: Text('Vista previa'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Vista previa'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Ok!'),
                      ),
                    ],
                    content: Column(
                      mainAxisSize: .min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          child: Image.asset(widget.image),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(Icons.remove_red_eye),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AppBannerAd(adUnitId: Environments.gamerScreenId),

          Expanded(
            child: Center(
              child: Container(
                //   margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 4),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                ),
                child: AspectRatio(
                  aspectRatio: _aspectRatio!,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.gridSize,
                      childAspectRatio: _aspectRatio!,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemCount: _board.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _onTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _firstIndex == index
                                  ? Colors.red
                                  : Colors.white12,
                              width: _firstIndex == index ? 4 : 0.5,
                            ),
                          ),
                          child: PuzzlePiece(
                            image: widget.image,
                            pieceId: _board[index],
                            gridSize: widget.gridSize,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_isSolved)
            const Text(
              "¡EXCELENTE TRABAJO!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          if (_isSolved)
            FilledButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PuzzleMenu()),
              ),
              child: Text('Volver al menu principal'),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _initGame()),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Reiniciar"),
                ),
                ElevatedButton.icon(
                  onPressed: (_isSolved)
                      ? null
                      : (_hintsLeft > 0 || _isAdLoaded)
                      ? _handleHintButton
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hintsLeft > 0
                        ? Colors.orange
                        : (_isAdLoaded ? Colors.blueGrey : Colors.grey),
                  ),
                  icon: Icon(
                    _hintsLeft > 0
                        ? Icons.lightbulb
                        : (_isAdLoaded
                              ? Icons.video_library
                              : Icons.hourglass_empty),
                    color: Colors.white,
                  ),
                  label: Text(
                    _hintsLeft > 0
                        ? "Pista ($_hintsLeft)"
                        : (_isAdLoaded
                              ? "Ver video (+1)"
                              : "Cargando anuncio..."),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
