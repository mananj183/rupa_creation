import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/jobs.dart';
import 'package:rupa_creation/screens/job_details.dart';
import 'package:rupa_creation/screens/jobs_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Jobs(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: JobOverviewScreen(),
          routes: {
            JobDetailsScreen.routeName: (ctx) => const JobDetailsScreen(),
          }
      ),
    );
  }
}
