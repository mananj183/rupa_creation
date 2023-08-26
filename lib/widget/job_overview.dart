import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/job.dart';

import '../screens/job_details.dart';

class JobOverview extends StatelessWidget {
  const JobOverview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final job = Provider.of<Job>(context);
    DateTime startDateTime = DateTime.parse(job.startTime);
    DateTime endDateTime = DateTime.parse(job.expectedDeliveryDate);
    return Card(
      child: ListTile(
        tileColor: Colors.black12,
          // contentPadding: EdgeInsets.all(10),
          leading: Icon(Icons.ac_unit),
          title: Text(job.name, textScaleFactor:  1.2,),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Start Date: ${DateFormat("dd-MM-yyyy").format(startDateTime)}"),
              Text("Expected Delivery Date: ${DateFormat("dd-MM-yyyy").format(endDateTime)}"),
            ],
          ),
        onTap: (){
          Navigator.of(context).pushNamed(JobDetailsScreen.routeName, arguments: job.jobID);
        },
      ),
    );
  }
}