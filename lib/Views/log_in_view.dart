import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/log_in_view_controller.dart';


class LogInView extends ConsumerStatefulWidget {

  const LogInView({Key? key})
      : super(key: key);

  @override
  LogInViewState createState() =>
      LogInViewState();
}


class LogInViewState extends ConsumerState<LogInView> {
  TextEditingController emailEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AsyncValue<LogInState> logInState;



  @override
  Widget build(BuildContext context) {

    logInState = ref.watch(logInViewControllerProvider);

    ref.listen(logInViewControllerProvider, (prev, next) {
      if (next is AsyncData && next.asData!.value is FailedToLogInState) {
        Exception error = (next.asData!.value as FailedToLogInState).error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error:$error'),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 2),
        ));
      }
    });

    return logInState.when(
        data: (logInState)=> Scaffold(
          body: ListView(
            padding: EdgeInsets.only(top: (250/812)*MediaQuery.of(context).size.height, left: (30/375)*MediaQuery.of(context).size.width, right: (30/375)*MediaQuery.of(context).size.width),
            children: <Widget>[
              Column(children: <Widget>[
                const Center(
                  child: Text("Grader.IO",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          color: Colors.blueGrey)
                  ),
                ),
                SizedBox(
                  height: (20/812)*MediaQuery.of(context).size.height,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: emailEdit,
                        validator: (val) {
                          if (val != null) {
                            return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val)
                                ? null
                                : "Please Enter Correct Email";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: (40.0/812)*MediaQuery.of(context).size.height,
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordEdit,
                        validator: (val) {
                          if (val != null) {
                            return null;
                          }else{
                            return "Please give a password";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: (40.0/812)*MediaQuery.of(context).size.height,
                ),
                GestureDetector(
                  child: Container(
                    height: (50/812)*MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(25.0),
                        ),
                    child: const Center(
                      child: Text(
                        "Log In",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (_formKey.currentState!.validate() == true) {
                      ref.read(logInViewControllerProvider.notifier).logIn(emailEdit.text.toString(),passwordEdit.text.toString());
                    }
                  },
                ),
                SizedBox(
                  height: (10/812)*MediaQuery.of(context).size.height,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Haven't registered yet?"),
                    GestureDetector(
                      child: const Text(
                        "Register now.",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      onTap: () {
                        GoRouter.of(context).go('/register');
                      },
                    )
                  ],
                ),
              ])
            ],
          ),
        ),
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator()),),
        error: (e, s) => const Scaffold(body: Center(child: Text("Error"),),),
    );
  }
}