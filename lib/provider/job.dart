// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:rupa_creation/modal/job_data.dart';
// import 'package:rupa_creation/utility/app_urls.dart';
// import 'package:http/http.dart' as http;
//
// class Job with ChangeNotifier{
//   final String jobID;
//   final String name;
//   final String startTime = DateTime.now().toString();
//   final String expectedDeliveryDate;
//   List<String> progressImagesUrl;
//   bool isCompleted = false;
//   List<Timestamp> timestamps;
//
//   Job({required this.jobID, required this.name, required this.expectedDeliveryDate, List<Timestamp>? timestamps, List<String>? progressImagesUrl}) :  timestamps = timestamps ?? [], progressImagesUrl = progressImagesUrl ?? [];
//
//   // void editExpectedDeliveryDate(DateTime dt){
//   //   expectedDeliveryDate = dt.toString();
//   //   notifyListeners();
//   // }
//
//   // List<String> get progressImagesUrl{
//   //   return [...progressImagesUrls];
//   // }
//   //
//   // List<Map<String, String>> get timestamps{
//   //   return [...timestamp];
//   // }
//
//   Future<void> fetchAndSetTimestamps() async {
//     final url = '${AppUrl.pendingProducts}/$jobID.json';
//     final response = await http.get(Uri.parse(url));
//     print(response.body);
//   }
//
//   Future<void> addStartTime() async {
//     if(timestamps.isNotEmpty && timestamps.last.endTime.toString() == ""){
//       print("error");
//       throw Exception("Provide end time first");
//     }
//     print("added start time");
//     final url = '${AppUrl.pendingProducts}/$jobID.json';
//     try {
//       List<Timestamp> newTimestamp = timestamps;
//       newTimestamp.add(Timestamp(endTime: null, startTime: DateTime.now()));
//       // newTimestamp.add({"startTime": DateTime.now()});
//       await http.patch(Uri.parse(url), body: json.encode({
//         'timeStamps': newTimestamp,
//       }));
//     }catch(e){
//       rethrow;
//     }
//     timestamps.add({"startTime": DateTime.now().toString(), "endTime": ""});
//     notifyListeners();
//   }
//   Future<void> addEndTime() async{
//     if(timestamps.isEmpty || timestamps.last["endTime"] != ""){
//       throw Exception("Provide start time first");
//     }
//     print("added end time");
//     final url = '${AppUrl.pendingProducts}/$jobID.json';
//     try {
//       List<Map<String, String>> newTimestamps = timestamps;
//       newTimestamps.last["endTime"] = DateTime.now().toString();
//       await http.patch(Uri.parse(url), body: json.encode({
//         'timeStamps': newTimestamps,
//       }));
//     }catch(e){
//       rethrow;
//     }
//     timestamps.last["endTime"] = DateTime.now().toString();
//     notifyListeners();
//   }
//
//   void addImage(String imageUrl){
//     progressImagesUrl.add(imageUrl);
//     notifyListeners();
//   }
//
//   void toggleIsCompleted(){
//     isCompleted != isCompleted;
//     // Provider.of<Jobs>(context).completeJob(this);
//     notifyListeners();
//   }
// }
