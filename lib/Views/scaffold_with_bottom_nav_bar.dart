import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Models/user_info.dart';

import '../Controllers/auth_state_controller.dart';
import '../Controllers/user_profile_view_controller.dart';
import '../Services/secure_storage_service.dart';

class ScaffoldWithBottomNavBar extends ConsumerStatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNavBar({Key? key, required this.child})
      : super(key: key);

  @override
  ScaffoldWithBottomNavBarState createState() =>
      ScaffoldWithBottomNavBarState();
}

class ScaffoldWithBottomNavBarState
    extends ConsumerState<ScaffoldWithBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<UserInfo> userInfo =
        ref.watch(userProfileViewControllerProvider);

    return Scaffold(
      onDrawerChanged: (isOpened) {
        if (isOpened == true) {
          ref.read(userProfileViewControllerProvider.notifier).fetchUserInfo();
        }
      },
      appBar: AppBar(
        title: const Text("Grader.IO",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            userInfo.when(
              data: (userInfo) => UserAccountsDrawerHeader(
                accountName: Text(userInfo.name!),
                accountEmail: Text(userInfo.email!),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                ),
              ),
              error: (e, stacktrace) => const UserAccountsDrawerHeader(
                accountName: Text("Error Loading Info"),
                accountEmail: SizedBox(),
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
              ),
              loading: () => const UserAccountsDrawerHeader(
                accountName: Text("Loading..."),
                accountEmail: SizedBox(),
                currentAccountPicture: CircleAvatar(
                  child: Icon(Icons.person),
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
              ),
            ),
            ListTile(
              title: const Text("Sign Out"),
              onTap: () async {
                await ref
                    .read(secureStorageServiceProvider)
                    .deleteAccessToken();
                ref
                    .read(authStateController.notifier)
                    .changeStatusToLoggedOut();
              },
            ),
          ],
        ),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex:
              GoRouter.of(context).location == "/created_classrooms" ? 0 : 1,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: "Created"),
            BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions), label: "Joined"),
          ],
          onTap: (index) {
            if (index == 0) {
              GoRouter.of(context).go('/created_classrooms');
            } else if (index == 1) {
              GoRouter.of(context).go('/joined_classrooms');
            }
          }),
    );
  }
}
