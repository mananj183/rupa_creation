import 'package:flutter/material.dart';
import 'package:rupa_creation/widget/app_drawer.dart';
import 'package:rupa_creation/widget/job_list.dart';

class CompletedJobsOverview extends StatelessWidget {
  const CompletedJobsOverview({Key? key}) : super(key: key);
  static const routeName = '/completed-jobs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Jobs'),backgroundColor: Theme.of(context).colorScheme.secondary,),
      backgroundColor: Theme.of(context).backgroundColor,
      body: const JobList(showCompletedJobs: true),
      drawer: const AppDrawer(),
    );
  }
}
