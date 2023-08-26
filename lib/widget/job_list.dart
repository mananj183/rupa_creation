import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/jobs.dart';
import 'package:rupa_creation/widget/job_overview.dart';

import '../provider/job.dart';

class JobList extends StatefulWidget {
  const JobList({
    Key? key,
  }) : super(key: key);

  @override
  State<JobList> createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Jobs>(context, listen: false).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Job> loadedProducts = Provider.of<Jobs>(context).pendingJobs;
    for(int i =0; i<loadedProducts.length; i++){
      print(loadedProducts[i].timestamps);
    }
    return _isLoading ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: JobOverview(),
      ),
    );
  }
}