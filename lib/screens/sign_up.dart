import 'package:coffeeapp/screens/dashboard.dart';
import 'package:coffeeapp/screens/login_screen.dart';
import 'package:coffeeapp/services/auth_service.dart';
import 'package:coffeeapp/utils/appvalidator.dart';
import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
class SignUpView extends StatefulWidget {
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _userNameController = TextEditingController();

  final _emailController = TextEditingController();

  final _phoneController = TextEditingController();

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
        'username': _userNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _passwordController.text,
      };

      await authServerice.createUser(data, context);

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
      backgroundColor: const Color(0xFF252634),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 80.0,
                  ),
                  const SizedBox(
                      width: 250,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Create new Account",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _userNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _buildInputDecoration("Username", Icons.person),
                    validator: appValidator.validateUsername,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration("Email", Icons.email),
                      validator: appValidator.validateEmail),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        _buildInputDecoration("Phone Number", Icons.call),
                    validator: appValidator.validatePhoneNumber,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _buildInputDecoration("Password", Icons.lock),
                    validator: appValidator.validatePassword,
                  ),
                  const SizedBox(
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
                            : const Text(
                                "Create",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 85, 0), fontSize: 20),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
        fillColor: const Color(0xAA494A59),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x35949494))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        filled: true,
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF949494)),
        suffixIcon: Icon(suffixIcon, color: const Color(0xFF949494)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)));
  }
}
