import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/job_data.dart';
import 'package:rupa_creation/provider/jobs.dart';
import 'package:rupa_creation/widget/job_overview.dart';


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
      try {
        Provider.of<Jobs>(context, listen: false).fetchAndSetProducts().then((
            _) {
          setState(() {
            _isLoading = false;
          });
        });
      }catch(e) {
        print(e);
      }
    });
  }
  Future<void> _refreshJobs(BuildContext context) async{
    await Provider.of<Jobs>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    List<JobData> loadedProducts = Provider.of<Jobs>(context).items;
    return _isLoading ? const Center(child: CircularProgressIndicator(),) : RefreshIndicator(
      onRefresh: () => _refreshJobs(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: loadedProducts.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            value: loadedProducts[i],
            child: const JobOverview(),
          ),
        ),
      ),
    );
  }
}