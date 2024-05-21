import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/Game.dart';
import 'package:tic_tac_toe/main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _player1 = '';
  String _player2 = '';

  void _startGame() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameScreen(player1: _player1, player2: _player2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'), // 设置背景图像
            fit: BoxFit.cover, // 让图像铺满整个容器
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Tic Tac Toe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36, // 设置字体大小为36
                  fontWeight: FontWeight.bold, // 设置为粗体
                  fontFamily: 'Roboto', // 设置字体样式为Roboto
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      style: TextStyle(color: Colors.white), // 设置文字颜色为白色
                      decoration: InputDecoration(
                        labelText: 'Player 1 Name :',
                        labelStyle: TextStyle(color: Colors.white,fontSize: 20), // 设置标签文字颜色为白色
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Player 1 name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _player1 = value!;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: Colors.white), // 设置文字颜色为白色
                      decoration: InputDecoration(
                        labelText: 'Player 2 Name :',
                        labelStyle: TextStyle(color: Colors.white,fontSize: 20), // 设置标签文字颜色为白色
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Player 2 name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _player2 = value!;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startGame,
                      child: Text('Start Game'),
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
}
