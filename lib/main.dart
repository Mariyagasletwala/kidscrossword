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
                SizedBox(height: 15),
                _InstructionItem(
                  number: "6",
                  text: "Use the undo button to remove the last letter you typed.",
                  icon: Icons.undo,
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
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue, size: 20),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
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
  
  // Selected cell coordinates - improved for better cell navigation
  int _selectedRow = -1;
  int _selectedCol = -1;
  
  // To track history for undo functionality
  List<CellHistoryEntry> _historyStack = [];
  
  // Error handling state
  bool _hasError = false;
  int _errorRow = -1;
  int _errorCol = -1;
  Timer? _errorTimer;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late AnimationController _hintAnimation;
  late AnimationController _shakeAnimation;
  late AnimationController _errorAnimation;

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
    
    _errorAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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

  // Check if a completed word is correct
  void _checkCurrentWord() {
    if (_selectedClueIndex == -1) return;
    
    final clue = _isAcross
        ? _crosswordData.acrossClues[_selectedClueIndex]
        : _crosswordData.downClues[_selectedClueIndex];
    
    final int row = clue.startPosition[0];
    final int col = clue.startPosition[1];
    bool isComplete = true;
    bool hasError = false;
    int errorRow = -1;
    int errorCol = -1;
    
    if (_isAcross) {
      for (int j = 0; j < clue.length; j++) {
        if (_currentAnswers[row][col + j] == '') {
          isComplete = false;
          break;
        } else if (_currentAnswers[row][col + j] != _crosswordData.grid[row][col + j]) {
          hasError = true;
          errorRow = row;
          errorCol = col + j;
        }
      }
    } else {
      for (int i = 0; i < clue.length; i++) {
        if (_currentAnswers[row + i][col] == '') {
          isComplete = false;
          break;
        } else if (_currentAnswers[row + i][col] != _crosswordData.grid[row + i][col]) {
          hasError = true;
          errorRow = row + i;
          errorCol = col;
        }
      }
    }
    
    if (isComplete && hasError) {
      _showWordError(errorRow, errorCol);
    }
  }
  
  // Show visual notification for incorrect word
  void _showWordError(int row, int col) {
    setState(() {
      _hasError = true;
      _errorRow = row;
      _errorCol = col;
      _audioPlayer.play(AssetSource('sounds/error.mp3'));
      _errorAnimation.reset();
      _errorAnimation.forward();
    });
    
    // Clean up error state after animation
    _errorTimer?.cancel();
    _errorTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _hasError = false;
        });
      }
    });
    
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Oops! This word has an error. Check your spelling.'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
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
          for (int i = 0; i < clue.length; i++) {
            if (_currentAnswers[row + i][col] != _crosswordData.grid[row + i][col]) {
              emptyCells.add([row + i, col]);
            }
          }
        }
      }

      if (emptyCells.isEmpty) {
        _showMessage('This word is already correct!');
        _hintsRemaining++; // Refund the hint
        return;
      }

      // Select a random empty cell and reveal it
      final random = Random();
      final selectedCell = emptyCells[random.nextInt(emptyCells.length)];
      final cellRow = selectedCell[0];
      final cellCol = selectedCell[1];

      _currentAnswers[cellRow][cellCol] = _crosswordData.grid[cellRow][cellCol];
      _revealed[cellRow][cellCol] = true;

      // Animation and sound effect
      _hintAnimation.reset();
      _hintAnimation.forward();
      _audioPlayer.play(AssetSource('sounds/hint.mp3'));
    });

    _checkCompletion();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _selectCell(int row, int col) {
    if (_crosswordData.grid[row][col] == '#') return;

    setState(() {
      _selectedRow = row;
      _selectedCol = col;

      // Find which clue this cell belongs to
      _findSelectedClue(row, col);
    });

    _focusNode.requestFocus();
  }

  void _findSelectedClue(int row, int col) {
    // First check if cell is part of an across clue
    for (int i = 0; i < _crosswordData.acrossClues.length; i++) {
      final clue = _crosswordData.acrossClues[i];
      final startRow = clue.startPosition[0];
      final startCol = clue.startPosition[1];

      if (row == startRow && col >= startCol && col < startCol + clue.length) {
        _selectedClueIndex = i;
        _selectedClue = clue.clue;
        _isAcross = true;
        return;
      }
    }

    // Then check down clues
    for (int i = 0; i < _crosswordData.downClues.length; i++) {
      final clue = _crosswordData.downClues[i];
      final startRow = clue.startPosition[0];
      final startCol = clue.startPosition[1];

      if (col == startCol && row >= startRow && row < startRow + clue.length) {
        _selectedClueIndex = i;
        _selectedClue = clue.clue;
        _isAcross = false;
        return;
      }
    }

    // Default case if no clue is found
    _selectedClueIndex = -1;
    _selectedClue = '';
  }

  void _handleKeyInput(String key) {
    if (_selectedRow == -1 || _selectedCol == -1) return;
    
    // Validate input - only allow letters
    if (!RegExp(r'^[a-zA-Z]$').hasMatch(key)) return;

    setState(() {
      // Save history for undo
      _historyStack.add(CellHistoryEntry(
        row: _selectedRow,
        col: _selectedCol, 
        prevValue: _currentAnswers[_selectedRow][_selectedCol]
      ));
      
      // Update cell with uppercase letter
      _currentAnswers[_selectedRow][_selectedCol] = key.toUpperCase();
      
      // Move to next cell in the direction of the selected clue
      if (_isAcross && _selectedCol + 1 < _crosswordData.grid[0].length && 
          _crosswordData.grid[_selectedRow][_selectedCol + 1] != '#') {
        _selectedCol++;
      } else if (!_isAcross && _selectedRow + 1 < _crosswordData.grid.length && 
          _crosswordData.grid[_selectedRow + 1][_selectedCol] != '#') {
        _selectedRow++;
      }
    });

    _audioPlayer.play(AssetSource('sounds/type.mp3'));
    _checkCurrentWord();
    _checkCompletion();
  }

  void _undoLastEntry() {
    if (_historyStack.isEmpty) {
      _showMessage('Nothing to undo!');
      return;
    }

    setState(() {
      final lastEntry = _historyStack.removeLast();
      _currentAnswers[lastEntry.row][lastEntry.col] = lastEntry.prevValue;
      _selectedRow = lastEntry.row;
      _selectedCol = lastEntry.col;
      _findSelectedClue(lastEntry.row, lastEntry.col);
    });
    
    _audioPlayer.play(AssetSource('sounds/undo.mp3'));
  }

  void _toggleDirection() {
    if (_selectedRow == -1 || _selectedCol == -1) return;

    setState(() {
      _isAcross = !_isAcross;
      _findSelectedClue(_selectedRow, _selectedCol);
    });
  }

  void _showGameOverDialog(bool isWin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.95),
          title: Column(
            children: [
              Icon(
                isWin ? Icons.emoji_events : Icons.timer_off, 
                size: 60, 
                color: isWin ? Colors.amber : Colors.red
              ),
              const SizedBox(height: 10),
              Text(
                isWin ? 'Congratulations!' : 'Time\'s Up!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isWin ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isWin
                    ? 'You completed the puzzle!'
                    : 'You ran out of time!',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (isWin) ...[
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Time Left: ${_formatTime(_timeRemaining)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'Hints Used: ${3 - _hintsRemaining}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: [
            if (isWin)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('View Leaderboard'),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Main Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _errorTimer?.cancel();
    _focusNode.dispose();
    _textController.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
    _hintAnimation.dispose();
    _shakeAnimation.dispose();
    _errorAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.lightBlue, Colors.white],
                ),
              ),
            ),
            
            // Confetti overlay for winning celebration
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                particleDrag: 0.05,
                emissionFrequency: 0.05,
                numberOfParticles: 20,
                gravity: 0.1,
                colors: const [
                  Colors.red,
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                ],
              ),
            ),
            
            // Main content
            Column(
              children: [
                // App bar with game info
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text('Your progress will be lost.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Stay'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Leave'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      // Timer and Difficulty
                      Column(
                        children: [
                          Text(
                            widget.difficulty.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: widget.difficulty == 'easy'
                                  ? Colors.green
                                  : widget.difficulty == 'medium'
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.timer, color: Colors.blue),
                              const SizedBox(width: 5),
                              Text(
                                _formatTime(_timeRemaining),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _timeRemaining < 60
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Hints indicator
                      Row(
                        children: [
                          const Icon(Icons.lightbulb, color: Colors.amber),
                          const SizedBox(width: 5),
                          Text(
                            '$_hintsRemaining',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Clue display
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                    border: _selectedClue.isNotEmpty
                        ? Border.all(color: Colors.blue, width: 2)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedClue.isNotEmpty
                            ? '${_isAcross ? "Across" : "Down"}: $_selectedClue'
                            : 'Select a cell to see the clue',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedClue.isNotEmpty)
                        const SizedBox(height: 5),
                      if (_selectedClue.isNotEmpty)
                        Text(
                          'Tap the clue to change direction',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Crossword grid - using Expanded to fill available space
                Expanded(
                  child: KeyboardListener(
                    focusNode: _focusNode,
                    onKeyEvent: (event) {
                      if (event is KeyDownEvent) {
                        if (event.logicalKey == LogicalKeyboardKey.backspace) {
                          _undoLastEntry();
                        } else if (event.logicalKey == LogicalKeyboardKey.space) {
                          _toggleDirection();
                        } else if (event.character != null && 
                            event.character!.isNotEmpty) {
                          _handleKeyInput(event.character!);
                        }
                      }
                    },
                    child: GestureDetector(
                      onTap: () => _focusNode.requestFocus(),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crosswordData.grid[0].length,
                            ),
                            itemCount: _crosswordData.grid.length * _crosswordData.grid[0].length,
                            itemBuilder: (context, index) {
                              final row = index ~/ _crosswordData.grid[0].length;
                              final col = index % _crosswordData.grid[0].length;
                              
                              // If this is a black cell in the grid
                              if (_crosswordData.grid[row][col] == '#') {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(color: Colors.grey, width: 0.5),
                                  ),
                                );
                              }
                              
                              // Check if this cell has a clue number
                              String? clueNumber;
                              for (final clue in _crosswordData.acrossClues) {
                                if (clue.startPosition[0] == row && clue.startPosition[1] == col) {
                                  clueNumber = clue.number.toString();
                                  break;
                                }
                              }
                              
                              if (clueNumber == null) {
                                for (final clue in _crosswordData.downClues) {
                                  if (clue.startPosition[0] == row && clue.startPosition[1] == col) {
                                    clueNumber = clue.number.toString();
                                    break;
                                  }
                                }
                              }
                              
                              // Error animation
                              final isError = _hasError && _errorRow == row && _errorCol == col;
                              
                              // Actual cell with letter
                              return AnimatedBuilder(
                                animation: isError ? _errorAnimation : _hintAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _revealed[row][col] && _hintAnimation.status == AnimationStatus.forward
                                        ? 1.0 + _hintAnimation.value * 0.2
                                        : 1.0,
                                    child: Transform.translate(
                                      offset: isError
                                          ? Offset(sin(_errorAnimation.value * 4 * pi) * 5, 0)
                                          : Offset.zero,
                                      child: child,
                                    ),
                                  );
                                },
                                child: GestureDetector(
                                  onTap: () => _selectCell(row, col),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _selectedRow == row && _selectedCol == col
                                          ? Colors.lightBlue.withOpacity(0.6)
                                          : _isAcross && _selectedRow == row && _selectedClueIndex != -1
                                              ? Colors.lightBlue.withOpacity(0.2)
                                              : !_isAcross && _selectedCol == col && _selectedClueIndex != -1
                                                  ? Colors.lightBlue.withOpacity(0.2)
                                                  : Colors.white,
                                      border: Border.all(
                                        color: _revealed[row][col]
                                            ? Colors.green
                                            : isError
                                                ? Colors.red
                                                : Colors.grey,
                                        width: _revealed[row][col] || isError ? 2 : 0.5,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        // Clue number
                                        if (clueNumber != null)
                                          Positioned(
                                            top: 1,
                                            left: 1,
                                            child: Text(
                                              clueNumber,
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        
                                        // Letter
                                        Center(
                                          child: Text(
                                            _currentAnswers[row][col],
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: _revealed[row][col]
                                                  ? Colors.green
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Controls at the bottom
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Undo button
                      ElevatedButton.icon(
                        onPressed: _undoLastEntry,
                        icon: const Icon(Icons.undo),
                        label: const Text('Undo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      
                      // Direction toggle
                      ElevatedButton.icon(
                        onPressed: _toggleDirection,
                        icon: Icon(_isAcross ? Icons.arrow_right_alt : Icons.arrow_downward),
                        label: Text(_isAcross ? 'Across' : 'Down'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      
                      // Hint button
                      ElevatedButton.icon(
                        onPressed: _hintsRemaining > 0 ? _useHint : null,
                        icon: const Icon(Icons.lightbulb),
                        label: const Text('Hint'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Simple keyboard for input
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 'QWERTYUIOP'.split('').map((letter) {
                          return _buildKeyboardKey(letter);
                        }).toList(),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 'ASDFGHJKL'.split('').map((letter) {
                          return _buildKeyboardKey(letter);
                        }).toList(),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 'ZXCVBNM'.split('').map((letter) {
                          return _buildKeyboardKey(letter);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildKeyboardKey(String letter) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => _handleKeyInput(letter),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 30,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Model class for tracking cell history
class CellHistoryEntry {
  final int row;
  final int col;
  final String prevValue;
  
  CellHistoryEntry({
    required this.row,
    required this.col,
    required this.prevValue,
  });
}

// Model classes
class CrosswordClue {
  final int number;
  final String clue;
  final List<int> startPosition;
  final int length;

  const CrosswordClue({
    required this.number,
    required this.clue,
    required this.startPosition,
    required this.length,
  });
}

class CrosswordData {
  final List<List<String>> grid;
  final List<CrosswordClue> acrossClues;
  final List<CrosswordClue> downClues;

  const CrosswordData({
    required this.grid,
    required this.acrossClues,
    required this.downClues,
  });
}

// Sample crossword puzzles
final easyPuzzle = CrosswordData(
  grid: [
    ['C', 'A', 'T', '#', 'D'],
    ['#', '#', 'O', '#', 'O'],
    ['D', 'O', 'G', '#', 'G'],
    ['#', '#', '#', '#', '#'],
    ['S', 'U', 'N', '#', '#'],
  ],
  acrossClues: [
    const CrosswordClue(
      number: 1,
      clue: 'A furry pet that says "meow"',
      startPosition: [0, 0],
      length: 3,
    ),
    const CrosswordClue(
      number: 4,
      clue: 'A furry pet that says "woof"',
      startPosition: [2, 0],
      length: 3,
    ),
    const CrosswordClue(
      number: 5,
      clue: 'It shines in the sky during day',
      startPosition: [4, 0],
      length: 3,
    ),
  ],
  downClues: [
    const CrosswordClue(
      number: 1,
      clue: 'It says "cock-a-doodle-doo"',
      startPosition: [0, 0],
      length: 3,
    ),
    const CrosswordClue(
      number: 2,
      clue: 'It says "tweet tweet"',
      startPosition: [0, 2],
      length: 3,
    ),
    const CrosswordClue(
      number: 3,
      clue: 'A pet that likes to chase mice',
      startPosition: [0, 4],
      length: 3,
    ),
  ],
);

final mediumPuzzle = CrosswordData(
  grid: [
    ['S', 'T', 'A', 'R', '#', 'M'],
    ['K', '#', 'P', '#', 'B', 'O'],
    ['Y', 'E', 'P', 'L', 'E', 'O'],
    ['#', 'A', 'L', '#', 'A', 'N'],
    ['C', 'R', 'E', 'D', '#', '#'],
  ],
  acrossClues: [
    const CrosswordClue(
      number: 1,
      clue: 'Twinkle twinkle little...',
      startPosition: [0, 0],
      length: 4,
    ),
    const CrosswordClue(
      number: 5,
      clue: 'The planet we live on',
      startPosition: [2, 0],
      length: 5,
    ),
    const CrosswordClue(
      number: 7,
      clue: 'The color of the sky',
      startPosition: [4, 0],
      length: 4,
    ),
  ],
  downClues: [
    const CrosswordClue(
      number: 1,
      clue: 'The big yellow star in our sky',
      startPosition: [0, 0],
      length: 3,
    ),
    const CrosswordClue(
      number: 2,
      clue: 'When it\'s dark and you sleep',
      startPosition: [0, 1],
      length: 5,
    ),
    const CrosswordClue(
      number: 3,
      clue: 'Something that falls from clouds',
      startPosition: [0, 2],
      length: 4,
    ),
    const CrosswordClue(
      number: 4,
      clue: 'A flying mammal',
      startPosition: [0, 4],
      length: 3,
    ),
    const CrosswordClue(
      number: 6,
      clue: 'Opposite of yes',
      startPosition: [0, 5],
      length: 2,
    ),
  ],
);

final hardPuzzle = CrosswordData(
  grid: [
    ['D', 'I', 'N', 'O', 'S', 'A', 'U', 'R'],
    ['#', '#', '#', 'C', '#', '#', '#', 'A'],
    ['P', 'L', 'A', 'E', 'A', 'N', '#', 'I'],
    ['L', '#', '#', 'A', '#', 'E', '#', 'N'],
    ['A', 'R', 'C', 'N', '#', 'P', '#', 'B'],
    ['N', '#', '#', '#', '#', 'T', '#', 'O'],
    ['E', 'L', 'E', 'P', 'H', 'U', 'N', 'W'],
    ['T', '#', '#', '#', '#', 'N', '#', '#'],
  ],
  acrossClues: [
    const CrosswordClue(
      number: 1,
      clue: 'Giant extinct reptile',
      startPosition: [0, 0],
      length: 8,
    ),
    const CrosswordClue(
      number: 3,
      clue: 'The Earth is this',
      startPosition: [2, 0],
      length: 6,
    ),
    const CrosswordClue(
      number: 6,
      clue: 'Big gray animal with trunk',
      startPosition: [6, 0],
      length: 8,
    ),
  ],
  downClues: [
    const CrosswordClue(
      number: 1,
      clue: 'Where plants and animals live',
      startPosition: [0, 0],
      length: 6,
    ),
    const CrosswordClue(
      number: 2,
      clue: 'The ____ of the jungle (lion)',
      startPosition: [0, 3],
      length: 4,
    ),
    const CrosswordClue(
      number: 4,
      clue: 'Humans, gorillas, and chimps',
      startPosition: [0, 5],
      length: 7,
    ),
    const CrosswordClue(
      number: 5,
      clue: 'Colors in the sky after rain',
      startPosition: [0, 7],
      length: 7,
    ),
  ],
);

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold (
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.blue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Leaderboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              
              // Trophy icon
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 10),
              const Text(
                'Top Scores',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              
              // Leaderboard content
              Expanded(
                child: FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    
                    final List<String> scores = 
                        snapshot.data!.getStringList('scores') ?? [];
                    
                    if (scores.isEmpty) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sentiment_dissatisfied,
                                size: 60,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'No scores yet!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Complete a puzzle to see your scores here.',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.play_circle),
                                label: const Text('Play Now'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: scores.length,
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey.withOpacity(0.3),
                          height: 1,
                        ),
                        itemBuilder: (context, index) {
                          final parts = scores[index].split(':');
                          final difficulty = parts[0];
                          final score = int.parse(parts[1]);
                          
                          return ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: index == 0
                                    ? Colors.amber
                                    : index == 1
                                        ? Colors.grey[400]
                                        : index == 2
                                            ? Colors.brown[300]
                                            : Colors.blue[100],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: index < 3 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              'Score: $score',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'Difficulty: ${difficulty[0].toUpperCase()}${difficulty.substring(1)}',
                              style: TextStyle(
                                color: difficulty == 'easy'
                                    ? Colors.green
                                    : difficulty == 'medium'
                                        ? Colors.orange
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                difficulty == 'easy'
                                    ? Icons.star_border
                                    : difficulty == 'medium'
                                        ? Icons.star_half
                                        : Icons.star,
                                color: Colors.amber,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              
              // Button to clear scores
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear Leaderboard?'),
                        content: const Text(
                          'This will remove all your scores. This action cannot be undone.'
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('scores');
                              if (context.mounted) {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LeaderboardScreen(),
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Clear All'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Clear Leaderboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add a cute animated avatar to enhance the app's kiddie appeal
class KidAvatar extends StatefulWidget {
  const KidAvatar({Key? key}) : super(key: key);

  @override
  State<KidAvatar> createState() => _KidAvatarState();
}

class _KidAvatarState extends State<KidAvatar> with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _waveController;
  
  @override
  void initState() {
    super.initState();
    
    // Animation for blinking
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _startBlinking();
    
    // Animation for waving
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      _waveController.repeat(reverse: true);
    });
  }
  
  void _startBlinking() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 2 + Random().nextInt(4)));
      if (mounted) {
        await _blinkController.forward();
        await _blinkController.reverse();
      }
    }
  }
  
  @override
  void dispose() {
    _blinkController.dispose();
    _waveController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      child: Stack(
        children: [
          // Head
          Positioned(
            top: 0,
            left: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.orange[200],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          
          // Eyes
          Positioned(
            top: 20,
            left: 32,
            child: AnimatedBuilder(
              animation: _blinkController,
              builder: (context, child) {
                return Container(
                  width: 10,
                  height: _blinkController.value > 0.5 ? 1 : 10,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 20,
            left: 58,
            child: AnimatedBuilder(
              animation: _blinkController,
              builder: (context, child) {
                return Container(
                  width: 10,
                  height: _blinkController.value > 0.5 ? 1 : 10,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                );
              },
            ),
          ),
          
          // Smile
          Positioned(
            top: 35,
            left: 40,
            child: Container(
              width: 20,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ),
          
          // Body
          Positioned(
            top: 60,
            left: 35,
            child: Container(
              width: 30,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          // Arms
          Positioned(
            top: 65,
            left: 15,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: -0.5 + (_waveController.value * 0.5),
                  origin: const Offset(20, 0),
                  child: Container(
                    width: 25,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 65,
            left: 60,
            child: Container(
              width: 25,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.blue[400],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          
          // Legs
          Positioned(
            top: 100,
            left: 35,
            child: Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 55,
            child: Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Settings page
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _musicEnabled = true;
  bool _vibrationEnabled = true;
  double _animationSpeed = 1.0;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _musicEnabled = prefs.getBool('music_enabled') ?? true;
      _vibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
      _animationSpeed = prefs.getDouble('animation_speed') ?? 1.0;
    });
  }
  
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _soundEnabled);
    await prefs.setBool('music_enabled', _musicEnabled);
    await prefs.setBool('vibration_enabled', _vibrationEnabled);
    await prefs.setDouble('animation_speed', _animationSpeed);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple.withOpacity(0.7)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Settings card
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Game Settings',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Sound toggle
                  SwitchListTile(
                    title: const Text(
                      'Sound Effects',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text('Enable game sounds'),
                    value: _soundEnabled,
                    onChanged: (value) {
                      setState(() {
                        _soundEnabled = value;
                      });
                      _saveSettings();
                    },
                    secondary: const Icon(Icons.volume_up, color: Colors.blue),
                  ),
                  
                  const Divider(),
                  
                  // Music toggle
                  SwitchListTile(
                    title: const Text(
                      'Background Music',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text('Play music while playing'),
                    value: _musicEnabled,
                    onChanged: (value) {
                      setState(() {
                        _musicEnabled = value;
                      });
                      _saveSettings();
                    },
                    secondary: const Icon(Icons.music_note, color: Colors.green),
                  ),
                  
                  const Divider(),
                  
                  // Vibration toggle
                  SwitchListTile(
                    title: const Text(
                      'Vibration',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: const Text('Vibrate on interactions'),
                    value: _vibrationEnabled,
                    onChanged: (value) {
                      setState(() {
                        _vibrationEnabled = value;
                      });
                      _saveSettings();
                    },
                    secondary: const Icon(Icons.vibration, color: Colors.orange),
                  ),
                  
                  const Divider(),
                  
                  // Animation speed slider
                  ListTile(
                    leading: const Icon(Icons.speed, color: Colors.purple),
                    title: const Text(
                      'Animation Speed',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Slider(
                      value: _animationSpeed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 3,
                      label: _animationSpeed == 0.5
                          ? 'Slow'
                          : _animationSpeed == 1.0
                              ? 'Normal'
                              : _animationSpeed == 1.5
                                  ? 'Fast'
                                  : 'Very Fast',
                      onChanged: (value) {
                        setState(() {
                          _animationSpeed = value;
                        });
                      },
                      onChangeEnd: (value) {
                        _saveSettings();
                      },
                      activeColor: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // About section
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.blue),
                    title: const Text('Version'),
                    subtitle: const Text('1.0.0'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text('Rate Us'),
                    subtitle: const Text('Tell us what you think'),
                    onTap: () {
                      // Would launch app store review in a real app
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Rate Us'),
                          content: const Text('Would open app store rating in a real app'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.feedback, color: Colors.green),
                    title: const Text('Send Feedback'),
                    subtitle: const Text('Help us improve'),
                    onTap: () {
                      // Would launch email app in a real app
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Feedback'),
                          content: const Text('Would open email in a real app'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: Colors.red),
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      // Would launch browser in a real app
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Privacy Policy'),
                          content: const Text('Would open privacy policy in browser in a real app'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Reset button
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset All Data?'),
                    content: const Text(
                      'This will reset all your progress, scores, and settings. This action cannot be undone.'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          if (context.mounted) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Reset All'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.restore),
              label: const Text('Reset All Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Footer
            const Center(
              child: Text(
                '© 2025 KidsCrossword\nAll rights reserved',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

