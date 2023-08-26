import 'dart:convert';

import 'package:flutter/material.dart';

import '../utility/app_urls.dart';
import 'package:http/http.dart' as http;

class JobData with ChangeNotifier{
  JobData({
    required this.jobId,
    required this.expectedDeliveryDate,
    required this.isCompleted,
    required this.name,
    required this.startTime,
    List<String>? progressImagesUrl,
    List<Timestamp>? timestamps,
  }):  timestamps = timestamps ?? [], progressImagesUrl = progressImagesUrl ?? [];

  final String jobId;
  final String name;
  final DateTime? startTime;
  final DateTime? expectedDeliveryDate;
  final bool? isCompleted;
  List<String> progressImagesUrl;
  List<Timestamp> timestamps;

  factory JobData.fromJson(Map<String, dynamic> json, String jobID){
    print(json);
    return JobData(
        jobId: jobID,
        expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
        isCompleted: json["isCompleted"],
        name: json["name"],
        startTime: DateTime.tryParse(json["startTime"] ?? ""),
        progressImagesUrl: json["progressImagesUrl"] == null ? [] : List<String>.from(json["progressImagesUrl"]!.map((x) => x)),
        timestamps: json["timestamps"] == null ? [] : List<Timestamp>.from(json["timestamps"]!.map((x) => Timestamp.fromJson(x))),
    );
  }

  Future<void> addStartTime() async {
    // timestamps.isNotEmpty ? print('addstarttime: ${timestamps.last.endTime}') : print('');
    if(timestamps.isNotEmpty && timestamps.last.endTime == timestamps.last.startTime){
      print("error");
      throw Exception("Provide end time first");
    }
    print("added start time");
    final url = '${AppUrl.pendingProducts}/$jobId.json';
    DateTime currentTime = DateTime.now();
    try {
      List<Timestamp> newTimestamp = timestamps;
      newTimestamp.add(Timestamp(endTime: currentTime, startTime: currentTime));
      await http.patch(Uri.parse(url), body: json.encode({
        'timeStamps': newTimestamp,
      }));
      timestamps.add(Timestamp(endTime: currentTime, startTime: currentTime));
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> addEndTime() async{
    if(timestamps.isEmpty || timestamps.last.endTime != timestamps.last.startTime){
      throw Exception("Provide start time first");
    }
    print("added end time");
    final url = '${AppUrl.pendingProducts}/$jobId.json';
    DateTime currentTime = DateTime.now();
    try {
      List<Timestamp> newTimestamps = timestamps;
      newTimestamps.last.endTime = currentTime;
      await http.put(Uri.parse(url), body: json.encode({
        'timeStamps': newTimestamps,
      }));
      timestamps.last.endTime = currentTime;
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

}

class Timestamp {
  Timestamp({
    required this.endTime,
    required this.startTime,
  });

  DateTime? endTime;
  final DateTime? startTime;

  factory Timestamp.fromJson(Map<String, dynamic> json){
    return Timestamp(
      endTime: DateTime.tryParse(json["endTime"] ?? ""),
      startTime: DateTime.tryParse(json["startTime"] ?? ""),
    );
  }

}
