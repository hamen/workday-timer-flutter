import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Timers',
      theme:
          ThemeData(primaryColor: Colors.red, primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pomodoro Timers'),
        ),
        body: PomodoroTimer(),
      ),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  State<StatefulWidget> createState() => PomodoroTimerState();
}

class PomodoroTimerState extends State {
  static const String _startButtonLabel = "Start";
  static const String _stopButtonLabel = "Stop";
  static const String _pomodoro = "25:00";

  String _remainingTime = _pomodoro;
  String _buttonLabel = _startButtonLabel;
  double _remainingTimeIndicator = 0.0;

  StreamSubscription streamSubscription;

  startTimer() {
    streamSubscription = Stream.periodic(Duration(seconds: 1), (x) => x).take(1500).listen((elapsedSeconds) {
      setState(() {
        _buttonLabel = _stopButtonLabel;

        final remainingTime = 1500 - elapsedSeconds;
        var formattedTime = formatRemainingTime(Duration(seconds: remainingTime));
        _remainingTime = formattedTime;

        _remainingTimeIndicator = elapsedSeconds / 1500;

      });
    });
  }

  void stopTimer() {
    streamSubscription.cancel();
    setState(() {
      _buttonLabel = _startButtonLabel;
      _remainingTime = _pomodoro;
      _remainingTimeIndicator = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "POMODORO TIMER",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('A 25 minutes timer'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _remainingTime,
                style: TextStyle(fontSize: 40),
              ),
            ),
            LinearProgressIndicator(
              value: _remainingTimeIndicator,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              backgroundColor: Colors.cyan.shade200,
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(_buttonLabel),
                  onPressed: () {
                    if (_buttonLabel == _startButtonLabel)
                      startTimer();
                    else
                      stopTimer();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String formatRemainingTime(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
