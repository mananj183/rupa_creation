import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/users.dart';
import 'package:rupa_creation/screens/jobs_overview_screen.dart';

import '../widget/app_drawer.dart';

class JobPerformers extends StatelessWidget {
  const JobPerformers({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Users>(context, listen: false).fetchAndSetUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Job Performers"),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        drawer: const AppDrawer(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshProducts(context),
                  child: Consumer<Users>(
                    builder: (ctx, userData, _) {
                      return ListView.builder(
                        itemCount: userData.users.length,
                        itemBuilder: (_, i) => Column(
                          children: [
                            ListTile(
                              title: Text(userData.users[i].fullName!),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => JobOverviewScreen(
                                          uid: userData.users[i].userId,
                                          uEmail: userData.users[i].email,
                                        )));
                              },
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  )),
          // body: FutureBuilder(
          //     future: _refreshProducts(context),
          //     builder: (ctx, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.done) {
          //         if (snapshot.hasError) {
          //           return RefreshIndicator(
          //             onRefresh: () => _refreshProducts(context),
          //             child: Center(
          //               child: Text(
          //                 '${snapshot.error} occurred',
          //                 style: const TextStyle(fontSize: 18),
          //               ),
          //             ),
          //           );
          //           // if we got our data
          //         } else if (snapshot.hasData) {
          //           return RefreshIndicator(
          //             onRefresh: () => _refreshProducts(context),
          //             child: Consumer<Users>(builder: (ctx, userData, _) {
          //               return ListView.builder(
          //                 itemCount: userData.users.length,
          //                 itemBuilder: (_, i) => Column(
          //                   children: [
          //                     ListTile(
          //                       title: Text(userData.users[i].fullName!),
          //                       onTap: () {
          //                         Navigator.of(context).push(MaterialPageRoute(
          //                             builder: (_) => JobOverviewScreen(
          //                                   uid: userData.users[i].userId,
          //                                   uEmail: userData.users[i].email,
          //                                 )));
          //                       },
          //                     ),
          //                     const Divider(),
          //                   ],
          //                 ),
          //               );
          //             }),
          //           );
          //         }
          //       }
          //       return const Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     }),
        ));
  }
}

// class JobPerformers extends StatefulWidget {
//   const JobPerformers({Key? key}) : super(key: key);
//
//   @override
//   State<JobPerformers> createState() => _JobPerformersState();
// }
//
// class _JobPerformersState extends State<JobPerformers> {
//   var _isLoading = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     Future.delayed(Duration.zero).then((_){
//       setState(() {
//         _isLoading = true;
//       });
//         Provider.of<Users>(context, listen: false).fetchAndSetUsers().then((
//             _) {
//           setState(() {
//             _isLoading = false;
//           });
//         });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return _isLoading ? const Center(child: CircularProgressIndicator(),) : Container();
//   }
// }
