import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stay_on_track/util/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //overall habit summary/list
  List habitList = [
    //[habitName , habitStarted, timeSpent(sec), timeGoal(min)]
    ['Code', false, 0, 60],
    ['Exercise', false, 0, 30],
    ['Stretch', false, 0, 10],
    ['Create Content', false, 0, 2],
  ];
  void habitStarted(int index) {
    //note what the start time is
    var startTime = DateTime.now();
    //print(startTime.second);

    //include the time already elapsed
    int elapsedTime = habitList[index][2];
    //habit started or stopped
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    //keep the time going!
    if (habitList[index][1] == true) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        //Check when user has stopped the timer
        setState(() {
          if (!habitList[index][1]) {
            timer.cancel();
          }

          //calculate time elapsed by comparing current time and start time
          var currentTime = DateTime.now();
          habitList[index][2] = elapsedTime +
              currentTime.second -
              startTime.second +
              60 * (currentTime.minute - startTime.minute) +
              60 * 60 * (currentTime.hour - startTime.hour);
        });

        // setState(() {
        //   habitList[index][2]++;
        // });
      });
    }
  }

  void settingsOpened(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Settings for' + habitList[index][0]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Consistency is the key.'),
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: ((context, index) {
          return HabitTile(
            habitName: habitList[index][0],
            onTap: () {
              habitStarted(index);
            },
            settingsTapped: () {
              settingsOpened(index);
            },
            habitStarted: habitList[index][1],
            timeSpent: habitList[index][2],
            timeGoal: habitList[index][3],
          );
        }),
      ),
    );
  }
}
