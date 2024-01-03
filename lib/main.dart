import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  late List<List<String>> board;
  late String currentPlayer;
  String? winner;

  late Timer timer;
  int countdown = 10;

  int player1Wins = 0;
  int player2Wins = 0;
  int drawCount = 0;

  @override
  void initState() {
    super.initState();
    initializeBoard();
    startTimer();
  }

  void initializeBoard() {
    board = List.generate(3, (_) => List<String>.filled(3, ""));
    currentPlayer = "X";
    winner = null;
  }

  void makeMove(int row, int col) {
    if (board[row][col] == "" && winner == null) {
      setState(() {
        board[row][col] = currentPlayer;
        if (checkForWinner(row, col)) {
          winner = currentPlayer;
          updateWinnerCount();
          timer.cancel();
        } else if (isBoardFull()) {
          // Draw
          drawCount++;
          timer.cancel();
        } else {
          currentPlayer = (currentPlayer == "X") ? "O" : "X";
        }
      });
    }
  }

  bool checkForWinner(int row, int col) {
    // Check row
    if (board[row][0] == currentPlayer &&
        board[row][1] == currentPlayer &&
        board[row][2] == currentPlayer) {
      return true;
    }
    // Check column
    if (board[0][col] == currentPlayer &&
        board[1][col] == currentPlayer &&
        board[2][col] == currentPlayer) {
      return true;
    }
    // Check diagonals
    if ((board[0][0] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][2] == currentPlayer) ||
        (board[0][2] == currentPlayer &&
            board[1][1] == currentPlayer &&
            board[2][0] == currentPlayer)) {
      return true;
    }
    return false;
  }

  void resetGame() {
    setState(() {
      initializeBoard();
      startTimer();
    });
  }

  void startTimer() {
    countdown = 10;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown <= 0) {
          timer.cancel();
        } else {
          countdown--;
        }
      });
    });
  }

  bool isBoardFull() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == "") {
          return false;
        }
      }
    }
    return true;
  }

  void updateWinnerCount() {
    if (winner == "X") {
      player1Wins++;
    } else if (winner == "O") {
      player2Wins++;
    }
  }

  Widget buildTile(int row, int col) {
    return GestureDetector(
      onTap: () => makeMove(row, col),
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            board[row][col],
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ),
    );
  }

  Color getTextColor() {
    if (countdown > 5) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              (winner != null) ? '$winner wins!' : 'Player: $currentPlayer',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Time remaining: $countdown seconds',
              style: TextStyle(fontSize: 20.0, color: getTextColor()),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star, color: Colors.blue),
                Text(
                  'Player 1 Wins: $player1Wins',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star, color: Colors.red),
                Text(
                  'Player 2 Wins: $player2Wins',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.star, color: Colors.grey),
                Text(
                  'Draws: $drawCount',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Column(
              children: List.generate(
                3,
                (row) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (col) => buildTile(row, col),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: resetGame,
              child: Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}
