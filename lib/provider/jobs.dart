import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rupa_creation/provider/job_data.dart';

import '../utility/app_urls.dart';

class Jobs with ChangeNotifier {
  List<JobData> _items = [];
  final List<JobData> _completedJobs = [];
  final String authToken;

  Jobs(
      {required this.authToken,
      List<JobData>? items})
      : _items = items ?? [];

  // JobPerformer(this.name, this.userId);

  List<JobData> get items {
    return [..._items];
  }

  List<JobData> get completedJobs {
    return _items.where((element) => element.isComplete).toList();
  }

  Future<void> fetchAndSetProducts(String userId) async {
    var url = '${AppUrl.pendingJobs}.json?auth=$authToken';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.body == 'null') {
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      url = '${AppUrl.baseUrl}/user-completed-jobs//$userId.json?auth=$authToken';
      final completedResponse = await http.get(Uri.parse(url));
      final completeData = json.decode(completedResponse.body);
      final List<JobData> loadedPendingJobs = [];
      extractedData.forEach((jobID, jobData) {
        JobData jd = JobData.fromJson(jobData, jobID);
        loadedPendingJobs.add(JobData(
            jobId: jobID,
            title: jd.title,
            startTime: jd.startTime,
            expectedDeliveryDate: jd.expectedDeliveryDate,
            isComplete: completeData == null ? false : completeData[jobID],
            progressImagesUrl: jd.progressImagesUrl,
            timestamps: jd.timestamps));
      });
      _items = loadedPendingJobs;
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
      _items.add(newJob);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  JobData findById(String id) {
    return _items.firstWhere((element) => element.jobId == id);
  }
}
