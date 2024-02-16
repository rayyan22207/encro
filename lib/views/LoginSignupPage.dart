import 'package:encro/authentication/api_auth.dart';
import 'package:encro/components/my_textField.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController password1Controller = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  bool obscurePassword = true;

  bool isLogin = true;

  void toggleLoginSignup() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    void auth_register() {
      if (isLogin) {
        print(emailController.text);
        print(passwordController.text);
        authProvider.login(emailController.text, passwordController.text);
      } else {
        authProvider.signup(
            emailController.text,
            password1Controller.text,
            usernameController.text,
            firstNameController.text,
            lastNameController.text);
      }
    }

    return Scaffold(
      //backgroundColor: const Color.fromARGB(255, 184, 181, 181),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.lock,
                      size: 30,
                    ),
                    Text(
                      isLogin ? 'Login' : 'Signup',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                isLogin
                    ? Column(
                        children: [
                          SizedBox(
                            height: 70,
                          ),
                          Text(
                            'Welcome back you\'ve been missed!',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 85),
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          MyPasswordTextfield(
                            controller: passwordController,
                            hintText: 'Password',
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Welcome to Encro!',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 15),
                          MyTextField(
                            controller: emailController,
                            hintText: 'Email',
                            obscureText: false,
                          ),
                          SizedBox(height: 5),
                          MyTextField(
                            controller: usernameController,
                            hintText: 'Username',
                            obscureText: false,
                          ),
                          SizedBox(height: 5),
                          MyTextField(
                            controller: firstNameController,
                            hintText: 'First Name',
                            obscureText: false,
                          ),
                          SizedBox(height: 5),
                          MyTextField(
                            controller: lastNameController,
                            hintText: 'Last Name',
                            obscureText: false,
                          ),
                          SizedBox(height: 5),
                          MyPasswordTextfield(
                            controller: password1Controller,
                            hintText: 'Password',
                          ),
                          SizedBox(height: 5),
                          MyPasswordTextfield(
                            controller: passwordController,
                            hintText: 'Confirm Password',
                          ),
                        ],
                      ),
                Column(
                  children: [
                    Center(
                      child: isLogin
                          ? Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // Center the row
                              children: [
                                TextButton(
                                  onPressed: toggleLoginSignup,
                                  child: Text(
                                    'Don\'t have an account? Signup',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                TextButton(
                                  onPressed: toggleLoginSignup,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            )
                          : TextButton(
                              onPressed: toggleLoginSignup,
                              child: Text(
                                'Already have an account? Login',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: auth_register,
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(230),
                        ),
                        child: Center(
                          child: Text(
                            isLogin ? 'Login' : 'Signup',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
