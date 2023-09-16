import 'package:flutter/material.dart';
import 'package:rupa_creation/widget/app_drawer.dart';
import 'package:rupa_creation/widget/job_list.dart';

class CompletedJobsOverview extends StatelessWidget {
  const CompletedJobsOverview({Key? key}) : super(key: key);
  static const routeName = '/completed-jobs';

  @override
  Widget build(BuildContext context) {
    final arguments =
    ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final uId = arguments.uid;
    final uEmail = arguments.uEmail;
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Jobs'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: JobList(showCompletedJobs: true, uid: uId, uEmail: uEmail,),
      drawer: AppDrawer(uId: uId, uEmail: uEmail,),
    );
  }
}

class ScreenArguments {
  final String? uid;
  final String? uEmail;

  ScreenArguments({this.uid, this.uEmail});
}
