import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/auth.dart';
import 'package:rupa_creation/provider/jobs.dart';
import 'package:rupa_creation/provider/users.dart';
import 'package:rupa_creation/screens/job_details.dart';
import 'package:rupa_creation/screens/job_performers.dart';
import 'package:rupa_creation/screens/jobs_overview_screen.dart';
import 'package:rupa_creation/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Users()),
        ChangeNotifierProxyProvider<Auth, Jobs?>(
          create: (ctx) => null,
          update: (ctx, auth, previousJobs) =>
              Jobs(authToken: auth.token!, items: previousJobs == null ? [] : previousJobs.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth && auth.userEmailId == 'rupaCreation69'
                ? const JobPerformers()
                : auth.isAuth && auth.userEmailId != 'rupaCreation69'
                    ? JobOverviewScreen()
                    : const LoginScreen(),
            routes: {
              JobDetailsScreen.routeName: (ctx) => const JobDetailsScreen(),
            }),
      ),
    );
  }
}
