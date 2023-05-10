// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../Controllers/review_detail_view_controller.dart';
import '../Models/review_detail.dart';

class ReviewDetailView extends ConsumerStatefulWidget {
  final int reviewId;

  const ReviewDetailView({Key? key, required this.reviewId})
      : super(key: key);

  @override
  ReviewDetailViewState createState() =>
      ReviewDetailViewState();
}

class ReviewDetailViewState
    extends ConsumerState<ReviewDetailView> {

  late AsyncValue<ReviewDetail> reviewDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(reviewDetailViewControllerProvider.notifier)
        .fetchReviewDetail(widget.reviewId));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    reviewDetail =
        ref.watch(reviewDetailViewControllerProvider);

    return reviewDetail.when(
      data: (reviewDetail) =>Scaffold(
        appBar:AppBar(
          title: const Text("Grader.IO",
              style: TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  fontSize: 18)),
          backgroundColor: Colors.blueGrey,
          iconTheme: const IconThemeData(color: Colors.white),
          toolbarHeight: 80,
        ),
        body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width,
              height: 20,
            ),
            reviewDetail.email == null
                ? SizedBox(
                    height: 0,
                  )
                : Row(
                    children: [
                      Container(
                          width: 0.2 * width,
                          height: 80,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Email :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )),
                      Container(
                        width: 0.8 * width - 30,
                        height: 80,
                        padding: EdgeInsets.all(15),
                        child: SelectableText(
                          reviewDetail.email!,
                        ),
                      ),
                    ],
                  ),
            reviewDetail.name == null
                ? SizedBox(
                    height: 0,
                  )
                : Row(
                    children: [
                      Container(
                          width: 0.2 * width,
                          height: 80,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Name :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )),
                      Container(
                        width: 0.8 * width - 30,
                        height: 80,
                        padding: EdgeInsets.all(15),
                        child: SelectableText(
                          reviewDetail.name!,
                        ),
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
                          "Comment :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.all(15.0),
                        padding: EdgeInsets.all(5),
                        width: (width * 0.8) - 30,
                        constraints: BoxConstraints(minHeight: 50),
                        color: Color.fromARGB(255, 228, 228, 228),
                        child: MarkdownBody(
                          selectable: true,
                          data: reviewDetail.content!,
                        )),
                  ],
                ),
              ],
            ),

            reviewDetail.score == null
                ? SizedBox(
                    height: 0,
                  )
                : Row(
                    children: [
                      Container(
                          width: 0.2 * width,
                          height: 80,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            "Score :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )),
                      Container(
                        width: 0.8 * width - 30,
                        height: 80,
                        padding: EdgeInsets.all(15),
                        child: SelectableText(
                          "${reviewDetail.score!}/${reviewDetail.maxScore!}",
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),

      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),

    );

  }
}