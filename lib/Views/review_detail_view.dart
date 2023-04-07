import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    reviewDetail =
        ref.watch(reviewDetailViewControllerProvider);

    return reviewDetail.when(
      data: (reviewDetail) =>Scaffold(
        appBar:AppBar(
          title: const Text("Grader.IO",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Markdown(data:reviewDetail.content!,selectable: true,),
        ),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),

    );

  }
}