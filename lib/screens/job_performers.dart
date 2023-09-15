import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/users.dart';

class JobPerformers extends StatefulWidget {
  const JobPerformers({Key? key}) : super(key: key);

  @override
  State<JobPerformers> createState() => _JobPerformersState();
}

class _JobPerformersState extends State<JobPerformers> {
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then((_){
      setState(() {
        _isLoading = true;
      });
      try {
        Provider.of<Users>(context, listen: false).fetchAndSetUsers().then((
            _) {
          setState(() {
            _isLoading = false;
          });
        });
      }catch(e) {
        print(e);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return _isLoading ? const Center(child: CircularProgressIndicator(),) : Container();
  }
}
