// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../Controllers/register_view_controller.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  LogInViewState createState() => LogInViewState();
}

class LogInViewState extends ConsumerState<RegisterView> {
  TextEditingController emailEdit = TextEditingController();
  TextEditingController nameEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AsyncValue<RegisterState> registerState;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    registerState = ref.watch(registerViewControllerProvider);

    ref.listen(registerViewControllerProvider, (prev, next) {
      if (next is AsyncData && next.asData!.value is FailedToRegisterState) {
        Exception error = (next.asData!.value as FailedToRegisterState).error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $error'),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 2),
        ));
      }
    });

    return registerState.when(
      data: (registerState) => Scaffold(
        body: SingleChildScrollView(
            child: SizedBox(
          height: max(650, height - 150),
          width: width,
          child: Center(
            child: Column(children: <Widget>[
              SizedBox(
                width: 600,
                height: max(20, (height - 650) / 2),
              ),
              Container(
                height: 130,
                width: 600,
                padding: EdgeInsets.all(20),
                child: const Center(
                  child: Text("Grader.IO",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 80,
                          color: Colors.blueGrey)),
                ),
              ),
              SizedBox(
                height: 10,
                width: 600,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 600,
											height: 110,
											padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
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
                    ),
                    Container(
                      width: 600,
											height: 110,
											padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        controller: nameEdit,
                        validator: (val) {
                          if (val != null) {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(),
                          ),
                        ),
                      ),
                    ),                    
                    Container(
                      width: 600,
											height: 110,
											padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordEdit,
                        validator: (val) {
                          if (val != null) {
                            return val.length > 6
                                ? null
                                : "password has to have 6+ characters";
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
                    ),
                  ],
                ),
              ),
              Container(
                height: 70,
								width: 600,
								padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: GestureDetector(
                  child: Container(
                    height: (50 / 812) * MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (_formKey.currentState!.validate() == true) {
                      ref.read(registerViewControllerProvider.notifier).register(
                          emailEdit.text.toString(),
                          nameEdit.text.toString(),
                          passwordEdit.text.toString());
                    }
                  },
                ),
              ),
              Container(
                height: 50,
								width: 600,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account? "),
                    GestureDetector(
                      child: const Text(
                        "Log In.",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      onTap: () {
                        GoRouter.of(context).go('/login');
                      },
                    )
                  ],
                ),
              ),
            ]),
          ),
        )),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => const Scaffold(
        body: Center(
          child: Text("Error"),
        ),
      ),
    );
  }
}
