import 'package:flutter_webrtc_example/src/auth/data/models/user.dart';
import 'package:intl/intl.dart';

class History {
  final String callerId;
  final String callerName;
  final DateTime callTime;
  final bool isIncomingCall;

  const History({
    required this.callerId,
    required this.callerName,
    required this.callTime,
    required this.isIncomingCall,
  });

  static const _delim = ',';

  factory History.fromUser(
    User user, {
    required bool isIncomingCall,
  }) {
    return History(
      callerId: user.id,
      callerName: user.name,
      callTime: DateTime.now(),
      isIncomingCall: isIncomingCall,
    );
  }

  factory History.fromString(String s) {
    final parts = s.split(_delim);
    return History(
      callerId: parts[0],
      callerName: parts[1],
      callTime: _dateTimeFromString(parts[2]),
      isIncomingCall: parts[3] == 'true',
    );
  }

  @override
  String toString() {
    return callerId +
        _delim +
        callerName +
        _delim +
        _historyDateTimeToString(callTime) +
        _delim +
        isIncomingCall.toString();
  }

  static String _historyDateTimeToString(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy hh:mm:ss').format(
      dateTime,
    );
  }

  static DateTime _dateTimeFromString(String dateTime) {
    return DateFormat('dd-MM-yyyy hh:mm:ss').parse(
      dateTime,
    );
  }
}
