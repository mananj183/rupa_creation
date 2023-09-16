import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/job_data.dart';
import 'package:rupa_creation/provider/jobs.dart';

import '../provider/auth.dart';
import '../screens/job_details.dart';

class JobOverview extends StatefulWidget {
  final bool showCompletedJobDetails;
  const JobOverview({Key? key, required this.showCompletedJobDetails})
      : super(key: key);

  @override
  State<JobOverview> createState() => _JobOverviewState();
}

class _JobOverviewState extends State<JobOverview> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final job = Provider.of<JobData>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    DateTime? startDateTime = job.startTime;
    DateTime? endDateTime = job.expectedDeliveryDate;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SlideMenu(
            menuItems: <Widget>[
              !widget.showCompletedJobDetails
                  ? Container(
                height: 64,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.done_outline_rounded),
                        onPressed: () async {
                          await buildShowDialog(
                              context,
                              authData,
                              job,
                              "Mark Complete",
                              "Are you sure you want to mark this job as completed?",
                              true);
                        },
                      ),
                    )
                  : Container(),
              Container(
                height: 64,
                width: 50,
                decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    buildShowDialog(context, authData, job, "Delete Job",
                        "Are you sure you want to delete this job?", false);
                  },
                ),
              )
            ],
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: ListTile(
                      tileColor: Colors.black12,
                      leading: SizedBox(
                        height: 100,
                        width: 45,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueGrey.shade100,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            child: job.progressImagesUrl.isEmpty
                                ? Image.asset(
                                    'assets/images/rupa_logo.png',
                                    fit: BoxFit.fitHeight,
                                  )
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: job.progressImagesUrl[
                                        job.progressImagesUrl.length - 1],
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                          ),
                        ),
                      ),
                      title: Text(
                        job.title,
                        textScaleFactor: 1.2,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Start Date: ${DateFormat("dd-MM-yyyy").format(startDateTime!)}"),
                          Text(widget.showCompletedJobDetails
                              ? "Delivery Date: ${DateFormat("dd-MM-yyyy").format(endDateTime!)}"
                              : "Expected Delivery Date: ${DateFormat("dd-MM-yyyy").format(endDateTime!)}"),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            JobDetailsScreen.routeName,
                            arguments: ScreenArguments(
                                jobId: job.jobId,
                                showCompletedJobDetails:
                                    widget.showCompletedJobDetails));
                      },
                    ),
                  ),
                ),
                Container(
                  height: 64,
                  decoration: BoxDecoration(
                      color: widget.showCompletedJobDetails
                          ? Colors.red
                          : Colors.green,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: const Center(
                    child: Text(
                      '<',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  buildShowDialog(BuildContext context, Auth authData, JobData job,
      String title, String content, bool isMarkCompleteTask) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isMarkCompleteTask ? Colors.green : Colors.red,
          ),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        titlePadding: const EdgeInsets.all(0),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              try {
                Navigator.of(ctx).pop();
                isMarkCompleteTask
                    ? await Provider.of<Jobs>(context, listen: false)
                        .toggleCompleteStatus(
                            authData.userId!, authData.token!, job.jobId, true)
                    : await Provider.of<Jobs>(context, listen: false).deleteJob(
                        job.jobId,
                        widget.showCompletedJobDetails,
                        authData.token!,
                        authData.userEmailId!);
              } catch (e) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.of(ctx).pop();
                await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text('Error'),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Okay'))
                          ],
                        ));
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  const SlideMenu({Key? key, required this.child, required this.menuItems})
      : super(key: key);

  @override
  State<SlideMenu> createState() => _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Here the end field will determine the size of buttons which will appear after sliding
    //If you need to appear them at the beginning, you need to change to "+" Offset coordinates (0.2, 0.0)
    final animation =
        Tween(begin: const Offset(0.0, 0.0), end: const Offset(-0.25, 0.0))
            .animate(CurveTween(curve: Curves.decelerate).animate(_controller));

    return GestureDetector(onHorizontalDragUpdate: (data) {
      // we can access context.size here
      setState(() {
        //Here we set value of Animation controller depending on our finger move in horizontal axis
        //If you want to slide to the right, change "-" to "+"
        _controller.value -=
            (data.primaryDelta! / (context.size!.width * 0.25));
      });
    }, onHorizontalDragEnd: (data) {
      //To change slide direction, change to data.primaryVelocity! < -1500
      if (data.primaryVelocity! > 1500) {
        _controller.animateTo(.0);
      } else if (_controller.value >= .5 || data.primaryVelocity! < -1500) {
        _controller.animateTo(1.0);
      } else {
        _controller.animateTo(.0);
      }
    }, child: LayoutBuilder(builder: (context, constraint) {
      return Stack(
        children: [
          SlideTransition(
            position: animation,
            child: widget.child,
          ),
          AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                //To change slide direction to right, replace the right parameter with left:
                return Positioned(
                  right: .0,
                  top: .0,
                  bottom: .0,
                  width: constraint.maxWidth * animation.value.dx * -1 * 1.5,
                  child: Row(
                    children: widget.menuItems.map((child) {
                      return Expanded(
                        child: child,
                      );
                    }).toList(),
                  ),
                );
              })
        ],
      );
    }));
  }
}
