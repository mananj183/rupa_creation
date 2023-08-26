import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rupa_creation/modal/job_data.dart';

import '../utility/app_urls.dart';
import 'job.dart';

class Jobs with ChangeNotifier{
  List<JobData> _pendingJobs = [];
  final List<JobData> _completedJobs = [];

  List<JobData> get pendingJobs{
    return [..._pendingJobs];
  }

  Future<void> fetchAndSetProducts()async {
    const url = '${AppUrl.pendingProducts}.json';
    try{
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<JobData> loadedPendingJobs = [];

      extractedData.forEach((jobID, jobData) {
        JobData jd = JobData.fromJson(jobData);
        loadedPendingJobs.add(JobData(jobId: jobID, name: jd.name, startTime: jd.startTime, expectedDeliveryDate: jd.expectedDeliveryDate, progressImagesUrl: jd.progressImagesUrl, timestamps: jd.timestamps));
      });
      for(int i=0; i< loadedPendingJobs.length; i++){
        print('${loadedPendingJobs[i].name}: ${loadedPendingJobs[i].timestamps}');
      }
      _pendingJobs = loadedPendingJobs;
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> addJob(String name, String endTime) async {
    const url = '${AppUrl.pendingProducts}.json';
    try {
      final response = await http.post(Uri.parse(url), body: json.encode({
        'name': name,
        'startTime': DateTime.now().toString(),
        'expectedDeliveryDate': endTime,
        'progressImagesUrl': [],
        'isCompleted': false,
        'timeStamps': []
      }));
    Job newJob = Job(jobID: json.decode(response.body)['name'], name: name, expectedDeliveryDate: endTime);
    _pendingJobs.add(newJob);
    notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  JobData findById(String id){
    return _pendingJobs.firstWhere((element) => element.jobId == id);
  }

  void completeJob(JobData job){
    _completedJobs.add(job);
    _pendingJobs.remove(job);
    notifyListeners();
  }

  List<JobData> get completedJobs{
    return [..._completedJobs];
  }
}