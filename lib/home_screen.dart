import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = 'Let\'s Play!';
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,

        body: SafeArea(
          child: Column(
            children: [
              SwitchListTile.adaptive(
                title: const Text(
                  'Friend Mood',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
                activeColor: Colors.lightGreenAccent,
                activeTrackColor: Colors.green[700],
                inactiveTrackColor: Colors.blueGrey,
                inactiveThumbColor: Colors.white,
                value: isSwitched,
                onChanged: (bool newValue) {
                  setState(() {
                    isSwitched = newValue;
                  });
                },
              ),
              const Divider(color: Colors.white,thickness: 2,height: 5),
              const SizedBox(
                height: 20,
              ),
              Text(
                'current player : $activePlayer'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: GridView.count(
                  padding: EdgeInsets.all(20),
                  crossAxisCount: 3,
                  mainAxisSpacing: 40.0,
                  crossAxisSpacing: 15.0,
                  childAspectRatio: 0.8,
                  children: List.generate(
                    9,
                    (index) => InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: gameOver ? null : () => _onTap(index),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).shadowColor,
                        ),
                        child: Text(
                          Player.playerX.contains(index)
                              ? 'X'
                              : Player.playerO.contains(index)
                                  ? 'O'
                                  : '',
                          style: TextStyle(
                            color: Player.playerX.contains(index)
                                ? Colors.green
                                : Colors.red,
                            fontSize: 60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '$result'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.all(20),
                height: 50,
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      Player.playerX = [];
                      Player.playerO = [];
                      activePlayer = 'X';
                      gameOver = false;
                      turn = 0;
                      result = 'Let\'s Play again';
                    });
                  },
                  icon: Icon(Icons.replay, size: 25),
                  label:
                      Text('Restart The Game', style: TextStyle(fontSize: 20)),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.orange)),
                ),
              )
            ],
          ),
        ));
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      Game.playGame(index, activePlayer);
      updateState();
    }
     if (!isSwitched && !gameOver&&turn!=9) {

      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  void updateState() {
    setState(
      () {
        activePlayer = (activePlayer == 'X') ? 'O' : 'X';
        turn++;
        String theWinner = game.checkWinner();
        if (theWinner != '') {
          gameOver=true;
          result = 'the winner is : $theWinner';
        } else if(!gameOver&&turn==9){
          result = 'it\'s Draw!';
        }
      },
    );
  }
}
