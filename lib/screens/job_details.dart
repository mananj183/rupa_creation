import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/auth.dart';
import 'package:rupa_creation/provider/job_data.dart';
import 'package:rupa_creation/provider/jobs.dart';
import 'package:path/path.dart';

import '../firebase/firebase_api.dart';

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  var _isLoading = false;
  File? file;
  UploadTask? task;

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final jobId = arguments.jobId;
    bool showCompletedJobDetails = arguments.showCompletedJobDetails;
    final uId = arguments.uid;
    final uEmail = arguments.uEmail;
    final loadedJobs = Provider.of<Jobs>(
      context,
    );
    final loggedInUser = Provider.of<Auth>(context, listen: false);
    final loadedJob = loadedJobs.findById(jobId, showCompletedJobDetails);
    List<TableRow> createTimeStampTable(List<Timestamp> items) {
      List<TableRow> itemProperties = [];
      itemProperties.add(const TableRow(children: [
        TableCell(
          child: Center(child: Text("Start Time")),
        ),
        TableCell(child: Center(child: Text("End Time")))
      ]));
      for (int i = 0; i < items.length; ++i) {
        DateTime startTime = items[i].startTime!;
        DateTime endTime = items[i].endTime!;
        itemProperties.add(TableRow(children: [
          TableCell(
              child: Center(
                  child: Text(startTime.hour.toString().length == 1 &&
                          startTime.minute.toString().length == 1
                      ? "${startTime.day}/${startTime.month}/${startTime.year} - 0${startTime.hour}:0${startTime.minute}"
                      : startTime.hour.toString().length == 1
                          ? "${startTime.day}/${startTime.month}/${startTime.year} - 0${startTime.hour}:${startTime.minute}"
                          : startTime.minute.toString().length == 1
                              ? "${startTime.day}/${startTime.month}/${startTime.year} - ${startTime.hour}:0${startTime.minute}"
                              : "${startTime.day}/${startTime.month}/${startTime.year} - ${startTime.hour}:${startTime.minute}"))),
          TableCell(
              child: Center(
                  child: startTime == endTime
                      ? null
                      : Text(endTime.hour.toString().length == 1 &&
                              endTime.minute.toString().length == 1
                          ? "${endTime.day}/${endTime.month}/${endTime.year} - 0${endTime.hour}:0${endTime.minute}"
                          : endTime.hour.toString().length == 1
                              ? "${endTime.day}/${endTime.month}/${endTime.year} - 0${endTime.hour}:${endTime.minute}"
                              : endTime.minute.toString().length == 1
                                  ? "${endTime.day}/${endTime.month}/${endTime.year} - ${endTime.hour}:0${endTime.minute}"
                                  : "${endTime.day}/${endTime.month}/${endTime.year} - ${endTime.hour}:${endTime.minute}"))),
        ]));
      }
      return itemProperties;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedJob.title),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            )
          : Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  showCompletedJobDetails
                      ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                            'Timestamps',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                      )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 50),
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                      shape: const StadiumBorder()),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      await loadedJob.addStartTime(
                                          uId ?? loggedInUser.userId!,
                                          loggedInUser.token!);
                                    } catch (e) {
                                      await buildShowDialog(context, e);
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Start",
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary,),
                                  )),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 50),
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    shape: const StadiumBorder()),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await loadedJob.addEndTime(
                                        uId ?? loggedInUser.userId!,
                                        loggedInUser.token!);
                                  } catch (e) {
                                    await buildShowDialog(context, e);
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                child: Text(
                                  "Stop",
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
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
                          border: TableBorder.all(color: Theme.of(context).colorScheme.primary),
                          children: createTimeStampTable(job.timestamps),
                        );
                      }),
                  const SizedBox(
                      height: 30,
                      child: Divider(
                        color: Colors.black38,
                      )),
                  const Text("Progress Images",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  Expanded(
                    child: GridView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        itemCount: loadedJob.progressImagesUrl.length + 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // no. of columns
                                childAspectRatio: 1.5 / 2, // length/width ratio
                                crossAxisSpacing: 5, // space btw columns
                                mainAxisSpacing: 5 // space btw rows
                                ),
                        itemBuilder: (_, i) =>
                            ChangeNotifierProvider<JobData>.value(
                              value: loadedJob,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: i < loadedJob.progressImagesUrl.length
                                      ? GridTile(
                                          child: Card(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: loadedJob
                                                  .progressImagesUrl[i],
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                          // child: Image.network(loadedJob.progressImagesUrl[i]),
                                        )
                                      : GridTile(
                                          child: Card(
                                          child: Center(
                                            child: IconButton(
                                              icon:
                                                  const Icon(Icons.add_a_photo),
                                              onPressed: () async {
                                                if (!showCompletedJobDetails) {
                                                  try {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    await selectAndUploadFile(
                                                        uEmail ?? loggedInUser
                                                                .userEmailId!,
                                                            jobId)
                                                        .then((imageUrl) async {
                                                      if (imageUrl == null) {
                                                        return;
                                                      }
                                                      try {
                                                        await loadedJob.addProgressImage(
                                                            imageUrl,
                                                            uId ?? loggedInUser
                                                                .userId!,
                                                            loggedInUser
                                                                .token!);
                                                      } catch (e) {
                                                        await buildShowDialog(
                                                            context, e);
                                                      }
                                                    });
                                                  } catch (e) {
                                                    await buildShowDialog(
                                                        context, e);
                                                  } finally {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ))),
                            )),
                  ),
                ],
              ),
            ),
    );
  }

  Future<dynamic> buildShowDialog(BuildContext context, Object e) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("Okay"),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> selectAndUploadFile(String username, String jobId) async {
    final ImagePicker picker = ImagePicker();

    XFile? imageFile = await picker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;
    setState(() => file = File(imageFile.path));
    final fileName = basename(file!.path);
    final destination = '$username/$jobId/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }
}

class ScreenArguments {
  final String jobId;
  final bool showCompletedJobDetails;
  final String? uid;
  final String? uEmail;

  ScreenArguments({required this.jobId, required this.showCompletedJobDetails, this.uid, this.uEmail});
}
