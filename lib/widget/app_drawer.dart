import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/screens/completed_jobs_overview.dart';
import 'package:rupa_creation/screens/jobs_overview_screen.dart';

import '../provider/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? name = Provider.of<Auth>(context).userEmailId;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello $name'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.pending_actions),
            title: const Text('Pending Jobs'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (_) => JobOverviewScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.done_outline_rounded),
            title: const Text('Completed Jobs'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(CompletedJobsOverview.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
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
