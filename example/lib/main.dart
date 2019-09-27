import 'package:day_night_switch/day_night_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]).then((_) {
    runApp(MyApp());
  });
}

const dayColor = Color(0xFFd56352);
var nightColor = Color(0xFF1e2230);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day Night Switch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var val = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF414a4c),
      body: AnimatedContainer(
        color: val ? nightColor : dayColor,
        duration: Duration(milliseconds: 300),
        child: Stack(
          children: <Widget>[
            buildStar(top: 100, left: 40, val: val),
            buildStar(top: 200, left: 80, val: val),
            buildStar(top: 300, left: 10, val: val),
            buildStar(top: 500, left: 100, val: val),
            buildStar(top: 300, right: 40, val: val),
            buildStar(top: 250, right: 100, val: val),
            buildStar(top: 450, right: 80, val: val),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              height: 200,
              child: Opacity(
                opacity: val ? 0 : 1.0,
                child: Image.asset(
                  'assets/cloud.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              height: 200,
              child: Image.asset(
                val ? 'assets/mountain2_night.png' : 'assets/mountain2.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: -10,
              left: 0,
              right: 0,
              height: 140,
              child: Image.asset(
                val ? 'assets/mountain_night.png' : 'assets/mountain1.png',
                fit: BoxFit.cover,
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: -20,
                      right: 0,
                      left: 0,
                      child: Transform.translate(
                        offset: Offset(50 * _controller.value, 0),
                        child: Opacity(
                          opacity: val ? 0.0 : 0.8,
                          child: Image.asset(
                            'assets/cloud2.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      right: 0,
                      left: 0,
                      child: Transform.translate(
                        offset: Offset(100 * _controller.value, 0),
                        child: Opacity(
                          opacity: val ? 0.0 : 0.4,
                          child: Image.asset(
                            'assets/cloud3.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Center(
              child: DayNightSwitch(
                value: val,
                moonImage: AssetImage('assets/moon.png'),
                onChanged: (value) {
                  setState(() {
                    val = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Transform.translate(
        offset: Offset(140, 40),
        child: _buildFab(),
      ),
    );
  }

  Widget _buildFab() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(400 * _controller.value),
            _buildContainer(500 * _controller.value),
            _buildContainer(600 * _controller.value),
            Center(
              child: SizedBox(
                width: 256,
                height: 256,
                child: val
                    ? Image.asset('assets/moon.png')
                    : CircleAvatar(
                        backgroundColor: const Color(0xFFFDB813),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (val ? Colors.amber[100] : Colors.orangeAccent)
            .withOpacity(1 - _controller.value),
      ),
    );
  }

  buildStar({double top, double left, double right, bool val}) {
    return Positioned(
      top: top,
      right: right,
      left: left,
      child: Opacity(
        opacity: val ? 1 : 0,
        child: CircleAvatar(
          radius: 2,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
