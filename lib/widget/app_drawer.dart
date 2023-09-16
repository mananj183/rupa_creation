import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/screens/completed_jobs_overview.dart';
import 'package:rupa_creation/screens/job_performers.dart';
import 'package:rupa_creation/screens/jobs_overview_screen.dart';

import '../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  final String? uId;
  final String? uEmail;
  const AppDrawer({Key? key, this.uId, this.uEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? name = Provider.of<Auth>(context).userEmailId;
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello $name'),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          name == "rupaCreation69" ? ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Users'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => const JobPerformers()));
            },
          ) : Container(),
          name == "rupaCreation69" ? const Divider() : Container(),
          ListTile(
            leading: const Icon(Icons.pending_actions),
            title: const Text('Pending Jobs'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => JobOverviewScreen(uid: uId, uEmail: uEmail,)));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.done_outline_rounded),
            title: const Text('Completed Jobs'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(CompletedJobsOverview.routeName, arguments: ScreenArguments(uid: uId, uEmail: uEmail));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
