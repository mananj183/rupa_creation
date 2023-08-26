import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/modal/job_data.dart';
import 'package:rupa_creation/provider/jobs.dart';

import '../provider/job.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final jobId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedJobs = Provider.of<Jobs>(
      context,
    );
    final loadedJob = loadedJobs.findById(jobId);
    print(loadedJob.timestamps);
    List<TableRow> createTimeStampTable(List<Timestamp> items) {
      List<TableRow> itemProperties = [];
      itemProperties.add(const TableRow(children: [
        TableCell(child: Center(child: Text("Start Time")),),
        TableCell(child: Center(child: Text("End Time")))
      ]));
      for (int i = 0; i < items.length; ++i) {
        DateTime? startTime = items[i].startTime;
        DateTime? endTime = items[i].endTime;
        itemProperties.add(TableRow(

            children: [
          TableCell(child: Center(child: Text("${startTime!.hour}:${startTime.minute}"))),
          TableCell(child: Center(child: Text("${endTime!.hour}:${endTime.minute}"))),
        ]));
      }
      return itemProperties;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(loadedJob.name),
      ),
      body: _isLoading ? Center(child: const CircularProgressIndicator(),) : Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              backgroundColor: Colors.blue,
                              shape: const StadiumBorder()),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await loadedJob.addStartTime();
                            }catch (e) {
                              await showDialog(context: context, builder: (ctx) => AlertDialog(
                                  title: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();

                                      },
                                      child: Container(
                                        color: Colors.green,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("okay"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }finally{
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: const Text("Start", style: TextStyle(color: Colors.white),)),
                    ),
                //   ],
                // ),
                const SizedBox(width: 20,),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              backgroundColor: Colors.blue,
                              shape: const StadiumBorder()),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await loadedJob.addEndTime();
                            }catch (e) {
                              print("here");
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                    title: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          color: Colors.green,
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("okay"),
                                        ),
                                      ),
                                    ],
                                  ),
                              );
                            }
                            finally{
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: const Text("Stop", style: TextStyle(color: Colors.white),),),
                    ),
                  ],
                ),
            //   ],
            // ),
            ChangeNotifierProvider<JobData>.value(
              value: loadedJob,
              builder: (context, _) {
                final job = context.watch<JobData>();
                return Table(
                  border: TableBorder.all(color: Colors.blue),
                  children: createTimeStampTable(job.timestamps),
                );
              }
            ),
            TextButton(onPressed: (){
              // loadedJob.toggleIsCompleted();
              loadedJobs.completeJob(loadedJob);
              Navigator.of(context).pop();

            }, child: Text('mark completed'))
          ],
        ),
      ),
    );
  }
}
