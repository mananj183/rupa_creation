import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/jobs.dart';
import '../widget/add_job_page.dart';
import '../widget/app_drawer.dart';
import '../widget/job_list.dart';

class JobOverviewScreen extends StatelessWidget {
  final String? uid;
  final String? uEmail;
  const JobOverviewScreen({Key? key, this.uid, this.uEmail}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Jobs>(context, listen: false)
        .fetchAndSetProducts(uId: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pending Orders"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      drawer: AppDrawer(uId: uid, uEmail: uEmail,),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Jobs>(
                        builder: (ctx, jobsData, _) {
                          return JobList(
                            showCompletedJobs: false,
                            uid: uid,
                            uEmail: uEmail,
                          );
                        },
                      ),
                    )),
      floatingActionButton: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        radius: 30,
        child: IconButton(
          icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AddJobPage(
                uid: uid,
              ),
            );
          },
        ),
      ),
    );
  }
}
