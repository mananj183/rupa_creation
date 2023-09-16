import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rupa_creation/provider/jobs.dart';

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  TextEditingController jobNameController = TextEditingController();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  DateTime? endDatePicked;
  var _isloading = false;
  DateTime? startTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime = DateTime.now();
    startDateController = TextEditingController(
        text: DateFormat("dd-MM-yyyy").format(startTime!).toString());
  }
  @override
  Widget build(BuildContext context) {
    final jobs = Provider.of<Jobs>(context);
    return _isloading ? Center(child: CircularProgressIndicator( color: Theme.of(context).colorScheme.primary,),) : AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      title: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: const Text(
          "Add New Job",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
      content: Form(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              // icon: const Icon(Icons.work),
              hintText: 'Enter Job title',
              labelText: 'Job title',
            ),
            controller: jobNameController,
            validator: (value) {

            },
          ),
          TextFormField(
            readOnly: true,
            decoration: const InputDecoration(
              // icon: const Icon(Icons.calendar_month),
              hintText: 'Start Date',
              labelText: 'Start Date',
            ),
            controller: startDateController,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'End Date',
                    labelText: 'End Date',
                  ),
                  controller: endDateController,
                ),
              ),
              IconButton(
                  onPressed: () async {
                    endDatePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1));
                    if (endDatePicked != null) {
                      setState(() {
                        endDateController.value = TextEditingValue(
                            text: DateFormat("dd-MM-yyyy")
                                .format(endDatePicked!)
                                .toString());
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month)),
            ],
          ),
        ],
      )),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            setState(() {
              _isloading = true;
            });
            try {
              await jobs.addJob(
                  jobNameController.value.text, endDatePicked);
            }catch(e){
              await showDialog(context: context, builder: (ctx) => AlertDialog(
                title: const Text('Error Occurred'),
                content: Text(e.toString()),
                actions: [
                  TextButton(onPressed: (){ Navigator.of(ctx).pop(); }, child: const Text('Okay'))
                ],
              ));
            }finally {
              setState(() {
                _isloading = false;
              });
              Navigator.of(context).pop();
            }
          },
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            padding: const EdgeInsets.only(left: 25, right: 25, top: 14, bottom: 14),
            child: const Text("Add", style: TextStyle(color: Colors.white,)),
          ),
        ),
      ],
    );
  }
}
