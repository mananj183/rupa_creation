import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rupa_creation/provider/job_data.dart';

import '../utility/app_urls.dart';

class Jobs with ChangeNotifier{
  List<JobData> _pendingJobs = [];
  final List<JobData> _completedJobs = [];

  List<JobData> get pendingJobs{
    return [..._pendingJobs];
  }

  Future<void> fetchAndSetProducts()async {
    const url = '${AppUrl.pendingJobs}.json';
    try{
      final response = await http.get(Uri.parse(url));
      if(response.body == 'null'){
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<JobData> loadedPendingJobs = [];

      extractedData.forEach((jobID, jobData) {
        JobData jd = JobData.fromJson(jobData, jobID);
        loadedPendingJobs.add(JobData(jobId: jobID, name: jd.name, startTime: jd.startTime, expectedDeliveryDate: jd.expectedDeliveryDate, progressImagesUrl: jd.progressImagesUrl, timestamps: jd.timestamps));
      });
      // for(int i=0; i< loadedPendingJobs.length; i++){
      //   print('${loadedPendingJobs[i].name}: ${loadedPendingJobs[i].timestamps}');
      // }
      _pendingJobs = loadedPendingJobs;
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> addJob(String name, DateTime? endTime) async {
    const url = '${AppUrl.pendingJobs}.json';
    DateTime startTime = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url), body: json.encode({
        'name': name,
        'startTime': startTime.toString(),
        'expectedDeliveryDate': endTime.toString(),
        'progressImagesUrl': [],
        'isCompleted': false,
        'timeStamps': []
      }));
    JobData newJob = JobData(jobId: json.decode(response.body)['name'], name: name, expectedDeliveryDate: endTime, startTime: startTime);
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