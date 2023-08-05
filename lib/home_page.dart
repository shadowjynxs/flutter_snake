import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_2d/blank_pixel.dart';
import 'package:snake_2d/food_pixel.dart';
import 'package:snake_2d/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SnakeDirection { up, down, left, right }

class _HomePageState extends State<HomePage> {
  bool gameHasStarted = false;
  //grid dimensions

  int rowSize = 20;
  static int totalNumberofSquares = 580;

  //user score
  int currentScore = 0;

  //barriers
  List<int> rightBarriersPos = [
    19,
    39,
    59,
    79,
    99,
    119,
    139,
    159,
    179,
    199,
    219,
    239,
    259,
    279,
    299,
    319,
    339,
    359,
    379,
    399,
    419,
    439,
    459,
    479,
    499,
    519,
    539,
    559,
    579,
  ];

  List<int> leftBarrierPos = [
    0,
    20,
    40,
    60,
    80,
    100,
    120,
    140,
    160,
    180,
    200,
    220,
    240,
    260,
    280,
    300,
    320,
    340,
    360,
    380,
    400,
    420,
    440,
    460,
    480,
    500,
    520,
    540,
    570,
  ];

  List<int> topBarrierPos = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19
  ];
  List<int> bottomBarrierPos = [
    560,
    561,
    562,
    563,
    564,
    565,
    566,
    567,
    568,
    569,
    570,
    571,
    572,
    573,
    574,
    575,
    576,
    588,
    578,
    579,
  ];

  //snake position

  List<int> snakePos = [283, 284, 285, 286, 287];

  //snake  direction is initially to the right
  var currentDirection = SnakeDirection.right;

  //food position

  int foodPos = Random().nextInt(totalNumberofSquares);

  //start game

  bool gameOver() {
    //the game is over when the snake runs into itself
    //this occurs when there is a duplicate position in the snakePos list

    //this list is the body of the snake (no head)
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }

    return false;
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        //move the snake
        moveSnake();

        //check if the game is over
        if (gameOver()) {
          timer.cancel();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: const Text("Game Over"),
                content: Text(
                  "Your score is: ${currentScore.toString()}",
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    color: Colors.pink,
                    child: const Text("Quit"),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      newGame();
                    },
                    color: Colors.pink,
                    child: const Text("Play Again"),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  void eatFood() {
    currentScore++;
    //making sure the new food is not where the snake is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberofSquares);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case SnakeDirection.right:
        {
          //add a new head
          //if snake is at the right wall, need to readjust
          if (rightBarriersPos.contains(snakePos.last)) {
            //add a new head
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;
      case SnakeDirection.left:
        {
          //add a new head
          //if snake is at the right wall, need to readjust
          if (leftBarrierPos.contains(snakePos.last)) {
            //add a new head
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;
      case SnakeDirection.up:
        {
          //add a new head
          //if snake is at the right wall, need to readjust
          if (snakePos.last < rowSize) {
            //add a new head
            snakePos.add(snakePos.last - rowSize + totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      case SnakeDirection.down:
        {
          //add a new head
          //if snake is at the right wall, need to readjust
          if (snakePos.last + rowSize > totalNumberofSquares) {
            //add a new head
            snakePos.add(snakePos.last + rowSize - totalNumberofSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;
      default:
    }

    //snake is eating food
    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      //remove the tail
      snakePos.removeAt(0);
    }
  }

  void newGame() {
    setState(() {
      snakePos = [283, 284, 285, 286, 287];
      foodPos = Random().nextInt(totalNumberofSquares);
      currentDirection = SnakeDirection.right;
      currentScore = 0;
      gameHasStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          //high scores
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  "Current Score : $currentScore",
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
          ),

          //grid
          Expanded(
            flex: 5,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 &&
                    currentDirection != SnakeDirection.up) {
                  currentDirection = SnakeDirection.down;
                } else if (details.delta.dy < 0 &&
                    currentDirection != SnakeDirection.down) {
                  currentDirection = SnakeDirection.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 &&
                    currentDirection != SnakeDirection.left) {
                  currentDirection = SnakeDirection.right;
                } else if (details.delta.dx < 0 &&
                    currentDirection != SnakeDirection.right) {
                  currentDirection = SnakeDirection.left;
                }
              },
              child: GridView.builder(
                  itemCount: totalNumberofSquares,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: rowSize),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index)) {
                      return const SnakePixel();
                    } else if (foodPos == index) {
                      return const FoodPixel();
                    } else {
                      return const BlankPixel();
                    }
                    // return Text(
                    //   index.toString(),
                    //   style: TextStyle(fontSize: 10),
                    // );
                  }),
            ),
          ),

          //play button
          Expanded(
            child: Center(
              child: MaterialButton(
                onPressed: () {
                  gameHasStarted ? () {} : startGame();
                },
                color: gameHasStarted ? Colors.grey : Colors.pink,
                child: const Text("PLAY"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
