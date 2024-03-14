import 'package:coffeeapp/screens/dashboard.dart';
import 'package:coffeeapp/screens/sign_up.dart';
import 'package:coffeeapp/services/auth_service.dart';
import 'package:coffeeapp/utils/appvalidator.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  var authServerice = AuthServerice();
  var isLoader = false;
  var appValidator = AppValidator();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };

      await authServerice.login(data, context);

      setState(() {
        isLoader = false;
      });
      // ScaffoldMessenger.of(_formKey.currentContext!)
      //     .showSnackBar(const SnackBar(
      //   content: Text("Forma Submitted Successfully"),
      // ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 80.0,
                ),
                SizedBox(
                    width: 250,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Login Account",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration("Email", Icons.email),
                    validator: appValidator.validateEmail),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Password", Icons.call),
                  validator: appValidator.validatePassword,
                ),
                SizedBox(
                  height: 40.0,
                ),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 255, 85, 0)),
                      onPressed: () {
                        isLoader ? print("Loading") : _submitForm();
                      },
                      child: isLoader
                          ? const Center(child: CircularProgressIndicator())
                          : Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpView()),
                    );
                  },
                  child: Text(
                    "Create new account",
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 85, 0), fontSize: 20),
                  ),
                )
              ],
            )),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
        fillColor: Color(0xAA494A59),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x35949494))),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        filled: true,
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF949494)),
        suffixIcon: Icon(suffixIcon, color: Color(0xFF949494)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)));
  }
}
