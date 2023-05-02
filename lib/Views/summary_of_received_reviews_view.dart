// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../Controllers/summary_of_received_reviews_view_controller.dart';
import '../Models/summary_of_submission_reviews.dart';

class SummaryOfReceivedReviewsView extends ConsumerStatefulWidget {
  final int assignmentId;

  const SummaryOfReceivedReviewsView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  SummaryOfReceivedReviewsViewState createState() =>
      SummaryOfReceivedReviewsViewState();
}

class SummaryOfReceivedReviewsViewState
    extends ConsumerState<SummaryOfReceivedReviewsView> {
  late AsyncValue<SummaryOfSubmissionReviews> summaryOfReceivedReviews;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfReceivedReviewsViewControllerProvider.notifier)
        .fetchReceivedReviews(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    summaryOfReceivedReviews =
        ref.watch(summaryOfReceivedReviewsViewControllerProvider);

    return summaryOfReceivedReviews.when(
      data: (summaryOfReceivedReviews) => summaryOfReceivedReviews
              .reviews!.isEmpty
          ? Center(
              child: Text("No reviews recieved"),
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
                      for (int idx = 0;
                          idx < summaryOfReceivedReviews.reviews!.length;
                          idx++)
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
                                            "Review ${idx + 1}",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
                                  summaryOfReceivedReviews
                                              .reviews![idx].email ==
                                          null
                                      ? SizedBox(height: 0)
                                      : Expanded(
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
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: Text(
                                                          "Email: ",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ))),
                                                Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          summaryOfReceivedReviews
                                                              .reviews![idx]
                                                              .email!,
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
                                  summaryOfReceivedReviews.reviews![idx].name ==
                                          null
                                      ? SizedBox(height: 0)
                                      : Expanded(
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
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: Text(
                                                          "Name: ",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ))),
                                                Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          summaryOfReceivedReviews
                                                              .reviews![idx]
                                                              .name!,
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
                                  summaryOfReceivedReviews
                                              .reviews![idx].score ==
                                          null
                                      ? SizedBox(height: 0)
                                      : Expanded(
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
                                                            const EdgeInsets
                                                                .all(3),
                                                        child: Text(
                                                          "Score: ",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ))),
                                                Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "${summaryOfReceivedReviews.reviews![idx].score} / ${summaryOfReceivedReviews.reviews![idx].maxScore}",
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
                              GoRouter.of(context).push(
                                  '/review_detail/${summaryOfReceivedReviews.reviews![idx].reviewId}');
                            },
                          ),
                        ),
                    ],
                  )),
            ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
