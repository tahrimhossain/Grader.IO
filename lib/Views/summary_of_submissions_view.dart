// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/summary_of_submissions_view_controller.dart';
import 'package:intl/intl.dart';

import '../Models/summary_of_submissions.dart';

class SummaryOfSubmissionsView extends ConsumerStatefulWidget {
  final int assignmentId;

  const SummaryOfSubmissionsView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  SummaryOfSubmissionsViewState createState() =>
      SummaryOfSubmissionsViewState();
}

class SummaryOfSubmissionsViewState
    extends ConsumerState<SummaryOfSubmissionsView> {
  late AsyncValue<SummaryOfSubmissions> summaryOfSubmissions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfSubmissionsViewControllerProvider.notifier)
        .fetchSummaryOfSubmissions(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    String? submissionTime = "12:35 3/5/2023";


    summaryOfSubmissions =
        ref.watch(summaryOfSubmissionsViewControllerProvider);

    return summaryOfSubmissions.when(
      data: (summaryOfSubmissions) => SingleChildScrollView(
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
              
              for (int idx = 0; idx < summaryOfSubmissions.submissions!.length; idx++)
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
                            flex: 2, 
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Submission ${idx+1}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              )
                            )
                          ),
                          summaryOfSubmissions.submissions![idx].submissionTime == null ? SizedBox(height: 0) : Expanded(
                            flex: 1, 
                            child: Container(
                              padding: EdgeInsets.all(3),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Expanded(
                                    flex: 1,                              
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                        "Submission Time: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
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
                                        DateFormat('HH:mm dd-MM-yyyy').format(summaryOfSubmissions.submissions![idx].submissionTime!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                        ),
                                      )
                                    )
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            )
                          ),

                        
                          summaryOfSubmissions.submissions![idx].email == null ? SizedBox(height: 0) : Expanded(
                              flex: 1, 
                              child: Container(
                                padding: EdgeInsets.all(3),
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    SizedBox(width: 10,),
                                    Expanded(
                                      flex: 1,                              
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          "Email: ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
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
                                          summaryOfSubmissions.submissions![idx].email!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black
                                          ),
                                        )
                                      )
                                    ),
                                    SizedBox(width: 10,),
                                  ],
                                ),
                              )
                            ),

                          summaryOfSubmissions.submissions![idx].name == null ? SizedBox(height: 0) : Expanded(
                            flex: 1, 
                            child: Container(
                              padding: EdgeInsets.all(3),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  SizedBox(width: 10,),
                                  Expanded(
                                    flex: 1,                              
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                        "Name: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
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
                                        summaryOfSubmissions.submissions![idx].name!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                        ),
                                      )
                                    )
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            )
                          ),

                          summaryOfSubmissions.submissions![idx].evaluationScore == null ? SizedBox(height: 0) : Expanded(
                            flex: 1, 
                            child: Container(
                              padding: EdgeInsets.all(3),
                              color: Colors.white,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
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
                                        "${summaryOfSubmissions.submissions![idx].evaluationScore} / ${summaryOfSubmissions.submissions![idx].maxScore}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                        ),
                                      )
                                    )
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            )
                          ),

                          summaryOfSubmissions.submissions![idx].reviewScore == null ? SizedBox(height: 0) : Expanded(
                            flex: 1, 
                            child: Container(
                              padding: EdgeInsets.all(3),
                              color: Colors.white,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
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
                                        "${summaryOfSubmissions.submissions![idx].reviewScore} / ${summaryOfSubmissions.submissions![idx].maxScore}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                        ),
                                      )
                                    )
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            )
                          ),


                          summaryOfSubmissions.submissions![idx].predictedScore == null ? SizedBox(height: 0) : Expanded(
                            flex: 1, 
                            child: Container(
                              padding: EdgeInsets.all(3),
                              color: Colors.white,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
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
                                        "${summaryOfSubmissions.submissions![idx].predictedScore} / ${summaryOfSubmissions.submissions![idx].maxScore}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
                                        ),
                                      )
                                    )
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            )
                          ),

                          summaryOfSubmissions.submissions![idx].finalScore == null ? SizedBox(height: 0) : Expanded(
                            flex: 1, 
                            child: Container(
                              padding: EdgeInsets.all(3),
                              color: Colors.white,
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
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
                                        "${summaryOfSubmissions.submissions![idx].finalScore} / ${summaryOfSubmissions.submissions![idx].maxScore}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black
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
                  onTap: () {
                    GoRouter.of(context).push(
                                '/submission_detail/${summaryOfSubmissions.submissions![idx].submissionId}');
                  },
                ),
              ),
              ],
            )
          ),
        ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
