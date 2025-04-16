import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const CrosswordApp());
}

class CrosswordApp extends StatelessWidget {
  const CrosswordApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kids Crossword Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Comic Sans MS',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.lightBlue, Colors.purple],
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.extension, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                Text(
                  "KidsCrossword",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 36,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Fun Learning for Kids!",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 50),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _floatController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // List of fun animated elements to add around the screen
  final List<Map<String, dynamic>> _floatingItems = [
    {'icon': Icons.extension, 'color': Colors.redAccent, 'position': 0.1},
    {'icon': Icons.star, 'color': Colors.amberAccent, 'position': 0.3},
    {'icon': Icons.school, 'color': Colors.greenAccent, 'position': 0.5},
    {'icon': Icons.emoji_events, 'color': Colors.purpleAccent, 'position': 0.7},
    {'icon': Icons.auto_awesome, 'color': Colors.orangeAccent, 'position': 0.9},
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _loadSound();
  }

  Future<void> _loadSound() async {
    // In a real app, you would load background music here
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _floatController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://img.freepik.com/free-vector/cartoon-school-background-with-colorful-pencils_23-2148259763.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Add floating animated elements for fun
              ..._floatingItems.map((item) => _buildFloatingElement(item)),
              
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    // Game logo/title with animation
                    Center(
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, -0.1),
                          end: const Offset(0, 0.1),
                        ).animate(
                          CurvedAnimation(
                            parent: _bounceController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              const Icon(
                                Icons.extension,
                                size: 70,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'KidsCrossword',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Colors.blue,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    const Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.blue,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Fun Learning for Kids!',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.black87,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Add spacer to push buttons lower
                    const Spacer(flex: 1),
                    
                    // Menu buttons with enhanced styling
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          _buildMainButton(
                            context,
                            'Play',
                            Icons.play_circle_filled,
                            Colors.green,
                            () => _showDifficultyDialog(context),
                          ),
                          _buildMainButton(
                            context,
                            'Leaderboard',
                            Icons.leaderboard,
                            Colors.orange,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LeaderboardScreen(),
                              ),
                            ),
                          ),
                          _buildMainButton(
                            context,
                            'How to Play',
                            Icons.help_outline,
                            Colors.purple,
                            () => _showHowToPlayDialog(context),
                          ),
                        ],
                      ),
                    ),
                    
                    // Footer with credits
                    const Spacer(flex: 1),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '© 2025 KidsCrossword',
                              style: TextStyle(color: Colors.black54, fontSize: 14),
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings, color: Colors.black54),
                              onPressed: () {
                                // Settings screen would go here in a real app
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElement(Map<String, dynamic> item) {
    return Positioned(
      top: MediaQuery.of(context).size.height * item['position'],
      right: item['position'] < 0.5 
          ? MediaQuery.of(context).size.width * (0.8 - item['position']) 
          : MediaQuery.of(context).size.width * 0.1,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              sin(_floatController.value * 2 * pi + item['position'] * 5) * 15,
              cos(_floatController.value * 2 * pi + item['position'] * 5) * 15,
            ),
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            item['icon'],
            size: 30,
            color: item['color'],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButton(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          _audioPlayer.play(AssetSource('sounds/click.mp3'));
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          title: const Text(
            'Choose Difficulty',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDifficultyButton('Easy', Colors.green, context, 'easy'),
              const SizedBox(height: 15),
              _buildDifficultyButton(
                'Medium',
                Colors.orange,
                context,
                'medium',
              ),
              const SizedBox(height: 15),
              _buildDifficultyButton('Hard', Colors.red, context, 'hard'),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 24,
        );
      },
    );
  }

  Widget _buildDifficultyButton(
    String text,
    Color color,
    BuildContext context,
    String difficulty,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameScreen(difficulty: difficulty),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showHowToPlayDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          title: Column(
            children: [
              const Icon(Icons.help_outline, size: 50, color: Colors.purple),
              const SizedBox(height: 10),
              const Text(
                'How to Play',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _InstructionItem(
                  number: "1",
                  text: "Select a difficulty level to start the game.",
                  icon: Icons.gamepad,
                ),
                SizedBox(height: 15),
                _InstructionItem(
                  number: "2",
                  text: "Fill in the crossword puzzle by tapping on a cell and typing your answer.",
                  icon: Icons.edit,
                ),
                SizedBox(height: 15),
                _InstructionItem(
                  number: "3",
                  text: "Use hints if you get stuck - but they cost points!",
                  icon: Icons.lightbulb,
                ),
                SizedBox(height: 15),
                _InstructionItem(
                  number: "4",
                  text: "Complete the puzzle before the timer runs out.",
                  icon: Icons.timer,
                ),
                SizedBox(height: 15),
                _InstructionItem(
                  number: "5",
                  text: "The faster you complete the puzzle, the higher your score!",
                  icon: Icons.emoji_events,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Got it!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 24,
        );
      },
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;
  final IconData icon;

  const _InstructionItem({
    required this.number,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue, size: 20),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class GameScreen extends StatefulWidget {
  final String difficulty;

  const GameScreen({Key? key, required this.difficulty}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late CrosswordData _crosswordData;
  late List<List<String>> _currentAnswers;
  late List<List<bool>> _revealed;
  late int _timeRemaining;
  late Timer _timer;
  int _hintsRemaining = 3;
  int _score = 0;
  String _selectedClue = '';
  int _selectedClueIndex = -1;
  bool _isAcross = true;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _hintAnimation;
  late AnimationController _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _loadCrossword();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _hintAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _setTimerBasedOnDifficulty();
    _startTimer();
  }

  void _setTimerBasedOnDifficulty() {
    switch (widget.difficulty) {
      case 'easy':
        _timeRemaining = 300; // 5 minutes
        break;
      case 'medium':
        _timeRemaining = 240; // 4 minutes
        break;
      case 'hard':
        _timeRemaining = 180; // 3 minutes
        break;
      default:
        _timeRemaining = 300;
    }
  }

  void _loadCrossword() {
    // In a real app, you'd load different puzzles based on difficulty
    // This is a simplified example
    if (widget.difficulty == 'easy') {
      _crosswordData = easyPuzzle;
    } else if (widget.difficulty == 'medium') {
      _crosswordData = mediumPuzzle;
    } else {
      _crosswordData = hardPuzzle;
    }

    // Initialize the current answers grid with empty spaces
    _currentAnswers = List.generate(
      _crosswordData.grid.length,
      (i) => List.generate(_crosswordData.grid[0].length, (j) => ''),
    );

    // Initialize revealed hints
    _revealed = List.generate(
      _crosswordData.grid.length,
      (i) => List.generate(_crosswordData.grid[0].length, (j) => false),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _timer.cancel();
          _showGameOverDialog(false);
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _checkCompletion() {
    bool isComplete = true;

    // Check if all cells match the expected answers
    for (int i = 0; i < _crosswordData.grid.length; i++) {
      for (int j = 0; j < _crosswordData.grid[i].length; j++) {
        if (_crosswordData.grid[i][j] != '#' &&
            _currentAnswers[i][j] != _crosswordData.grid[i][j]) {
          isComplete = false;
          break;
        }
      }
      if (!isComplete) break;
    }

    if (isComplete) {
      _timer.cancel();
      _calculateScore();
      _confettiController.play();
      _showGameOverDialog(true);
    }
  }

  void _calculateScore() {
    // Base score depends on difficulty
    int baseScore = 0;
    switch (widget.difficulty) {
      case 'easy':
        baseScore = 100;
        break;
      case 'medium':
        baseScore = 200;
        break;
      case 'hard':
        baseScore = 300;
        break;
    }

    // Add time bonus
    int timeBonus = _timeRemaining * 2;

    // Subtract for used hints
    int hintsPenalty = (3 - _hintsRemaining) * 25;

    _score = baseScore + timeBonus - hintsPenalty;
    if (_score < 0) _score = 0;

    // Save to leaderboard
    _saveScore();
  }

  Future<void> _saveScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> scores = prefs.getStringList('scores') ?? [];

      scores.add('${widget.difficulty}:$_score');
      scores.sort((a, b) {
        final scoreA = int.parse(a.split(':')[1]);
        final scoreB = int.parse(b.split(':')[1]);
        return scoreB.compareTo(scoreA); // Sort in descending order
      });

      // Keep only top 10 scores
      if (scores.length > 10) {
        scores.removeRange(10, scores.length);
      }

      await prefs.setStringList('scores', scores);
    } catch (e) {
      // Handle error
    }
  }

  void _useHint() {
    if (_hintsRemaining <= 0) {
      _showMessage('No hints remaining!');
      return;
    }

    if (_selectedClueIndex == -1) {
      _showMessage('Select a word first!');
      return;
    }

    setState(() {
      _hintsRemaining--;

      // Find a random unfilled cell in the selected clue
      final clue =
          _isAcross
              ? _crosswordData.acrossClues[_selectedClueIndex]
              : _crosswordData.downClues[_selectedClueIndex];

      final int row = clue.startPosition[0];
      final int col = clue.startPosition[1];

      List<List<int>> emptyCells = [];

      if (_isAcross) {
        for (int j = 0; j < clue.length; j++) {
          if (_currentAnswers[row][col + j] !=
              _crosswordData.grid[row][col + j]) {
            emptyCells.add([row, col + j]);
          }
        }
      } else {
        for (int i = 0; i < clue.length; i++) {
          if (_currentAnswers[row + i][col] !=
              _crosswordData.grid[row + i][col]) {
            emptyCells.add([row + i, col]);
          }
        }
      }

      if (emptyCells.isNotEmpty) {
        final randomCell = emptyCells[Random().nextInt(emptyCells.length)];
        final cellRow = randomCell[0];
        final cellCol = randomCell[1];

        _currentAnswers[cellRow][cellCol] =
            _crosswordData.grid[cellRow][cellCol];
        _revealed[cellRow][cellCol] = true;

        _hintAnimation.reset();
        _hintAnimation.forward();
        _audioPlayer.play(AssetSource('sounds/hint.mp3'));

        _checkCompletion();
      } else {
        // If there are no empty cells, refund the hint
        _hintsRemaining++;
        _showMessage('This word is already complete!');
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showGameOverDialog(bool isWin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isWin ? 'Congratulations!' : 'Time\'s Up!',
            style: TextStyle(
              color: isWin ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isWin ? 'You completed the puzzle!' : 'You ran out of time!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              isWin
                  ? Text(
                    'Your Score: $_score',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )
                  : const SizedBox.shrink(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Back to Menu'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _restartGame();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                'Play Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  void _restartGame() {
    setState(() {
      _loadCrossword();
      _setTimerBasedOnDifficulty();
      _startTimer();
      _hintsRemaining = 3;
      _score = 0;
      _selectedClue = '';
      _selectedClueIndex = -1;
    });
  }

  void _selectClue(int clueIndex, bool isAcross) {
    setState(() {
      _selectedClueIndex = clueIndex;
      _isAcross = isAcross;

      final clue =
          isAcross
              ? _crosswordData.acrossClues[clueIndex]
              : _crosswordData.downClues[clueIndex];

      _selectedClue = '${clue.number}. ${clue.clue}';
    });
  }

  void _onCellTap(int row, int col) {
    // Find which clue this cell belongs to
    for (int i = 0; i < _crosswordData.acrossClues.length; i++) {
      final clue = _crosswordData.acrossClues[i];
      final startRow = clue.startPosition[0];
      final startCol = clue.startPosition[1];

      if (row == startRow && col >= startCol && col < startCol + clue.length) {
        _selectClue(i, true);
        return;
      }
    }

    for (int i = 0; i < _crosswordData.downClues.length; i++) {
      final clue = _crosswordData.downClues[i];
      final startRow = clue.startPosition[0];
      final startCol = clue.startPosition[1];

      if (col == startCol && row >= startRow && row < startRow + clue.length) {
        _selectClue(i, false);
        return;
      }
    }
  }

  void _onKeyPressed(String key, int row, int col) {
    if (key.length != 1 || !RegExp(r'[a-zA-Z]').hasMatch(key)) {
      return;
    }

    setState(() {
      _currentAnswers[row][col] = key.toUpperCase();

      // Move to next cell based on direction
      if (_isAcross) {
        // Find next cell in the row
        int nextCol = col + 1;
        if (nextCol < _crosswordData.grid[0].length &&
            _crosswordData.grid[row][nextCol] != '#') {
          // Focus next cell
        }
      } else {
        // Find next cell in the column
        int nextRow = row + 1;
        if (nextRow < _crosswordData.grid.length &&
            _crosswordData.grid[nextRow][col] != '#') {
          // Focus next cell
        }
      }

      _checkCompletion();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _focusNode.dispose();
    _textController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _hintAnimation.dispose();
    _shakeAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.difficulty.toUpperCase()} CROSSWORD',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: _timeRemaining < 30 ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    _formatTime(_timeRemaining),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue.shade50, Colors.white],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Clue display
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedClue.isEmpty
                                ? 'Select a cell to see clue'
                                : _selectedClue,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Crossword grid
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                _crosswordData.grid.length *
                                _crosswordData.grid[0].length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _crosswordData.grid[0].length,
                                ),
                            itemBuilder: (context, index) {
                              final row =
                                  index ~/ _crosswordData.grid[0].length;
                              final col = index % _crosswordData.grid[0].length;

                              if (_crosswordData.grid[row][col] == '#') {
                                return Container(color: Colors.black);
                              }

                              // Check if this is the start of any clue
                              String cellNumber = '';
                              for (var clue in _crosswordData.acrossClues) {
                                if (clue.startPosition[0] == row &&
                                    clue.startPosition[1] == col) {
                                  cellNumber = clue.number.toString();
                                  break;
                                }
                              }

                              if (cellNumber.isEmpty) {
                                for (var clue in _crosswordData.downClues) {
                                  if (clue.startPosition[0] == row &&
                                      clue.startPosition[1] == col) {
                                    cellNumber = clue.number.toString();
                                    break;
                                  }
                                }
                              }

                              bool isSelected = false;
                              if (_selectedClueIndex != -1) {
                                final clue =
                                    _isAcross
                                        ? _crosswordData
                                            .acrossClues[_selectedClueIndex]
                                        : _crosswordData
                                            .downClues[_selectedClueIndex];

                                final startRow = clue.startPosition[0];
                                final startCol = clue.startPosition[1];

                                if (_isAcross) {
                                  isSelected =
                                      row == startRow &&
                                      col >= startCol &&
                                      col < startCol + clue.length;
                                } else {
                                  isSelected =
                                      col == startCol &&
                                      row >= startRow &&
                                      row < startRow + clue.length;
                                }
                              }

                              return GestureDetector(
                                onTap: () => _onCellTap(row, col),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.lightBlue.shade100
                                            : _revealed[row][col]
                                            ? Colors.yellow.shade50
                                            : Colors.white,
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Colors.blue
                                              : Colors.grey,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      if (cellNumber.isNotEmpty)
                                        Positioned(
                                          top: 2,
                                          left: 2,
                                          child: Text(
                                            cellNumber,
                                            style: const TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      Center(
                                        child: Text(
                                          _currentAnswers[row][col],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                _revealed[row][col]
                                                    ? Colors.blue
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Virtual keyboard
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    color: Colors.grey.shade200,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              'QWERTYUIOP'.split('').map((letter) {
                                return _buildKeyboardKey(letter);
                              }).toList(),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              'ASDFGHJKL'.split('').map((letter) {
                                return _buildKeyboardKey(letter);
                              }).toList(),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              'ZXCVBNM'.split('').map((letter) {
                                return _buildKeyboardKey(letter);
                              }).toList(),
                        ),
                        const SizedBox(height: 10),
                        // Game controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AnimatedBuilder(
                              animation: _hintAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale:
                                      Tween<double>(begin: 1.0, end: 1.2)
                                          .animate(
                                            CurvedAnimation(
                                              parent: _hintAnimation,
                                              curve: Curves.elasticInOut,
                                            ),
                                          )
                                          .value,
                                  child: child,
                                );
                              },
                              child: ElevatedButton.icon(
                                onPressed: _useHint,
                                icon: const Icon(Icons.lightbulb),
                                label: Text('Hint ($_hintsRemaining)'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      _hintsRemaining > 0
                                          ? Colors.amber
                                          : Colors.grey,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Confirm'),
                                        content: const Text(
                                          'Are you sure you want to quit?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text(
                                              'Quit',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              icon: const Icon(Icons.exit_to_app),
                              label: const Text('Quit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Confetti effect for winning
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardKey(String letter) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ElevatedButton(
        onPressed: () {
          if (_selectedClueIndex != -1) {
            final clue =
                _isAcross
                    ? _crosswordData.acrossClues[_selectedClueIndex]
                    : _crosswordData.downClues[_selectedClueIndex];

            final startRow = clue.startPosition[0];
            final startCol = clue.startPosition[1];

            for (int i = 0; i < clue.length; i++) {
              final row = _isAcross ? startRow : startRow + i;
              final col = _isAcross ? startCol + i : startCol;

              if (_currentAnswers[row][col].isEmpty) {
                _onKeyPressed(letter, row, col);
                break;
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          minimumSize: const Size(35, 35),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(
          letter,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  List<ScoreEntry> _scores = [];
  String _filter = 'all';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadScores();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);

    _controller.forward();
  }

  Future<void> _loadScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> scoreStrings = prefs.getStringList('scores') ?? [];

      _scores =
          scoreStrings.map((s) {
            final parts = s.split(':');
            return ScoreEntry(difficulty: parts[0], score: int.parse(parts[1]));
          }).toList();

      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter scores based on selected filter
    List<ScoreEntry> filteredScores =
        _filter == 'all'
            ? _scores
            : _scores.where((s) => s.difficulty == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 10),
                  _buildFilterChip('Easy', 'easy'),
                  const SizedBox(width: 10),
                  _buildFilterChip('Medium', 'medium'),
                  const SizedBox(width: 10),
                  _buildFilterChip('Hard', 'hard'),
                ],
              ),
            ),
            Expanded(
              child:
                  filteredScores.isEmpty
                      ? const Center(
                        child: Text(
                          'No scores yet. Play a game!',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                      : ListView.builder(
                        itemCount: filteredScores.length,
                        itemBuilder: (context, index) {
                          final score = filteredScores[index];
                          return FadeTransition(
                            opacity: _animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 0.1 * index),
                                end: Offset.zero,
                              ).animate(_animation),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          index == 0
                                              ? Colors.amber
                                              : index == 1
                                              ? Colors.grey.shade300
                                              : index == 2
                                              ? Colors.brown.shade300
                                              : Colors.blue.shade100,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              index < 3
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      'Score: ${score.score}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Difficulty: ${score.difficulty[0].toUpperCase()}${score.difficulty.substring(1)}',
                                    ),
                                    trailing: Icon(
                                      score.difficulty == 'easy'
                                          ? Icons.sentiment_satisfied
                                          : score.difficulty == 'medium'
                                          ? Icons.sentiment_neutral
                                          : Icons.sentiment_very_dissatisfied,
                                      color:
                                          score.difficulty == 'easy'
                                              ? Colors.green
                                              : score.difficulty == 'medium'
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _filter == value,
      onSelected: (selected) {
        setState(() {
          _filter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.blue.shade200,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: _filter == value ? Colors.white : Colors.black,
        fontWeight: _filter == value ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

// Models
class CrosswordData {
  final List<List<String>> grid;
  final List<ClueData> acrossClues;
  final List<ClueData> downClues;

  CrosswordData({
    required this.grid,
    required this.acrossClues,
    required this.downClues,
  });
}

class ClueData {
  final int number;
  final String clue;
  final List<int> startPosition; // [row, col]
  final int length;

  ClueData({
    required this.number,
    required this.clue,
    required this.startPosition,
    required this.length,
  });
}

class ScoreEntry {
  final String difficulty;
  final int score;

  ScoreEntry({required this.difficulty, required this.score});
}

// Sample puzzle data
final easyPuzzle = CrosswordData(
  grid: [
    ['C', 'A', 'T', '#', 'D'],
    ['O', '#', 'O', '#', 'O'],
    ['W', 'I', 'N', 'D', 'G'],
    ['#', '#', '#', '#', '#'],
    ['S', 'U', 'N', '#', '#'],
  ],
  acrossClues: [
    ClueData(number: 1, clue: 'Feline pet', startPosition: [0, 0], length: 3),
    ClueData(
      number: 5,
      clue: 'House pet that barks',
      startPosition: [0, 4],
      length: 1,
    ),
    ClueData(number: 6, clue: 'Moving air', startPosition: [2, 0], length: 4),
    ClueData(
      number: 8,
      clue: 'It shines during the day',
      startPosition: [4, 0],
      length: 3,
    ),
  ],
  downClues: [
    ClueData(
      number: 1,
      clue: 'Animal that gives milk',
      startPosition: [0, 0],
      length: 3,
    ),
    ClueData(number: 2, clue: 'Not no', startPosition: [0, 1], length: 1),
    ClueData(
      number: 3,
      clue: 'Toy to play with',
      startPosition: [0, 2],
      length: 3,
    ),
    ClueData(number: 4, clue: 'Woof animal', startPosition: [0, 4], length: 3),
  ],
);

final mediumPuzzle = CrosswordData(
  grid: [
    ['F', 'R', 'O', 'G', '#'],
    ['L', '#', 'R', '#', 'T'],
    ['O', 'C', 'A', 'T', 'I'],
    ['W', '#', 'N', '#', 'G'],
    ['#', 'B', 'G', 'E', 'R'],
  ],
  acrossClues: [
    ClueData(
      number: 1,
      clue: 'Green amphibian that hops',
      startPosition: [0, 0],
      length: 4,
    ),
    ClueData(
      number: 5,
      clue: 'Feline animal',
      startPosition: [2, 1],
      length: 3,
    ),
    ClueData(
      number: 7,
      clue: 'Buzzing insect that makes honey',
      startPosition: [4, 1],
      length: 4,
    ),
  ],
  downClues: [
    ClueData(
      number: 1,
      clue: 'A beautiful plant that grows in gardens',
      startPosition: [0, 0],
      length: 4,
    ),
    ClueData(number: 2, clue: 'Red fruit', startPosition: [0, 1], length: 1),
    ClueData(
      number: 3,
      clue: 'Color of the sky',
      startPosition: [0, 2],
      length: 5,
    ),
    ClueData(
      number: 4,
      clue: 'Wild striped cat',
      startPosition: [0, 3],
      length: 5,
    ),
    ClueData(
      number: 6,
      clue: 'Used to write on paper',
      startPosition: [2, 4],
      length: 3,
    ),
  ],
);

final hardPuzzle = CrosswordData(
  grid: [
    ['P', 'L', 'A', 'N', 'E', 'T'],
    ['#', 'I', '#', '#', 'A', '#'],
    ['M', 'G', 'H', 'T', 'R', 'T'],
    ['O', 'H', '#', 'R', 'T', 'H'],
    ['O', 'T', '#', 'A', 'H', '#'],
    ['N', '#', 'S', 'I', '#', '#'],
  ],
  acrossClues: [
    ClueData(
      number: 1,
      clue: 'Earth is this type of object in space',
      startPosition: [0, 0],
      length: 6,
    ),
    ClueData(
      number: 5,
      clue: 'Night and day, sun and stars',
      startPosition: [2, 0],
      length: 6,
    ),
    ClueData(
      number: 8,
      clue: 'Natural satellite of Earth',
      startPosition: [3, 0],
      length: 6,
    ),
    ClueData(
      number: 9,
      clue: 'Star that gives us light during day',
      startPosition: [5, 2],
      length: 3,
    ),
  ],
  downClues: [
    ClueData(
      number: 1,
      clue: 'Controls ocean tides',
      startPosition: [0, 0],
      length: 5,
    ),
    ClueData(
      number: 2,
      clue: 'Glowing space bodies',
      startPosition: [0, 1],
      length: 5,
    ),
    ClueData(number: 3, clue: 'Our planet', startPosition: [0, 3], length: 5),
    ClueData(
      number: 4,
      clue: 'Planet closest to the sun',
      startPosition: [0, 4],
      length: 5,
    ),
    ClueData(number: 6, clue: 'Red planet', startPosition: [0, 5], length: 4),
    ClueData(
      number: 7,
      clue: 'Gas giant with rings',
      startPosition: [3, 2],
      length: 6,
    ),
  ],
);
