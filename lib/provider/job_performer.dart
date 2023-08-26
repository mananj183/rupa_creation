import 'package:rupa_creation/modal/job_data.dart';

import 'job.dart';

class JobPerformer{
  final String name;
  final String userId;
  // List<Job>
  List<JobData> jobsPerformed = [];

  JobPerformer(this.name, this.userId);

}