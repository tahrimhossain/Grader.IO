// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Controllers/assignment_detail_view_controller.dart';
import 'package:grader_io/Models/assignment_detail.dart';
import 'package:intl/intl.dart';


class AssignmentDetailView extends ConsumerStatefulWidget {
  final int assignmentId;

  const AssignmentDetailView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  AssignmentDetailViewState createState() =>
      AssignmentDetailViewState();
}

class AssignmentDetailViewState
    extends ConsumerState<AssignmentDetailView> {

  late AsyncValue<AssignmentDetail> assignmentDetail;

  var assignmentStates = {'accepting_submissions' : 'Accepting Submissions', 
                          'accepting_reviews' : 'Accepting Reviews', 
                          'grades_assigned' : 'Grades Assigned',
                          'grades_finalised' : 'Grades Finalised'};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(assignmentDetailViewControllerProvider.notifier)
        .fetchAssignmentDetail(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;


    assignmentDetail =
        ref.watch(assignmentDetailViewControllerProvider);

    return assignmentDetail.when(
      data: (assignmentDetail) => SingleChildScrollView(
        child: Column(
        children: [
          Container(width: width, height: 100,),
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
                )
              ),
              Container(
                width: 0.8 * width - 30,
                height: 80,
                padding: EdgeInsets.all(15),
                child: SelectableText(
                  assignmentDetail.title!,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: width * 0.2, 
                constraints: BoxConstraints(minHeight: 50),
                padding: EdgeInsets.all(15),
                child: Text(
                  "Instruction :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: EdgeInsets.all(5),
                width: (width * 0.8) - 30,
                constraints: BoxConstraints(minHeight: 50),
                color: Color.fromARGB(255, 228, 228, 228),
                child:  MarkdownBody(
                  selectable: true,
                  data: assignmentDetail.instructions!,
                )
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: width * 0.2, 
                    constraints: BoxConstraints(minHeight: 50),
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Description :",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    )
                  ),
                   
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: EdgeInsets.all(5),
                    width: (width * 0.8) - 30,
                    constraints: BoxConstraints(minHeight: 50),
                    color: Color.fromARGB(255, 228, 228, 228),
                    child:  MarkdownBody(
                      selectable: true,
                      data: assignmentDetail.description!,
                      
                    )
                  ),
                ],
              ),
              
            ],
          ),
          Row(
            children: [
              Container(
                width: 0.2 * width, 
                height: 80, 
                padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
                child: Text(
                  "Max score :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
              ),
              Container(
                width: 0.8 * width - 30,
                height: 80,
                padding: EdgeInsets.fromLTRB(15, 30, 15, 15),
                child: SelectableText(
                  assignmentDetail.maxScore!.toString(),
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
                  "State :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
              ),
              Container(
                width: 0.8 * width - 30,
                height: 80,
                padding: EdgeInsets.all(15),
                child: SelectableText(
                  assignmentStates[assignmentDetail.currentState!]!,
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
                  "Submission Deadline :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
              ),
              Container(
                width: 0.8 * width - 30,
                height: 80,
                padding: EdgeInsets.all(15),
                child: SelectableText(
                  DateFormat('HH:mm dd-MM-yyyy').format(assignmentDetail.submissionDeadline!),
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
                  "Review Deadline :",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
              ),
              Container(
                width: 0.8 * width - 30,
                height: 80,
                padding: EdgeInsets.all(15),
                child: SelectableText(
                  DateFormat('HH:mm dd-MM-yyyy').format(assignmentDetail.reviewDeadline!),
                ),
              ),
            ],
          ),
          ],
        ),
      ), 
      error: (e, s) => Center(
          child: Text(e.toString()),
        ),
      loading: () => const Center(child: CircularProgressIndicator()),

    );

  }
}