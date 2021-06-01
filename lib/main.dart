import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        accentColor: Colors.deepOrangeAccent,
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _table = List<String>.filled(9, '');
  List<Color> _colors = List<Color>.filled(9, Colors.white);

  String? _player = 'x';

  void _tapped(int index) {
    setState(() {
      if (_table[index] == '') {
        _table[index] = _player!;
        _colors[index] = _player == 'x' ? Theme.of(context).primaryColor : Theme.of(context).accentColor;
      }
      //switch players
      _player = _player == 'x' ? _player = '0' : _player = 'x';
    });
  }

  //optimized checker for win state
  bool _checkWin(int index) {
    final int row = index ~/ 3;
    final int col = index % 3;
    if (index % 2 != 0) {
      if (_table[3 * row] == _table[3 * row + 1] && _table[3 * row + 1] == _table[3 * row + 2]) {
        return true;
      } else if (_table[3 * 0 + col] == _table[3 * 1 + col] && _table[3 * 1 + col] == _table[3 * 2 + col]) {
        return true;
      }
    } else {
      if (_table[3 * row] == _table[3 * row + 1] && _table[3 * row + 1] == _table[3 * row + 2]) {
        return true;
      } else if (_table[3 * 0 + col] == _table[3 * 1 + col] && _table[3 * 1 + col] == _table[3 * 2 + col]) {
        return true;
      } else if (index == 0 || index == 4 || index == 8) {
        if (_table[0] == _table[4] && _table[4] == _table[8]) {
          return true;
        }
      } else if (index == 2 || index == 4 || index == 6) {
        if (_table[2] == _table[4] && _table[4] == _table[6]) {
          return true;
        }
      }
    }
    return false;
  }

  bool _tableIsFull() {
    int count = 0;
    for (int i = 0; i < 9; i++) {
      if (_table[i] != '') {
        count++;
      }
    }
    return count == 9 && true;
  }

  void _showWinDialog(String winner) {
    winner = _player == 'x' ? '0' : 'x';
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Winner is: $winner'),
          );
        });
  }

  void _showDrawDialog() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('DRAW !'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TicTacToe'),
        centerTitle: true,
        elevation: 6.0,
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: <Widget>[
          for (int i = 0; i < 9; i++)
            InkWell(
              onTap: () {
                setState(() {
                  _tapped(i);
                  if (_checkWin(i)) {
                    _showWinDialog(_player!);
                    _table = List<String>.filled(9, '');
                    _colors = List<Color>.filled(9, Colors.white);
                    _player = 'x';
                  } else if (!_checkWin(i) && _tableIsFull()) {
                    _showDrawDialog();
                    _table = List<String>.filled(9, '');
                    _colors = List<Color>.filled(9, Colors.white);
                    _player = 'x';
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: _colors[i],
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Center(
                  child: Text(
                    _table[i],
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
