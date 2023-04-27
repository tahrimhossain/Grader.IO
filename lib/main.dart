import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Views/assignment_detail_view.dart';
import 'package:grader_io/Views/create_assignment_view.dart';
import 'package:grader_io/Views/create_classroom_view.dart';
import 'package:grader_io/Views/created_classrooms_view.dart';
import 'package:grader_io/Views/join_classroom_view.dart';
import 'package:grader_io/Views/joined_classrooms_view.dart';
import 'package:grader_io/Views/log_in_view.dart';
import 'package:grader_io/Views/register_view.dart';
import 'package:grader_io/Views/review_detail_view.dart';
import 'package:grader_io/Views/created_review_view.dart';
import 'package:grader_io/Views/student_assignment_info_scaffold.dart';
import 'package:grader_io/Views/student_submission_info_scaffold.dart';
import 'package:grader_io/Views/submission_detail_view.dart';
import 'package:grader_io/Views/created_submission_view.dart';
import 'package:grader_io/Views/summary_of_assignments_view.dart';
import 'package:grader_io/Views/summary_of_received_reviews_view.dart';
import 'package:grader_io/Views/summary_of_submission_reviews_view.dart';
import 'package:grader_io/Views/summary_of_submissions_view.dart';
import 'package:grader_io/Views/teacher_assignment_info_scaffold.dart';
import 'Controllers/auth_state_controller.dart';
import 'Views/assignment_grade_view.dart';
import 'Views/created_and_joined_classrooms_scaffold.dart';
import 'Views/submission_grade_view.dart';
import 'Views/splash_screen.dart';
import 'Views/summary_of_assigned_reviews_view.dart';
import 'Views/teacher_submission_info_scaffold.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        primaryColor: Colors.blue,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          headlineMedium:
              TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
          displaySmall: TextStyle(
              fontSize: 14.0, fontFamily: 'Montserrat1', color: Colors.white),
          displayMedium: TextStyle(
              fontSize: 14.0, fontFamily: 'Montserrat', color: Colors.black54),
        ),
      ),
      routerConfig: GoRouter(
          navigatorKey: _rootNavigatorKey,
          refreshListenable: ref.watch(authStateController),
          routes: [
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              path: '/',
              builder: (BuildContext context, GoRouterState state) {
                return const SplashScreen();
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'created_classrooms',
              path: '/created_classrooms',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CreatedAndJoinedClassroomsScaffold(
                    child: CreatedClassroomsView()),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'create_classroom',
              path: '/create_classroom',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CreateClassroomView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'joined_classrooms',
              path: '/joined_classrooms',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CreatedAndJoinedClassroomsScaffold(
                    child: JoinedClassroomsView()),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'join_classroom',
              path: '/join_classroom',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: JoinClassroomView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'login',
              path: '/login',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage(child: LogInView());
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'register',
              path: '/register',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage(child: RegisterView());
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'summary_of_assignments_in_created_classroom',
              path:
                  '/summary_of_assignments_in_created_classroom/:classroomName/:classroomCode',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                    child: SummaryOfAssignmentsView(
                  classroomName: state.params['classroomName'] as String,
                  classroomCode: state.params['classroomCode'] as String,
                ));
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'create_assignment',
              path: '/create_assignment/:classroomCode',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                    child: CreateAssignmentView(
                        classroomCode:
                            state.params['classroomCode'] as String));
              },
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'summary_of_assignments_in_joined_classroom',
              path:
                  '/summary_of_assignments_in_joined_classroom/:classroomName/:classroomCode',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                    child: SummaryOfAssignmentsView(
                  classroomName: state.params['classroomName'] as String,
                  classroomCode: state.params['classroomCode'] as String,
                ));
              },
            ),
            GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                name: 'assignment_detail',
                path: '/assignment_detail/:assignmentId',
                pageBuilder: (context, state) => NoTransitionPage(
                        child: TeacherAssignmentInfoScaffold(
                      assignmentId: int.parse(state.params["assignmentId"]!),
                      child: AssignmentDetailView(
                          assignmentId:
                              int.parse(state.params["assignmentId"]!)),
                    ))),
            GoRoute(
                parentNavigatorKey: _rootNavigatorKey,
                name: 'assignment_info',
                path: '/assignment_info/:assignmentId',
                pageBuilder: (context, state) => NoTransitionPage(
                        child: StudentAssignmentInfoScaffold(
                      assignmentId: int.parse(state.params["assignmentId"]!),
                      child: AssignmentDetailView(
                          assignmentId:
                              int.parse(state.params["assignmentId"]!)),
                    ))),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'summary_of_submissions',
              path: '/summary_of_submissions/:assignmentId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherAssignmentInfoScaffold(
                  assignmentId: int.parse(state.params["assignmentId"]!),
                  child: SummaryOfSubmissionsView(
                      assignmentId: int.parse(state.params["assignmentId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'submission_detail',
              path: '/submission_detail/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherSubmissionInfoScaffold(
                  submissionId: int.parse(state.params["submissionId"]!),
                  child: SubmissionDetailView(
                      submissionId: int.parse(state.params["submissionId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'created_submission',
              path: '/created_submission/:assignmentId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: StudentAssignmentInfoScaffold(
                  assignmentId: int.parse(state.params["assignmentId"]!),
                  child: CreatedSubmissionView(
                      assignmentId: int.parse(state.params["assignmentId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'created_review',
              path: '/created_review/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: StudentSubmissionInfoScaffold(
                  submissionId: int.parse(state.params["submissionId"]!),
                  child: CreatedReviewView(submissionId: int.parse(state.params["submissionId"]!),),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'submission_grade',
              path: '/submission_grade/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherSubmissionInfoScaffold(
                  submissionId: int.parse(state.params["submissionId"]!),
                  child: SubmissionGradeView(
                      submissionId: int.parse(state.params["submissionId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'assignment_grade',
              path: '/assignment_grade/:assignmentId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: StudentAssignmentInfoScaffold(
                  assignmentId: int.parse(state.params["assignmentId"]!),
                  child: AssignmentGradeView(
                      assignmentId: int.parse(state.params["assignmentId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'summary_of_submission_reviews',
              path: '/summary_of_submission_reviews/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherSubmissionInfoScaffold(
                  submissionId: int.parse(state.params["submissionId"]!),
                  child: SummaryOfSubmissionReviewsView(
                      submissionId: int.parse(state.params["submissionId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'summary_of_assigned_reviews',
              path: '/summary_of_assigned_reviews/:assignmentId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: StudentAssignmentInfoScaffold(
                  assignmentId: int.parse(state.params["assignmentId"]!),
                  child: SummaryOfAssignedReviewsView(
                      assignmentId: int.parse(state.params["assignmentId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'submission_info',
              path: '/submission_info/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: StudentSubmissionInfoScaffold(
                  submissionId: int.parse(state.params["submissionId"]!),
                  child: SubmissionDetailView(
                      submissionId: int.parse(state.params["submissionId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'summary_of_received_reviews',
              path: '/summary_of_received_reviews/:assignmentId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: StudentAssignmentInfoScaffold(
                  assignmentId: int.parse(state.params["assignmentId"]!),
                  child: SummaryOfReceivedReviewsView(
                      assignmentId: int.parse(state.params["assignmentId"]!)),
                ),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'review_detail',
              path: '/review_detail/:reviewId',
              pageBuilder: (context, state) => NoTransitionPage(
                  child: ReviewDetailView(
                reviewId: int.parse(state.params["reviewId"]!),
              )),
            ),
          ],
          redirect: (context, state) {
            if (ref.read(authStateController.notifier).isInitialized == true &&
                ref.read(authStateController.notifier).isLoggedIn == false &&
                !(state.subloc == '/login' || state.subloc == '/register')) {
              return '/login';
            } else if (ref.read(authStateController.notifier).isInitialized ==
                    true &&
                ref.read(authStateController.notifier).isLoggedIn == true &&
                (state.subloc == '/login' ||
                    state.subloc == '/register' ||
                    state.subloc == '/')) {
              return '/created_classrooms';
            } else {
              return null;
            }
          }),
    );
  }
}
