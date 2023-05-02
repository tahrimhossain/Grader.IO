// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/created_classrooms_view_controller.dart';
import 'package:grader_io/Controllers/summary_of_assignments_view_controller.dart';
import 'package:grader_io/Models/summary_of_assignments.dart';
import 'package:intl/intl.dart';

import '../Controllers/joined_classrooms_view_controller.dart';
import '../Models/classroom.dart';

class SummaryOfAssignmentsView extends ConsumerStatefulWidget {
  final String classroomCode;
  final String classroomName;

  const SummaryOfAssignmentsView(
      {Key? key, required this.classroomCode, required this.classroomName})
      : super(key: key);

  @override
  SummaryOfAssignmentsViewState createState() =>
      SummaryOfAssignmentsViewState();
}

class SummaryOfAssignmentsViewState
    extends ConsumerState<SummaryOfAssignmentsView> {
  late AsyncValue<SummaryOfAssignments> summaryOfAssignments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfAssignmentsViewControllerProvider.notifier)
        .fetchAssignments(widget.classroomCode));
  }

  var assignmentStates = {
    'accepting_submissions': 'Accepting Submissions',
    'accepting_reviews': 'Accepting Reviews',
    'grades_assigned': 'Grades Assigned',
    'grades_finalised': 'Grades Finalised'
  };

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    summaryOfAssignments =
        ref.watch(summaryOfAssignmentsViewControllerProvider);

    return summaryOfAssignments.when(
      data: (summaryOfAssignments) => Scaffold(
        appBar: AppBar(
          title: Text(widget.classroomName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          leading: GoRouter.of(context).canPop()?IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if(GoRouter.of(context).location.startsWith("/summary_of_assignments_in_created_classroom")){
                ref.read(createdClassroomsViewControllerProvider.notifier).fetchCreatedClassrooms();
              }else{
                ref.read(joinedClassroomsViewControllerProvider.notifier).fetchJoinedClassrooms();
              }

              GoRouter.of(context).pop();

            },
          ):null,
        ),
        floatingActionButton: GoRouter.of(context).location.startsWith(
                    "/summary_of_assignments_in_created_classroom") ==
                true
            ? FloatingActionButton(
                onPressed: () {
                  GoRouter.of(context)
                      .push('/create_assignment/${widget.classroomCode}');
                },
                tooltip: "Create Assignment",
                child: const Icon(Icons.add),
              )
            : null,
        body: summaryOfAssignments.assignments!.isEmpty
            ? Center(
                child: Text('No assignments created'),
              )
            : SingleChildScrollView(
                child: Container(
                    height: height,
                    width: width,
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: width ~/ 350,
                      childAspectRatio: 1.2,
                      children: <Widget>[
                        for (var item in summaryOfAssignments.assignments!)
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              child: Card(
                                color: Colors.blueGrey,
                                elevation: 10.0,
                                shadowColor: Colors.black,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min, // add this
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.all(15),
                                          child: Text(
                                            item.title!,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: Text(
                                                        "State: ",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ))),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        assignmentStates[item
                                                            .currentState!]!,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: Text(
                                                        "Submission Deadline: ",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ))),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        DateFormat(
                                                                'HH:mm dd-MM-yyyy')
                                                            .format(item
                                                                .submissionDeadline!),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      child: Text(
                                                        "Review Deadline: ",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ))),
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                        DateFormat(
                                                                'HH:mm dd-MM-yyyy')
                                                            .format(item
                                                                .reviewDeadline!),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                      ))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              onTap: () {
                                if (GoRouter.of(context).location.startsWith(
                                        "/summary_of_assignments_in_created_classroom") ==
                                    true) {
                                  GoRouter.of(context).push(
                                      '/assignment_detail/${item.assignmentId}');
                                } else {
                                  GoRouter.of(context).push(
                                      '/assignment_info/${item.assignmentId}');
                                }
                              },
                            ),
                          ),
                      ],
                    )),
              ),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(
          title: Text(widget.classroomName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Text(e.toString()),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(widget.classroomName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
