import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/shared/input_widget.dart';
import '../widgets/shared/primary_button.dart';
import 'dashboard.screen.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLoading = false;
  var _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _loginData = {"username": "", "password": ""};

  Future<void> _submitForm() async {
    if (_isLoading) return;

    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(_loginData["username"], _loginData["password"]);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => DashboardScreen()),
          ModalRoute.withName("/dashboard"));
    } on HttpException catch (err) {
      Utils.showSnackBar(title: err.message, context: context);
      return;
    } catch (err) {
      print(err);
      Utils.showSnackBar(title: err.toString(), context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.PRIMARY,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height) / 2.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(height: 20),
                        Text(
                          "TAP & EAT",
                          style: TextStyle(color: Colors.white, fontSize: 42,fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "AGENTS APP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InputWidget(
                                  label: "Email",
                                  inputType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Email can\'t be empty!';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    _loginData["username"] = val;
                                  },
                                ),
                                SizedBox(height: 20),
                                InputWidget(
                                  label: "Password",
                                  obscure: true,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password can\'t be empty!';
                                    }
                                    return null;
                                  },
                                  onSaved: (val) {
                                    _loginData["password"] = val;
                                  },
                                ),

                                SizedBox(height: 25),
                                PrimaryButton(
                                  text: "LOGIN",
                                  onPressed: _submitForm,
                                  isLoading: _isLoading,
                                  block: true,
                                ),
                                /*Center(
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forgot PIN?",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.3,
                                      ),
                                    ),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
