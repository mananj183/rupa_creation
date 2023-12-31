import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rupa_creation/firebase/firebase_api.dart';

import '../utility/app_urls.dart';
import 'package:http/http.dart' as http;

class JobData with ChangeNotifier{

  final String jobId;
  final String title;
  final DateTime? startTime;
  DateTime? expectedDeliveryDate;
  bool isComplete;
  List<String> progressImagesUrl;
  List<Timestamp> timestamps;

  JobData({
    required this.jobId,
    required this.expectedDeliveryDate,
    required this.title,
    required this.startTime,
    this.isComplete = false,
    List<String>? progressImagesUrl,
    List<Timestamp>? timestamps,
  }):  timestamps = timestamps ?? [], progressImagesUrl = progressImagesUrl ?? [];

  factory JobData.fromJson(Map<String, dynamic> json, String jobID){
    return JobData(
        jobId: jobID,
        expectedDeliveryDate: DateTime.tryParse(json["expectedDeliveryDate"] ?? ""),
        title: json["name"],
        startTime: DateTime.tryParse(json["startTime"] ?? ""),
        progressImagesUrl: json["progressImagesUrl"] == null ? [] : List<String>.from(json["progressImagesUrl"]!.map((x) => x)),
        timestamps: json["timestamps"] == null ? [] : List<Timestamp>.from(json["timestamps"]!.map((x) => Timestamp.fromJson(x))),
    );
  }

  Future<void> addStartTime(String userId ,String token) async {
    if(timestamps.isNotEmpty && timestamps.last.endTime == timestamps.last.startTime){
      throw Exception("Provide end time first");
    }
    final url = '${AppUrl.jobs}/$jobId.json?auth=$token';
    DateTime currentTime = DateTime.now();
    try {
      List<Timestamp> newTimestamp = List.from(timestamps);
      newTimestamp.add(Timestamp(endTime: currentTime, startTime: currentTime));
      await http.put(Uri.parse(url), body: json.encode({
        'creatorId': userId,
        'expectedDeliveryDate': expectedDeliveryDate.toString(),
        'name': title,
        "startTime": startTime.toString(),
        "isCompleted": isComplete,
        "progressImagesUrl": progressImagesUrl,
        "timestamps": newTimestamp,
      }));
      timestamps.add(Timestamp(endTime: currentTime, startTime: currentTime));
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> addEndTime(String userId, String token) async{
    if(timestamps.isEmpty || timestamps.last.endTime != timestamps.last.startTime){
      throw Exception("Provide start time first");
    }
    final url = '${AppUrl.jobs}/$jobId.json?auth=$token';
    DateTime currentTime = DateTime.now();
    try {
      List<Timestamp> newTimestamp = List.from(timestamps);
      newTimestamp.last.endTime = currentTime;
      await http.put(Uri.parse(url), body: json.encode({
        'creatorId': userId,
        'expectedDeliveryDate': expectedDeliveryDate.toString(),
        'name': title,
        "startTime": startTime.toString(),
        "isCompleted": isComplete,
        "progressImagesUrl": progressImagesUrl,
        "timestamps": newTimestamp,
      }));
      timestamps.last.endTime = currentTime;
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> addProgressImage(String imageUrl, String userId, String token) async{
    final url = '${AppUrl.jobs}/$jobId.json?auth=$token';
    try{
      List<String> newProgressImages = List.from(progressImagesUrl);
      newProgressImages.add(imageUrl);
      await http.put(Uri.parse(url), body: json.encode({
        'creatorId': userId,
        'expectedDeliveryDate': expectedDeliveryDate.toString(),
        'name': title,
        "startTime": startTime.toString(),
        "isCompleted": isComplete,
        "progressImagesUrl": newProgressImages,
        "timestamps": timestamps,
      }));
      progressImagesUrl.add(imageUrl);
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> deleteProgressImage(String imageUrl, String userId, String token) async{
    final url = '${AppUrl.jobs}/$jobId.json?auth=$token';
    try{
      List<String> newProgressImages = List.from(progressImagesUrl);
      newProgressImages.remove(imageUrl);
      await http.put(Uri.parse(url), body: json.encode({
        'creatorId': userId,
        'expectedDeliveryDate': expectedDeliveryDate.toString(),
        'name': title,
        "startTime": startTime.toString(),
        "isCompleted": isComplete,
        "progressImagesUrl": newProgressImages,
        "timestamps": timestamps,
      }));
      await FirebaseApi.deleteFile(imageUrl: imageUrl);
      progressImagesUrl.remove(imageUrl);
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
  Map<String, dynamic> toJson() {
    final Map<String, String> data = <String, String>{};
    data['endTime'] = endTime!.toIso8601String();
    data['startTime'] = startTime!.toIso8601String();
    return data;
  }
}
