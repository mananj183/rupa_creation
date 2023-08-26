import 'job.dart';

class JobPerformer{
  final String name;
  final String userId;
  // List<Job>
  List<Job> jobsPerformed = [];

  JobPerformer(this.name, this.userId);

}