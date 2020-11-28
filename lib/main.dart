import 'package:bloom/blocks/homepage.dart';
import 'package:bloom/radial_progress.dart';
import 'package:bloom/themes/colors.dart';
import 'package:bloom/date_utils.dart';
import 'package:bloom/topbar.dart';
import 'package:bloom/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLOOM',
      theme: appTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  HomePageBloc _homePageBloc;

  @override
  void initState() {
    _homePageBloc = HomePageBloc();
    _iconAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _homePageBloc.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Topbar(),
                  Positioned(
                    top: 60.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.blue,
                            size: 35.0,
                          ),
                          onPressed: () {
                            _homePageBloc.subtractDate();
                          },
                        ),
                        StreamBuilder(
                          stream: _homePageBloc.dateStream,
                          initialData: _homePageBloc.selectedDate,
                          builder: (context, snapshot) {
                            return Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    formatterDayOfWeek.format(snapshot.data),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0,
                                        color: Colors.white,
                                        letterSpacing: 1.2),
                                  ),
                                  Text(
                                    formatterDate.format(snapshot.data),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      letterSpacing: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Transform.rotate(
                          angle: 135.0,
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            onPressed: () {
                              _homePageBloc.addDate();
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              RadialProgress(),
              DailyStatusListing()
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 4.0)),
              child: IconButton(
                  icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      color: Colors.red,
                      progress: _iconAnimationController.view),
                  onPressed: () {
                    onIconPressed();
                  }),
            ),
          )
        ],
      ),
    );
  }

  void onIconPressed() {
    animationStatus
        ? _iconAnimationController.reverse()
        : _iconAnimationController.forward();
  }

  bool get animationStatus {
    final AnimationStatus status = _iconAnimationController.status;
    return status == AnimationStatus.completed;
  }
}

class DailyStatusListing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              DailyStatusRow('15th November', 'Completed'),
              DailyStatusRow('16th November', 'On-going'),
              DailyStatusRow('17th November', 'Upcoming'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              DailyTargetRow('drink 7-8 glass of water', 'atleast 5l'),
              DailyTargetRow('Run for 10m ', '5 rounds of park'),
              DailyTargetRow('Avg steps Per day', '10000/10000'),
            ],
          ),
        ],
      ),
    );
  }
}

class DailyStatusRow extends StatelessWidget {
  final String dailyMonth, status;

  DailyStatusRow(this.dailyMonth, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            dailyMonth,
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          Text(
            status,
            style: TextStyle(
                color: Colors.black,
                fontStyle: FontStyle.italic,
                fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class DailyTargetRow extends StatelessWidget {
  final String target, targetAchieved;

  DailyTargetRow(this.target, this.targetAchieved);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            target,
            style: TextStyle(color: Colors.white10, fontSize: 16.0),
          ),
          Text(
            targetAchieved,
            style: TextStyle(color: Colors.green, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
