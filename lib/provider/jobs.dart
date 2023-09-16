import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rupa_creation/firebase/firebase_api.dart';
import 'package:rupa_creation/provider/job_data.dart';

import '../utility/app_urls.dart';

class Jobs with ChangeNotifier {
  List<JobData> _pendingJobs = [];
  List<JobData> _completedJobs = [];
  final String authToken;
  final String userId;

  Jobs(
      {required this.userId,
      required this.authToken,
      List<JobData>? pendingJobs})
      : _pendingJobs = pendingJobs ?? [];

  List<JobData> get pendingJobs {
    return [..._pendingJobs];
  }

  List<JobData> get completedJobs {
    return _completedJobs;
  }

  Future<void> fetchAndSetProducts({String? uId}) async {
    var url = uId == null ?
        '${AppUrl.jobs}.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"' : '${AppUrl.jobs}.json?auth=$authToken&orderBy="creatorId"&equalTo="$uId"';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.body == 'null') {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      url =
          uId == null ? '${AppUrl.baseUrl}/user-completed-jobs/$userId.json?auth=$authToken' : '${AppUrl.baseUrl}/user-completed-jobs/$uId.json?auth=$authToken';
      final completedResponse = await http.get(Uri.parse(url));
      final completeData = json.decode(completedResponse.body);
      final List<JobData> loadedPendingJobs = [];
      final List<JobData> loadedCompletedJobs = [];
      extractedData.forEach((jobID, jobData) {
        JobData jd = JobData.fromJson(jobData, jobID);
        var jobDataObject = JobData(
            jobId: jobID,
            title: jd.title,
            startTime: jd.startTime,
            expectedDeliveryDate: jd.expectedDeliveryDate,
            isComplete:
                completeData == null ? false : completeData[jobID] ?? false,
            progressImagesUrl: jd.progressImagesUrl,
            timestamps: jd.timestamps);
        completeData == null ||
                completeData[jobID] == null ||
                completeData[jobID] == false
            ? loadedPendingJobs.add(jobDataObject)
            : loadedCompletedJobs.add(jobDataObject);
      });
      _pendingJobs = loadedPendingJobs;
      _completedJobs = loadedCompletedJobs;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addJob(String name, DateTime? endTime, String? uId) async {
    final url = '${AppUrl.jobs}.json?auth=$authToken';
    DateTime startTime = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'name': name,
            'startTime': startTime.toString(),
            'expectedDeliveryDate': endTime.toString(),
            'timeStamps': [],
            'creatorId': uId ?? userId,
          }));
      JobData newJob = JobData(
          jobId: json.decode(response.body)['name'],
          title: name,
          expectedDeliveryDate: endTime,
          startTime: startTime);
      _pendingJobs.add(newJob);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  JobData findById(String id, bool findCompletedJob) {
    return findCompletedJob ? _completedJobs.firstWhere((element) => element.jobId == id) : _pendingJobs.firstWhere((element) => element.jobId == id);
  }

  Future<void> deleteJob(String jobId, bool isCompletedJob, String token, String username) async {
    // print("username: $username   jobId- $jobId");
    var url = '${AppUrl.jobs}/$jobId.json?auth=$token';
    try {
      JobData jd = findById(jobId, isCompletedJob);
      await http.delete(Uri.parse(url));
      if(jd.progressImagesUrl.isNotEmpty) {
        await FirebaseApi.deleteFolder(path: '$username/$jobId');
      }
      if (isCompletedJob) {
        url =
        '${AppUrl.baseUrl}/user-completed-jobs/$userId/$jobId.json?auth=$token';
        await http.delete(Uri.parse(url));
        _completedJobs.remove(jd);
      }else{
      _pendingJobs.remove(jd);
      }
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> toggleCompleteStatus(
      String userId, String token, String jobId, bool isComplete) async {
    final url =
        '${AppUrl.baseUrl}/user-completed-jobs/$userId/$jobId.json?auth=$token';
    final url2 = '${AppUrl.jobs}/$jobId.json?auth=$token';
    DateTime timestamp = DateTime.now();
    try {
      await http.put(
        Uri.parse(url),
        body: json.encode(
          isComplete,
        ),
      );
      await http.patch(Uri.parse(url2), body: json.encode({
        "expectedDeliveryDate": timestamp.toIso8601String(),
      }));
      JobData jd = findById(jobId, !isComplete);
      jd.isComplete = isComplete;
      jd.expectedDeliveryDate = timestamp;
      if(isComplete){
        _completedJobs.add(jd);
        _pendingJobs.remove(jd);
      }else{
        _pendingJobs.add(jd);
        _completedJobs.remove(jd);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
