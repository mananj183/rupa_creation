import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rupa_creation/provider/job_data.dart';

import '../utility/app_urls.dart';

class Jobs with ChangeNotifier {
  List<JobData> _pendingJobs = [];
  List<JobData> _completedJobs = [];
  final String authToken;

  Jobs({required this.authToken, List<JobData>? pendingJobs}) : _pendingJobs = pendingJobs ?? [];

  // JobPerformer(this.name, this.userId);

  List<JobData> get pendingJobs {
    return [..._pendingJobs];
  }

  List<JobData> get completedJobs {
    return _completedJobs;
  }

  Future<void> fetchAndSetProducts(String userId) async {
    var url = '${AppUrl.pendingJobs}.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.body == 'null') {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      url =
          '${AppUrl.baseUrl}/user-completed-jobs//$userId.json?auth=$authToken';
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
            isComplete: completeData == null ? false : completeData[jobID],
            progressImagesUrl: jd.progressImagesUrl,
            timestamps: jd.timestamps);
        completeData == null || completeData[jobID] == false
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

  Future<void> addJob(String name, DateTime? endTime) async {
    final url = '${AppUrl.pendingJobs}.json?auth=$authToken';
    DateTime startTime = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'name': name,
            'startTime': startTime.toString(),
            'expectedDeliveryDate': endTime.toString(),
            'progressImagesUrl': [],
            'timeStamps': []
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

  JobData findById(String id) {
    return _pendingJobs.firstWhere((element) => element.jobId == id);
  }
}
