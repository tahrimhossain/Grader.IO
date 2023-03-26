import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Views/created_classrooms_view.dart';
import 'package:grader_io/Views/joined_classrooms_view.dart';
import 'package:grader_io/Views/log_in_view.dart';
import 'package:grader_io/Views/register_view.dart';
import 'package:grader_io/Views/summary_of_assignmnets_view.dart';
import 'package:grader_io/Models/classroom.dart';
import 'Controllers/auth_state_controller.dart';
import 'Views/scaffold_with_bottom_nav_bar.dart';
import 'Views/splash_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

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
            ShellRoute(
                navigatorKey: _shellNavigatorKey,
                builder:
                    (BuildContext context, GoRouterState state, Widget child) {
                  return ScaffoldWithBottomNavBar(child: child);
                },
                routes: <RouteBase>[
                  GoRoute(
                    parentNavigatorKey: _shellNavigatorKey,
                    name: 'created_classrooms',
                    path: '/created_classrooms',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: CreatedClassroomsView(),
                    ),
                  ),
                  GoRoute(
                    parentNavigatorKey: _shellNavigatorKey,
                    name: 'joined_classrooms',
                    path: '/joined_classrooms',
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: JoinedClassroomsView(),
                    ),
                  ),
                ]),
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
              path: '/summary_of_assignments',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return NoTransitionPage(child: SummaryOfAssignmentsView(classroom: state.extra as Classroom,));
              },
            ),
          ],
          redirect: (context, state) {
            if (ref.read(authStateController.notifier).isInitialized == true &&
                ref.read(authStateController.notifier).isLoggedIn == false &&
                !(state.subloc == '/login' ||
                    state.subloc == '/register')) {

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
