import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/modal/user.dart';
import 'package:rupa_creation/provider/auth.dart';
import 'package:rupa_creation/provider/jobs.dart';
import 'package:rupa_creation/provider/users.dart';
import 'package:rupa_creation/screens/completed_jobs_overview.dart';
import 'package:rupa_creation/screens/job_details.dart';
import 'package:rupa_creation/screens/job_performers.dart';
import 'package:rupa_creation/screens/jobs_overview_screen.dart';
import 'package:rupa_creation/screens/login_screen.dart';

import 'screens/splash_screen.dart';

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
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (ctx) => Users(authToken: ''),
          update: (ctx, auth, previousUsers) => Users(
              authToken: auth.token == null ? '' : auth.token!,
              users: previousUsers == null ? [] : previousUsers.users),
        ),

        ChangeNotifierProxyProvider<Auth, Jobs>(
          create: (ctx) => Jobs(userId: '', authToken: ''),
          update: (ctx, auth, previousJobs) => Jobs(
              authToken: auth.token == null ? '' : auth.token!,
              userId: auth.userId == null ? '' :  auth.userId!,
              pendingJobs:
                  previousJobs == null ? [] : previousJobs.pendingJobs),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth && auth.userEmailId == 'rupaCreation69'
                ? const JobPerformers()
                : auth.isAuth && auth.userEmailId != 'rupaCreation69'
                    ? JobOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (_, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const LoginScreen()),
            routes: {
              JobDetailsScreen.routeName: (ctx) => const JobDetailsScreen(),
              CompletedJobsOverview.routeName: (ctx) => const CompletedJobsOverview(),
            }),
      ),
    );
  }
}
