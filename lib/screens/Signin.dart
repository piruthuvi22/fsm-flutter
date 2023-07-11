import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fsm_agent/utils/functions.dart';
import 'package:fsm_agent/screens/Dashboard.dart';
import 'package:http/http.dart' as http;

import '../services/api_service.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  String _email = 'agent2@abcd.com';
  String _password = 'Agent@1234';

  Future<void> _submitForm() async {
    final navigator = Navigator.of(context);

    // if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final response = await http.post(
      Uri.parse('http://192.168.8.139:8080/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': "agent2@abcd.com", 'password': "Agent@1234"}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      if (token != null) {
        final res = await apiService.getAgentIdByEmail("agent2@abcd.com");
        if (response.statusCode == 200) {
          await saveAgentId(res);
        } else {
          throw Exception('Failed to load agent id');
        }

        // Save the JWT token to SharedPreferences
        await saveToken(token);

        // Navigate to the home screen
        navigator.pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Please check your credentials.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text('Please try again later'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              SvgPicture.asset(
                "images/signup.svg",
                width: 200,
                // height: 200,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 16.0),
              const Text(
                "LOGIN",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    // backgroundColor: Colors.yellow,
                    color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 50)),
                    ),
                    onPressed: _submitForm,
                    child: const Text('Sign In'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
