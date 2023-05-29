import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';
import 'package:flutter_webrtc_example/src/history/data/models/history.dart';
import 'package:intl/intl.dart';

@RoutePage()
class HistoryScreen extends StatelessWidget {
  final histories = <History>[
    History(
      callerId: 'asasaa',
      callerName: 'John Doe',
      callTime: DateTime.now(),
    ),
    History(
      callerId: 'asasaa',
      callerName: 'John Doe',
      callTime: DateTime.now(),
    ),
    History(
      callerId: 'asasaa',
      callerName: 'John Doe',
      callTime: DateTime(2023, 3, 1),
    ),
    History(
      callerId: 'asasaa',
      callerName: 'John Doe',
      callTime: DateTime(2023, 1, 1),
    ),
    History(
      callerId: 'asasaa',
      callerName: 'John Doe',
      callTime: DateTime.now(),
    ),
    History(
      callerId: 'asasaa',
      callerName: 'John Doe old',
      callTime: DateTime(2022, 1, 1),
    ),
  ];

  HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: _sortHistoriesByDays(histories).map((historiesByDays) {
            return Column(children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  DateFormat('dd-MM-yyyy | EEEE')
                      .format(historiesByDays.first.callTime),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ...historiesByDays.map(
                (h) => Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: _HistoryItem(h),
                ),
              )
            ]);
          }).toList(),
        ),
      ),
    );
  }

  // TODO fix sort
  List<List<History>> _sortHistoriesByDays(List<History> histories) {
    final List<List<History>> historiesByDays = [];

    if (histories.isNotEmpty) {
      histories.sort((a, b) {
        return a.callTime.compareTo(b.callTime);
      });

      var lastDay = histories.first.callTime.millisecondsSinceEpoch ~/
          1000 /
          60 /
          60 /
          24;
      int currentIndex = 0;

      for (var i = 0; i < histories.length; i++) {
        final currentDay =
            histories[i].callTime.millisecondsSinceEpoch ~/ 1000 / 60 / 60 / 24;
        if (currentDay != lastDay) {
          historiesByDays.add(histories.sublist(currentIndex, i + 1));

          currentIndex = i;
          lastDay = histories[i].callTime.millisecondsSinceEpoch ~/
              1000 /
              60 /
              60 /
              24;
        }
      }

      historiesByDays.add(histories.sublist(currentIndex, histories.length));
    }

    return historiesByDays;
  }
}

class _HistoryItem extends StatelessWidget {
  final History _history;

  const _HistoryItem(this._history);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 10, right: 10),
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.cancel_outlined,
                color: CustomColors.background.withOpacity(0.8),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _history.callerName,
                  style: TextStyle(
                    color: CustomColors.background,
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  DateFormat('hh:mm dd MMMM').format(_history.callTime),
                  style: TextStyle(
                    color: CustomColors.background,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10, bottom: 10),
            alignment: Alignment.bottomRight,
            child: Text(
              'ID: ' + _history.callerId,
              style: TextStyle(
                color: CustomColors.secondary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}