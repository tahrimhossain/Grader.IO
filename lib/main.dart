import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Views/assignment_detail_view.dart';
import 'package:grader_io/Views/created_classrooms_view.dart';
import 'package:grader_io/Views/joined_classrooms_view.dart';
import 'package:grader_io/Views/log_in_view.dart';
import 'package:grader_io/Views/register_view.dart';
import 'package:grader_io/Views/review_detail_view.dart';
import 'package:grader_io/Views/submission_detail_view.dart';
import 'package:grader_io/Views/summary_of_assignmnets_view.dart';
import 'package:grader_io/Views/summary_of_submission_reviews_view.dart';
import 'package:grader_io/Views/summary_of_submissions_view.dart';
import 'package:grader_io/Views/teacher_assignment_info_scaffold.dart';
import 'Controllers/auth_state_controller.dart';
import 'Views/created_and_joined_classrooms_scaffold.dart';
import 'Views/grade_view.dart';
import 'Views/splash_screen.dart';
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
          initialLocation: '/splash',
          refreshListenable: ref.watch(authStateController),
          routes: [
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'created_classrooms',
              path: '/created_classrooms',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CreatedAndJoinedClassroomsScaffold(child: CreatedClassroomsView()),
              ),
            ),
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'joined_classrooms',
              path: '/joined_classrooms',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CreatedAndJoinedClassroomsScaffold(child: JoinedClassroomsView()),
              ),
            ),
            GoRoute(
              parentNavigatorKey: _rootNavigatorKey,
              name: 'splash',
              path: '/splash',
              builder: (BuildContext context, GoRouterState state) {
                return const SplashScreen();
              },
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
              name: 'summary_of_assignments',
              path: '/summary_of_assignments/:classroomName/:classroomCode',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(
                    child: SummaryOfAssignmentsView(
                  classroomName: state.params['classroomName'] as String,
                  classroomCode: state.params['classroomCode'] as String,
                ));
              },
            ),
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'assignment_detail',
              path: '/assignment_detail/:assignmentId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherAssignmentInfoScaffold(assignmentId:int.parse(state.params["assignmentId"]!) ,child: AssignmentDetailView(
                    assignmentId:
                    int.parse(state.params["assignmentId"]!)),
                ))
            ),
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'summary_of_submissions',
              path: '/summary_of_submissions/:assignmentId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherAssignmentInfoScaffold(assignmentId: int.parse(state.params["assignmentId"]!),child: SummaryOfSubmissionsView(
                    assignmentId:
                    int.parse(state.params["assignmentId"]!)),),
              ),
            ),
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'submission_detail',
              path: '/submission_detail/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherSubmissionInfoScaffold(submissionId: int.parse(state.params["submissionId"]!),child: SubmissionDetailView(
                    submissionId:
                    int.parse(state.params["submissionId"]!)),),
              ),
            ),
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'submission_grade',
              path: '/submission_grade/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherSubmissionInfoScaffold(submissionId: int.parse(state.params["submissionId"]!),child: GradeView(
                    submissionId:
                    int.parse(state.params["submissionId"]!)),),
              ),
            ),
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'summary_of_submission_reviews',
              path: '/summary_of_submission_reviews/:submissionId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: TeacherSubmissionInfoScaffold(submissionId: int.parse(state.params["submissionId"]!),child: SummaryOfSubmissionReviewsView(
                    submissionId:
                    int.parse(state.params["submissionId"]!)),),
              ),
            ),
            GoRoute(
              parentNavigatorKey:
              _rootNavigatorKey,
              name: 'review_detail',
              path: '/review_detail/:reviewId',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ReviewDetailView(reviewId:int.parse(state.params["reviewId"]!) ,)
              ),
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
                    state.subloc == '/splash')) {
              return '/created_classrooms';
            } else {
              return null;
            }
          }),
    );
  }
}
