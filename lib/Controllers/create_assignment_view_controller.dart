import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/assignment_summary.dart';

import '../Exceptions/token_expired.dart';
import '../Exceptions/token_not_found.dart';
import '../Services/api.dart';
import 'auth_state_controller.dart';

class CreateAssignmentState{}
class ReadyToCreateAssignmentState extends CreateAssignmentState{}
class SuccessfullyCreatedAssignmentState extends CreateAssignmentState{
  AssignmentSummary assignmentSummary;
  SuccessfullyCreatedAssignmentState({required this.assignmentSummary});
}
class FailedToCreateAssignmentState extends CreateAssignmentState{
  Exception error;
  FailedToCreateAssignmentState({required this.error});
}


final createAssignmentViewControllerProvider =
StateNotifierProvider.autoDispose<CreateAssignmentViewNotifier, AsyncValue<CreateAssignmentState>>((ref) {
  return CreateAssignmentViewNotifier(ref: ref);
});

class CreateAssignmentViewNotifier extends StateNotifier<AsyncValue<CreateAssignmentState>> {
  Ref ref;

  CreateAssignmentViewNotifier({required this.ref}) : super(AsyncData(ReadyToCreateAssignmentState()));

  Future<void> createAssignment(String code, String title,String description, String instructions, int maxScore, int numberOfReviewersPerSubmission, String submissionDeadline, String reviewDeadline) async {
    state = const AsyncLoading();
    try {
      AssignmentSummary createdAssignment = await ref.read(apiProvider).createAssignment(code,title,description,instructions,maxScore,numberOfReviewersPerSubmission,submissionDeadline,reviewDeadline);
      state = AsyncData(SuccessfullyCreatedAssignmentState(assignmentSummary: createdAssignment));
    }on TokenNotFoundException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }on TokenExpiredException catch(e){
      ref.read(authStateController.notifier).changeStatusToLoggedOut();
    }catch (e){
      state = AsyncData(FailedToCreateAssignmentState(error: e as Exception));
    }
  }
}
