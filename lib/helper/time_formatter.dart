/*

    time stamp 


    e.g 2024-07-24  14:30

 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimeStamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
}
