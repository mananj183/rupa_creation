import 'package:rupa_creation/provider/job_data.dart';

class JobPerformer{
  final String name;
  final String userId;
  List<JobData> jobsPerformed = [];

  JobPerformer(this.name, this.userId);

}