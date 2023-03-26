
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../Controllers/register_view_controller.dart';

class RegisterView extends ConsumerStatefulWidget {

  const RegisterView({Key? key})
      : super(key: key);

  @override
  LogInViewState createState() =>
      LogInViewState();
}


class LogInViewState extends ConsumerState<RegisterView> {
  TextEditingController emailEdit = TextEditingController();
  TextEditingController nameEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AsyncValue<RegisterState> registerState;

  @override
  Widget build(BuildContext context) {

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
      data: (registerState)=> Scaffold(
        body: ListView(
          padding: EdgeInsets.only(top: (250/812)*MediaQuery.of(context).size.height, left: (30/375)*MediaQuery.of(context).size.width, right: (30/375)*MediaQuery.of(context).size.width),
          children: <Widget>[
            Column(children: <Widget>[
              const Center(
                child: Text("Grader.IO",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                        color: Colors.blue)
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
                      controller: nameEdit,
                      validator: (val) {
                        if (val != null) {
                          return null;
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
                      borderRadius: BorderRadius.circular(25.0),
                      gradient: const LinearGradient(colors: [
                        Color(0xff43CBFF),
                        Color(0xff9708CC),
                      ])),
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
                    ref.read(registerViewControllerProvider.notifier).register(emailEdit.text.toString(),nameEdit.text.toString(),passwordEdit.text.toString());
                  }
                },
              ),
              SizedBox(
                height: (10/812)*MediaQuery.of(context).size.height,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account?"),
                  GestureDetector(
                    child: const Text(
                      "Log In.",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      GoRouter.of(context).go('/login');
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