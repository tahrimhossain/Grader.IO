import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Models/assignment_summary.dart';

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

  @override
  Widget build(BuildContext context) {

    return Center(child:Text(widget.assignmentId.toString()!) ,);

  }
}