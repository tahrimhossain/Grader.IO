// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/create_assignment_view_controller.dart';
import 'package:grader_io/Models/assignment_summary.dart';

class CreateAssignmentView extends ConsumerStatefulWidget {
  final String classroomCode;

  const CreateAssignmentView({Key? key, required this.classroomCode})
      : super(key: key);

  @override
  CreateAssignmentViewState createState() => CreateAssignmentViewState();
}

class CreateAssignmentViewState extends ConsumerState<CreateAssignmentView> {
  late AsyncValue<CreateAssignmentState> createAssignmentState;
  String _markdownTextDescription = '';
  String _markdownTextInstruction = '';
  final _descController = TextEditingController();
  final _insController = TextEditingController();
  final _scrollController = ScrollController();

  final _formKeyTitle = GlobalKey<FormState>();
  final _formKeyMaxScore = GlobalKey<FormState>();
  final _formKeyReviewerNumber = GlobalKey<FormState>();

  DateTime assignmentStartsDateTime = DateTime(0);
  DateTime submissionDeadlineDateTime = DateTime.now();
  DateTime reviewDeadlineDateTime = DateTime.now();

  String titleText = '';
  int maxScore = 0;
  int numberOfReviewers = 0;

  void wrapWith(
      {required String leftSide,
      required String rightSide,
      required TextEditingController controller}) {
    final text = controller.value.text;
    final selection = controller.selection;
    final middle = selection.textInside(text);
    final newText =
        '${selection.textBefore(text)}$leftSide$middle$rightSide${selection.textAfter(text)}';
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + leftSide.length + middle.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    createAssignmentState = ref.watch(createAssignmentViewControllerProvider);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double editorHeight = 300;

    ref.listen(createAssignmentViewControllerProvider, (prev, next) {
      if (next is AsyncData &&
          next.asData!.value is FailedToCreateAssignmentState) {
        Exception error =
            (next.asData!.value as FailedToCreateAssignmentState).error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error:$error'),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 2),
        ));
      } else if (next is AsyncData &&
          next.asData!.value is SuccessfullyCreatedAssignmentState) {
        AssignmentSummary createdAssignment =
            (next.asData!.value as SuccessfullyCreatedAssignmentState)
                .assignmentSummary;
        GoRouter.of(context)
            .pushReplacement('/assignment_detail/${widget.classroomCode}/${createdAssignment.assignmentId}');
      }
    });
    return createAssignmentState.when(
      data: (createAssignmentState) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                height: 100,
              ),
              Row(
                children: [
                  Container(
                      width: 0.2 * width,
                      height: 80,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Title :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    width: 0.8 * width - 30,
                    height: 80,
                    margin: EdgeInsets.all(15),
                    child: Form(
                      key: _formKeyTitle,
                      child: TextFormField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Title can\'t be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          titleText = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: width * 0.2,
                      height: editorHeight,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Instruction : ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: editorHeight,
                        ),
                        SizedBox(
                          width: (width * 0.8) / 2 - 30,
                          height: editorHeight,
                          child: Column(
                            children: [
                              Container(
                                width: (width * 0.8) / 2 - 30,
                                height: 40,
                                padding: EdgeInsets.all(3),
                                // color: Colors.blue,
                                child: markdownEdititems(_insController),
                              ),
                              Container(
                                width: (width * 0.8) / 2 - 30,
                                height: editorHeight - 40,
                                padding: EdgeInsets.all(20),
                                child: TextField(
                                  controller: _insController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 15,
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  onChanged: (text) {
                                    setState(() {
                                      _markdownTextInstruction = text;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          width: 5,
                          height: editorHeight,
                        ),
                        Container(
                          width: (width * 0.8) / 2 - 30,
                          height: editorHeight,
                          child: SingleChildScrollView(
                            child: Container(
                              height: editorHeight,
                              width: (width * 0.8) / 2 - 30,
                              padding: EdgeInsets.all(20),
                              child: Markdown(data: _markdownTextInstruction),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 0.2 * width,
                      height: editorHeight,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Description :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: editorHeight,
                        ),
                        SizedBox(
                          width: (width * 0.8) / 2 - 30,
                          height: editorHeight,
                          child: Column(
                            children: [
                              Container(
                                width: (width * 0.8) / 2 - 30,
                                height: 40,
                                padding: EdgeInsets.all(3),
                                // color: Colors.blue,
                                child: markdownEdititems(_descController),
                              ),
                              Container(
                                width: (width * 0.8) / 2 - 30,
                                height: editorHeight - 40,
                                padding: EdgeInsets.all(20),
                                child: TextField(
                                  controller: _descController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 15,
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  onChanged: (text) {
                                    setState(() {
                                      _markdownTextDescription = text;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          width: 5,
                          height: editorHeight,
                        ),
                        Container(
                          width: (width * 0.8) / 2 - 30,
                          height: editorHeight,
                          child: SingleChildScrollView(
                            child: Container(
                              height: editorHeight,
                              width: (width * 0.8) / 2 - 30,
                              padding: EdgeInsets.all(20),
                              child: Markdown(data: _markdownTextDescription),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 0.2 * width,
                      height: 80,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Max score :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    width: 0.8 * width - 30,
                    height: 80,
                    margin: EdgeInsets.all(15),
                    child: Form(
                      key: _formKeyMaxScore,
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Max score can't be empty";
                          }
                          if (int.parse(value) == 0 || int.parse(value) > 100) {
                            return "Score must be between 1 and 100.";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            maxScore = int.parse(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 0.2 * width,
                      height: 80,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Number of reviewers :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    width: 0.8 * width - 30,
                    height: 80,
                    margin: EdgeInsets.all(15),
                    child: Form(
                      key: _formKeyReviewerNumber,
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Number of reviewers can't be empty";
                          }
                          if (int.parse(value) > 100) {
                            return "Number of reviwers must be between 0 and 100.";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            numberOfReviewers = int.parse(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 0.2 * width,
                      height: 80,
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Submission deadline :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    width: 0.8 * width - 30,
                    height: 80,
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(15),
                          child: Text(
                              "${submissionDeadlineDateTime.hour.toString().padLeft(2, '0')}:${submissionDeadlineDateTime.minute.toString().padLeft(2, '0')}:${submissionDeadlineDateTime.second.toString().padLeft(2, '0')}  "
                              "${submissionDeadlineDateTime.day}/${submissionDeadlineDateTime.month}/${submissionDeadlineDateTime.year}"),
                        ),
                        Container(
                          height: 80,
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await pickDateTime();
                              if (date == null) return;
                              setState(() {
                                submissionDeadlineDateTime = date;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 0.2 * width,
                      height: 80,
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Review Deadline :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    width: 0.8 * width - 30,
                    height: 80,
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(15),
                          child: Text(
                              "${reviewDeadlineDateTime.hour.toString().padLeft(2, '0')}:${reviewDeadlineDateTime.minute.toString().padLeft(2, '0')}:${reviewDeadlineDateTime.second.toString().padLeft(2, '0')}  "
                              "${reviewDeadlineDateTime.day}/${reviewDeadlineDateTime.month}/${reviewDeadlineDateTime.year}"),
                        ),
                        Container(
                          height: 80,
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await pickDateTime();
                              if (date == null) return;
                              setState(() {
                                reviewDeadlineDateTime = date;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: width,
                height: 80,
                alignment: Alignment.center,
                child: Container(
                  width: 330,
                  height: 80,
                  child: Row(children: [
                    SizedBox(
                      width: 140,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 224, 224, 224),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 22, 22, 22),
                          ),
                        ),
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    SizedBox(
                      width: 140,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                        ),
                        child: Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (_formKeyTitle.currentState!.validate() &&
                              _formKeyMaxScore.currentState!.validate() &&
                              _formKeyReviewerNumber.currentState!.validate()) {

                                if(!reviewDeadlineDateTime.isAfter(submissionDeadlineDateTime)) {
                                  var snackBar = SnackBar(
                                              content: Text(
                                                  'Review deadline should be after submission deadline.'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                } else {

                              ref
                                  .read(createAssignmentViewControllerProvider
                                      .notifier)
                                  .createAssignment(
                                      widget.classroomCode,
                                      titleText,
                                      _markdownTextDescription,
                                      _markdownTextInstruction,
                                      maxScore,
                                      numberOfReviewers,
                                      submissionDeadlineDateTime
                                          .toUtc()
                                          .toString(),
                                      reviewDeadlineDateTime.toUtc().toString());
                                }
                          }
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (e, s) => Scaffold(
          body: Center(
        child: Text("Error"),
      )),
      loading: () => Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return dateTime;
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2060),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

  ListView markdownEdititems(TextEditingController controller) => ListView(
        shrinkWrap: true,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: [
          ElevatedButton(
            child: Icon(Icons.format_size_rounded),
            onPressed: () =>
                wrapWith(leftSide: '# ', rightSide: '', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.format_bold),
            onPressed: () => wrapWith(
                leftSide: '**', rightSide: '**', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.list),
            onPressed: () =>
                wrapWith(leftSide: '- ', rightSide: '', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.format_italic),
            onPressed: () =>
                wrapWith(leftSide: '*', rightSide: '*', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.code),
            onPressed: () => wrapWith(
                leftSide: '```', rightSide: '```', controller: controller),
          ),
        ],
      );
}
