import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

double ballSpeed = 5.0;

class BrickBreakerGame extends StatefulWidget {
  const BrickBreakerGame({Key? key}) : super(key: key);

  @override
  State<BrickBreakerGame> createState() => _BrickBreakerGameState();
}

class _BrickBreakerGameState extends State<BrickBreakerGame> {
  double paddleWidth = 60.0;
  double paddleHeight = 10.0;
  double ballRadius = 10.0;
  late double paddleX;
  double paddleY = 600.0;
  double ballX = 0.0;
  double ballY = 0.0;
  double dx = ballSpeed;
  double dy = -ballSpeed;
  Timer? timer;
  bool gameOver = false;
  int brickRowCount = 10; // 블럭 행의 개수
  int brickColCount = 10; // 블럭 열의 개수
  List<Rect> bricks = [];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 20), (Timer t) {
      if (!gameOver) {
        update();
      }
    });
    startGame();
  }

  void startGame() {
    paddleX = (400 - paddleWidth) / 2;
    ballX = paddleX + paddleWidth / 2;
    ballY = paddleY - ballRadius;
    dx = ballSpeed;
    dy = -ballSpeed;
    gameOver = false;
    generateBricks();
  }

  void generateBricks() {
    bricks.clear();
    for (int row = 0; row < brickRowCount; row++) {
      for (int col = 0; col < brickColCount; col++) {
        double brickWidth = 40.0;
        double brickHeight = 15.0;
        double brickX = col * brickWidth.toDouble() + 5;
        double brickY = row * brickHeight.toDouble() + 5;
        bricks.add(Rect.fromLTWH(brickX, brickY, brickWidth, brickHeight));
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('벽돌 깨기'),
      ),
      body: Builder(builder: (context) {
        // 화면 전체 크기 가져오기
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;

        // 앱바 높이 가져오기
        double appBarHeight =
            Scaffold.of(context).appBarMaxHeight ?? kToolbarHeight;

        // 하단 200의 높이 설정
        double bottomHeight = 200.0;

        // 게임 영역의 높이 계산 (앱바 높이와 하단 200을 빼고 나머지가 게임 높이)
        double gameHeight = screenHeight - appBarHeight - bottomHeight;

        // 넓이와 높이에 대한 비율 계산
        double paddleWidthPercentage = 60 / screenWidth;
        double paddleHeightPercentage = 10 / gameHeight;

        // 화면 크기에 따라 동적으로 계산된 넓이와 높이 설정
        double dynamicPaddleWidth = screenWidth * paddleWidthPercentage;
        double dynamicPaddleHeight = gameHeight * paddleHeightPercentage;

        return Stack(
          children: [
            CustomPaint(
              painter: BrickBreakerPainter(
                paddleX: paddleX,
                paddleY: paddleY,
                paddleWidth: dynamicPaddleWidth,
                paddleHeight: dynamicPaddleHeight,
                ballX: ballX,
                ballY: ballY,
                ballRadius: ballRadius,
                bricks: bricks,
              ),
            ),
            GestureDetector(
              onPanUpdate: (details) {
                if (!gameOver) {
                  startBallMovement();
                }
                updatePaddlePosition(details.delta.dx);
              },
            ),
            if (gameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Game Over',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: startGame,
                      child: const Text('Restart'),
                    ),
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }

  void startBallMovement() {
    if (dx == 0.0 && dy == 0.0) {
      dx = ballSpeed;
      dy = -ballSpeed;
    }
  }

  void updatePaddlePosition(double deltaX) {
    setState(() {
      paddleX += deltaX;
      if (paddleX < 0) paddleX = 0;
      if (paddleX > 400 - paddleWidth) paddleX = 400 - paddleWidth;
    });
  }

  void update() {
    setState(() {
      ballX += dx;
      ballY += dy;

      if (ballX - ballRadius < 0 || ballX + ballRadius > 400) {
        dx = -dx; // 좌우 벽과의 충돌
      }

      if (ballY - ballRadius < 0) {
        dy = -dy; // 상단 벽과의 충돌
      }

      if (ballY + ballRadius >= paddleY &&
          ballX > paddleX &&
          ballX < paddleX + paddleWidth + ballRadius - 5) {
        // 패들과의 충돌
        double relativeIntersectX = ballX - (paddleX + paddleWidth / 2);
        double normalizedRelativeIntersectionX =
            relativeIntersectX / (paddleWidth / 2);

        // 튕기는 각도를 동적으로 계산
        double bounceAngle = normalizedRelativeIntersectionX * (pi / 2.6);

        // 각도의 제한을 두지 않음
        double ballSpeed = sqrt(dx * dx + dy * dy);
        dx = ballSpeed * sin(bounceAngle);
        dy = -ballSpeed * cos(bounceAngle);
      }

      if (ballY + ballRadius > 605) {
        gameOver = true; // 하단 벽과의 충돌
      }

      for (var brick in List.from(bricks)) {
        if (brick.contains(Offset(ballX, ballY))) {
          bricks.remove(brick);
          dy = -dy;
        }
      }

      if (bricks.isEmpty) {
        gameOver = true;
      }
    });
  }
}

class BrickBreakerPainter extends CustomPainter {
  final double paddleX;
  final double paddleY;
  final double paddleWidth;
  final double paddleHeight;
  final double ballX;
  final double ballY;
  final double ballRadius;
  final List<Rect> bricks;

  BrickBreakerPainter({
    required this.paddleX,
    required this.paddleY,
    required this.paddleWidth,
    required this.paddleHeight,
    required this.ballX,
    required this.ballY,
    required this.ballRadius,
    required this.bricks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paddlePaint = Paint()..color = Colors.blue;
    final Rect paddleRect =
        Rect.fromLTWH(paddleX, paddleY, paddleWidth, paddleHeight);
    canvas.drawRect(paddleRect, paddlePaint);

    final Paint ballPaint = Paint()..color = Colors.red;
    final Offset ballOffset = Offset(ballX, ballY);
    canvas.drawCircle(ballOffset, ballRadius, ballPaint);

    final Paint brickPaint = Paint()..color = Colors.green;
    for (var brick in bricks) {
      canvas.drawRect(brick, brickPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
