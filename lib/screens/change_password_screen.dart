import 'package:coffeeapp/screens/dashboard.dart';
import 'package:coffeeapp/services/auth_service.dart';
import 'package:coffeeapp/utils/appvalidator.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _oldpasswordController = TextEditingController();
  final _newpasswordController = TextEditingController();
  var appValidator = AppValidator();
  var isLoader = false;
  var authServerice = AuthServerice();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        'oldpassword': _oldpasswordController.text,
        'newpassword': _newpasswordController.text,
      };

      await authServerice.changePassword(data, context);

      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldpasswordController,
                style: TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildInputDecoration("Old Password", Icons.key),
                validator: appValidator.validatePassword,
              ),
              SizedBox(
                height: 40.0,
              ),
              TextFormField(
                controller: _newpasswordController,
                style: TextStyle(color: Colors.white),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildInputDecoration("New Password", Icons.key),
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
                        backgroundColor: Colors.blue.shade900),
                    onPressed: () {
                      isLoader ? print("Loading") : _submitForm();
                    },
                    child: isLoader
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            "Change",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
              ),
            ],
          ),
        ),
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
