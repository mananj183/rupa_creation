import 'package:flutter/material.dart';
import '../widget/add_job_page.dart';
import '../widget/job_list.dart';

class JobOverviewScreen extends StatelessWidget {
  JobOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Orders"),
      ),
      body: JobList(),
      floatingActionButton: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AddJobPage(),
          );
        },
      ),
    );
  }
}


