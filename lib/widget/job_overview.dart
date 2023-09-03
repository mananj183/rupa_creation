import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/job_data.dart';

import '../screens/job_details.dart';

class JobOverview extends StatelessWidget {
  const JobOverview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final job = Provider.of<JobData>(context);
    DateTime? startDateTime = job.startTime;
    DateTime? endDateTime = job.expectedDeliveryDate;
    return Card(
      child: ListTile(
        tileColor: Colors.black12,
          // contentPadding: EdgeInsets.all(10),
          leading:SizedBox(
            height: 100,
            width: 45,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueGrey.shade100,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape:
                BoxShape.circle),
              child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: job.progressImagesUrl.isEmpty ? "https://firebasestorage.googleapis.com/v0/b/rupacreation-d7711.appspot.com/o/company_logo%2FWhatsApp%20Image%202023-08-29%20at%2022.32.37.jpeg?alt=media&token=a60ef6fb-3977-475a-ae57-7af7f1d93392" : job.progressImagesUrl[job.progressImagesUrl.length - 1],
              progressIndicatorBuilder: (context,
                  url, downloadProgress) =>
                  Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress
                            .progress),
                  ),
              errorWidget:
                  (context, url, error) =>
              const Icon(Icons.error),
            ),),),
          // ) : ConstrainedBox(
          //   constraints: const BoxConstraints(
          //     minWidth: 44,
          //     minHeight: 44,
          //     maxWidth: 64,
          //     maxHeight: 64,
          //   ),
          //   child: CachedNetworkImage(
          //     fit: BoxFit.cover,
          //     imageUrl:
          //     job.progressImagesUrl[job.progressImagesUrl.length - 1],
          //     progressIndicatorBuilder: (context,
          //         url, downloadProgress) =>
          //         Center(
          //           child: CircularProgressIndicator(
          //               value: downloadProgress
          //                   .progress),
          //         ),
          //     errorWidget:
          //         (context, url, error) =>
          //     const Icon(Icons.error),
          //   ),
          ),
          title: Text(job.title, textScaleFactor:  1.2,),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Start Date: ${DateFormat("dd-MM-yyyy").format(startDateTime!)}"),
              Text("Expected Delivery Date: ${DateFormat("dd-MM-yyyy").format(endDateTime!)}"),
            ],
          ),
        onTap: (){
          Navigator.of(context).pushNamed(JobDetailsScreen.routeName, arguments: job.jobId);
        },
      ),
    );
  }
}