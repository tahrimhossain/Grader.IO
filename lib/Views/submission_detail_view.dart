// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../Controllers/submission_detail_view_controller.dart';
import '../Models/submission_detail.dart';

class SubmissionDetailView extends ConsumerStatefulWidget {
  final int submissionId;

  const SubmissionDetailView({Key? key, required this.submissionId})
      : super(key: key);

  @override
  SubmissionDetailViewState createState() => SubmissionDetailViewState();
}

class SubmissionDetailViewState extends ConsumerState<SubmissionDetailView> {
  late AsyncValue<SubmissionDetail> submissionDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(submissionDetailViewControllerProvider.notifier)
        .fetchSubmissionDetail(widget.submissionId));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    submissionDetail = ref.watch(submissionDetailViewControllerProvider);

    return submissionDetail.when(
      data: (submissionDetail) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: width,
              height: 20,
            ),
            submissionDetail.email == null
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
                          submissionDetail.email!,
                        ),
                      ),
                    ],
                  ),
            submissionDetail.name == null
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
                          submissionDetail.name!,
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
                          "Contents :",
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
                          data: submissionDetail.content!,
                        )),
                  ],
                ),
              ],
            ),
            submissionDetail.submissionTime == null
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
                            "Submitted at :",
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
                          DateFormat('HH:mm dd-MM-yyyy')
                              .format(submissionDetail.submissionTime!),
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
