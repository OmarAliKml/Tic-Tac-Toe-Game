# Modern Tic Tac Toe 🎮

A sleek and modern Tic Tac Toe game built with Flutter, featuring smooth animations, AI opponent, and local multiplayer.

## ✨ Features

- 🎯 Single Player vs AI
- 👥 Local Two Player Mode
- 🎨 Modern UI with Gradients
- 🌟 Smooth Animations
- 📱 Responsive Design
- 🏆 Score Tracking
- 🔄 Quick Game Reset
- 📊 Game Statistics

## 🚀 Getting Started

### Prerequisites
- Flutter (latest version)
- Dart SDK
- Android Studio / VS Code

### Installation
```bash
# Clone repository
git clone https://github.com/yourusername/modern_tictactoe.git

# Navigate to project
cd modern_tictactoe

# Install dependencies
flutter pub get

# Run app
flutter run
📁 Project Structure

Copy
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   └── game_screen.dart
└── widgets/
    └── game_board.dart
🎮 How to Play
Choose game mode (1P or 2P)
Player X starts first
Tap empty cells to place marks
Get three in a row to win
Use 'New Game' to restart
💻 Code Example
dart

Copy
Widget buildGameBoard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossCount: 3,
        spacing: 10,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return buildCell(index ~/ 3, index % 3);
      },
    ),
  );
}
🎯 Future Updates
Online Multiplayer
Different AI Difficulties
Custom Themes
Sound Effects
Achievement System
🤝 Contributing
Fork the Project
Create Feature Branch (git checkout -b feature/NewFeature)
Commit Changes (git commit -m 'Add NewFeature')
Push to Branch (git push origin feature/NewFeature)
Open Pull Request
📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

👨‍💻 Author
Your Name

GitHub: @yourusername
Email: your.email@example.com
🌟 Acknowledgments
Flutter Documentation
Dart Documentation
Modern UI/UX Principles
💡 Support
For support or queries:

Create an issue
Email: support@example.com
<p align="center">

Made with ❤️ using Flutter

</p>

```
