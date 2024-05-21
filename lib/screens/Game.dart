import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameScreen extends StatefulWidget {
  final String player1;
  final String player2;

  GameScreen({required this.player1, required this.player2});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> _board = List.filled(9, '');
  String _currentPlayer = 'O';
  String _winner = '';

  String get WinnerName {
    return _winner == 'O' ? widget.player1 : widget.player2;
  }

  String get currentPlayerName {
    return _currentPlayer == 'O' ? widget.player1 : widget.player2;
  }

  void _handleTap(int index) {
    if (_board[index] == '' && _winner == '') {
      _performTapOperation(index);
    }
  }

  Future<void> _performTapOperation(int index) async {
    _board[index] = _currentPlayer;
    _currentPlayer = _currentPlayer == 'O' ? 'X' : 'O';
    _winner = _checkWinner();

    if (_winner.isNotEmpty && _winner != 'Draw') {
      await _recordWin();
    }

    setState(() {
      // 在这里更新状态
    });
  }

  String _checkWinner() {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var line in lines) {
      if (_board[line[0]] != '' &&
          _board[line[0]] == _board[line[1]] &&
          _board[line[1]] == _board[line[2]]) {
        return _board[line[0]];
      }
    }
    return _board.contains('') ? '' : 'Draw';
  }

  Future<void> _recordWin() async {
    final winnerId = _winner == 'O' ? widget.player1 : widget.player2;

    // 发起 GET 请求来检查是否存在对应的玩家
    final playerResponse = await http.get(
      Uri.parse('https://dart-leaderboard-rdchfzm4oa-ey.a.run.app/api/players/$winnerId'),
    );

    if (playerResponse.statusCode == 200) {
      // 玩家已经存在，直接记录胜利
      await _recordWinForPlayer(winnerId);
    } else if (playerResponse.statusCode == 404) {
      // 玩家不存在，需要先创建玩家然后记录胜利
      await _createPlayerAndRecordWin(winnerId);
    } else {
      throw Exception('Failed to check player existence');
    }
  }

  Future<void> _recordWinForPlayer(String playerId) async {
    // 发起 POST 请求来记录胜利
    final response = await http.post(
      Uri.parse('https://dart-leaderboard-rdchfzm4oa-ey.a.run.app/api/players/$playerId/score/win'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to record win');
    }
  }

  Future<void> _createPlayerAndRecordWin(String playerId) async {
    // 发起 POST 请求来创建新玩家
    final createPlayerResponse = await http.post(
      Uri.parse('https://dart-leaderboard-rdchfzm4oa-ey.a.run.app/api/players'),
      body: json.encode({'id': playerId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (createPlayerResponse.statusCode == 200) {
      // 创建成功后记录胜利
      await _recordWinForPlayer(playerId);
    } else {
      throw Exception('Failed to create player');
    }
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _currentPlayer = 'O';
      _winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _winner.isEmpty
                    ? 'Current Player: $currentPlayerName'
                    : _winner == 'Draw'
                    ? 'It\'s a Draw!'
                    : 'Winner: $WinnerName',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 20),
              _buildBoard(),
              if (_winner.isNotEmpty)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _resetGame,
                      child: Text('Play Again'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back to Home'),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoard() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _handleTap(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.white.withOpacity(0.2), // 修改棋盘颜色及透明度
            ),
            child: Center(
              child: Text(
                _board[index],
                style: TextStyle(fontSize: 48, color: Colors.yellowAccent),
              ),
            ),
          ),
        );
      },
    );
  }
}
