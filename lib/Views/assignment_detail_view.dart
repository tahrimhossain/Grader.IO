import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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

  @override
  Widget build(BuildContext context) {

    return Center(child:Text(widget.assignmentId.toString()) ,);

  }
}