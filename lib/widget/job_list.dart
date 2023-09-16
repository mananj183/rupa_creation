import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/job_data.dart';
import 'package:rupa_creation/provider/jobs.dart';
import 'package:rupa_creation/widget/job_overview.dart';

class JobList extends StatelessWidget {
  final bool showCompletedJobs;
  const JobList({Key? key, required this.showCompletedJobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<JobData> loadedJobs = showCompletedJobs
        ? Provider.of<Jobs>(context).completedJobs
        : Provider.of<Jobs>(context).pendingJobs;
    String message = showCompletedJobs ? "No Jobs Completed" : "No Pending Jobs\n\t\t\t\t\tAdd a Job +";
    return loadedJobs.isEmpty ? Center(child: Text(message, style: const TextStyle(fontSize: 17, color: Colors.black54),),) : Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text( showCompletedJobs ? "Completed Jobs (${loadedJobs.length})" : "Pending Jobs (${loadedJobs.length})", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, bottom: 60.0, right: 5.0),
            child: ListView.builder(
                itemCount: loadedJobs.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: loadedJobs[i],
                  child: Column(
                    children: [
                      JobOverview(showCompletedJobDetails: showCompletedJobs),
                    ],
                  ),
                ),
              ),
          ),
        ),
      ],
    );
  }
}
