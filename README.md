# 🧩 Kids Crossword - Flutter Project

## 📌 Overview  
**Kids Crossword** is an interactive crossword puzzle game designed for children, built with Flutter. It features colorful animations, sound effects, and three difficulty levels to make learning fun and engaging. The game helps kids improve their vocabulary and problem-solving skills while having fun.

---

## ✨ Features

- **Three Difficulty Levels:** Easy, Medium, and Hard with kid-friendly clues  
- **Interactive Gameplay:** Tap cells to select and type answers  
- **Hints System:** Get help when stuck (limited hints available)  
- **Timer & Scoring:** Complete puzzles quickly for higher scores  
- **Leaderboard:** Track top scores for each difficulty  
- **Animations & Sound Effects:** Confetti celebration, button clicks, and more  
- **Kid-Friendly UI:** Bright colors, playful fonts, and intuitive controls  
- **How to Play Guide:** Simple instructions for new players  

---

## 🛠️ Technical Details

- **Built With:** Flutter  
- **State Management:** `setState` for local state management  
- **Animations:** Uses Flutter’s built-in animation controllers  
- **Audio:** `audioplayers` for sound effects  
- **Persistence:** `shared_preferences` for saving scores  

### 🔑 Key Dependencies

- `audioplayers`: For sound effects  
- `shared_preferences`: For saving high scores  
- `confetti`: For celebration effects  
- `flutter/services`: For keyboard input handling  

---

## 📱 Screens

- **Splash Screen:** Animated intro with app logo  
- **Home Screen:**  
  - Play button (select difficulty)  
  - Leaderboard  
  - How to Play guide  
- **Game Screen:**  
  - Interactive crossword grid  
  - Clue display  
  - Timer & hints counter  
- **Leaderboard:** Shows top scores per difficulty  
- **Settings:** *(Placeholder for future features)*  

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)  
- Android Studio / VS Code with Flutter plugin  

### Installation

Clone the repository:

```bash
git clone https://github.com/your-username/kids-crossword.git
```

Navigate to the project directory:

```bash
cd kids-crossword
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

---

## 📂 Project Structure

```
lib/
├── main.dart               # App entry point
├── screens/
│   ├── splash_screen.dart  # Animated intro
│   ├── home_screen.dart    # Main menu
│   ├── game_screen.dart    # Crossword gameplay
│   └── leaderboard.dart    # High scores
├── models/
│   ├── crossword_data.dart # Puzzle data structure
│   └── clue_model.dart     # Clue definitions
└── widgets/
    ├── animated_button.dart # Custom buttons
    └── crossword_grid.dart  # Interactive grid UI
```

---

## 📝 How to Play

1. Select a difficulty (Easy, Medium, Hard)  
2. Tap a cell to select it and see the clue  
3. Type letters to fill in answers  
4. Use hints if stuck (limited hints available)  
5. Complete the puzzle before time runs out!  
6. Check the leaderboard to see your high scores  

---

## 🏆 Scoring System

- **Base Score:**  
  - Easy: 100  
  - Medium: 200  
  - Hard: 300  
- **Time Bonus:** Extra points for finishing quickly  
- **Hint Penalty:** Using hints reduces your score  

---

## 📧 Contact

For questions or feedback, please contact:  
📬 **msgpersonaltech@gmail.com**
