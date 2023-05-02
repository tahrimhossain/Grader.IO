// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/assignment_grade_view_controller.dart';
import '../Models/grade.dart';

class AssignmentGradeView extends ConsumerStatefulWidget {
  final int assignmentId;


  const AssignmentGradeView({Key? key, required this.assignmentId}) : super(key: key);

  @override
  AssignmentGradeViewState createState() => AssignmentGradeViewState();
}

class AssignmentGradeViewState extends ConsumerState<AssignmentGradeView> {
  late AsyncValue<Grade> grade;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(assignmentGradeViewControllerProvider.notifier)
        .fetchAssignmentGrade(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    grade = ref.watch(assignmentGradeViewControllerProvider);

    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    return grade.when(
      data: (grade) => SingleChildScrollView(
        child: SizedBox(
          height: max(350, height - 150),
          width: width,
          child: Center(
            child: Container(
              height: 350,
              width: min(width, 350),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Color.fromARGB(151, 146, 146, 146),
                  ),
                  borderRadius: BorderRadius.circular(20.0), //
                ),
                color: Color.fromARGB(200, 255, 255, 255),
                elevation: 5.0,
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // add this
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1, 
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  "Evaluation Score: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    
                                  ),
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  grade.evaluationScore!.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    
                                  ),
                                )
                              )
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      )
                    ),
                    
                    Expanded(
                      flex: 1, 
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  "Review Score: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    
                                  ),
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  grade.reviewScore!.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    
                                  ),
                                )
                              )
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      )
                    ),
                  
                    Expanded(
                      flex: 1, 
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  "Predicted Score: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    
                                  ),
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  grade.predictedScore!.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    
                                  ),
                                )
                              )
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      )
                    ),
                    
                    Expanded(
                      flex: 1, 
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  "Final Score: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    
                                  ),
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  grade.finalScore!.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    
                                  ),
                                )
                              )
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      )
                    ), 
            

                    Expanded(
                      flex: 1, 
                      child: Container(
                        padding: EdgeInsets.all(3),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                child: Text(
                                  "Max Score: ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    
                                  ),
                                )
                              )
                            ),
                            Expanded(
                              flex: 1,                              
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  grade.maxScore!.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    
                                  ),
                                )
                              )
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      )
                    ),
                  
                  ],
                ),
              ),
                  
            ),
          ),
        ),
      ),
      error: (e, s) => Center(
        child: Text(e.toString().substring(11)),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}