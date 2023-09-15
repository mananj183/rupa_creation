import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/jobs.dart';
import '../widget/add_job_page.dart';
import '../widget/app_drawer.dart';
import '../widget/job_list.dart';

class JobOverviewScreen extends StatefulWidget {
  JobOverviewScreen({Key? key}) : super(key: key);

  @override
  State<JobOverviewScreen> createState() => _JobOverviewScreenState();
}

class _JobOverviewScreenState extends State<JobOverviewScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((_) {
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
  // var _isInit = true;
  var _isLoading = false;
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<Jobs>(context).fetchAndSetProducts().then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Orders"),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const JobList(showCompletedJobs: false,),
      floatingActionButton: CircleAvatar(
        radius: 30,
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => const AddJobPage(),
            );
          },
        ),
      ),
    );
  }
}
