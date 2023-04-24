// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Controllers/submission_grade_view_controller.dart';
import '../Models/submission_grade.dart';

class SubmissionGradeView extends ConsumerStatefulWidget {
  final int submissionId;

  const SubmissionGradeView({Key? key, required this.submissionId})
      : super(key: key);

  @override
  SubmissionGradeViewState createState() => SubmissionGradeViewState();
}

class SubmissionGradeViewState extends ConsumerState<SubmissionGradeView> {

  bool showEditScore = false;
  int currentFinalScore = 0;

  final scoreEditController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late AsyncValue<SubmissionGrade> submissionGrade;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(submissionGradeViewControllerProvider.notifier)
        .fetchSubmissionGrade(widget.submissionId));
  }

  @override
  Widget build(BuildContext context) {
    submissionGrade = ref.watch(submissionGradeViewControllerProvider);

    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    return submissionGrade.when(
      data: (submissionGrade) {
        currentFinalScore = submissionGrade.grade!.finalScore!;
        
        return SingleChildScrollView(
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
                                  submissionGrade.grade!.evaluationScore!.toString(),
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
                                  submissionGrade.grade!.reviewScore!.toString(),
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
                                  submissionGrade.grade!.predictedScore!.toString(),
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
                    
                    !(submissionGrade.assignmentState ==  'grades_assigned') ? 
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
                                  submissionGrade.grade!.finalScore!.toString(),
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
                    ) 
                    :
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
                              child: showEditScore ?
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Form(
                                        key: formKey,
                                        child: TextFormField(
                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.blueGrey),
                                            ),
                                          ),
                                          validator: (value) {
                                            currentFinalScore = int.parse(value.toString());
                                            if(int.parse(value.toString()) > submissionGrade.grade!.maxScore!) {
                                              var snackBar = SnackBar(content: Text('Score should be less than or equal to max score.'));
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              return null;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1, 
                                      child: IconButton(
                                        icon: Icon(Icons.check),
                                        onPressed: () {
                                          if(formKey.currentState!.validate() && currentFinalScore <= submissionGrade.grade!.maxScore!) {
                                            setState(() {
                                              showEditScore ^= true;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1, 
                                      child: IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          setState(() {
                                            showEditScore ^= true;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ) 
                              :
                              Container(
                                // color: Colors.blue,
                                width: double.infinity,
                                padding: const EdgeInsets.all(3),
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 100,
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        // color: Colors.amber,
                                        child: Text(
                                          currentFinalScore.toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        alignment: Alignment.centerRight,
                                        // color: Colors.orange,
                                        child: IconButton(
                                          icon: Icon(Icons.edit),
                                          hoverColor: Colors.grey,
                                          focusColor: Colors.black,
                                          onPressed: () {
                                            setState(() {
                                              showEditScore ^= true;  
                                            });                                      
                                          },
                                        ),
                                      ),
                                    ],
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
                                  submissionGrade.grade!.maxScore!.toString(),
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
      ); },
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
