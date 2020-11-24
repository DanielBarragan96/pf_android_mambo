import 'package:entregable_2/colors.dart';
import 'package:entregable_2/home/home_page.dart';
import 'package:entregable_2/login/bloc/login_bloc.dart';
import 'package:entregable_2/login/form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  LoginBloc _loginBloc;
  bool _showLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

  void _emailLogIn(bool _) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return Container(
          padding: MediaQuery.of(context)
              .viewInsets, // mostrar contenido sobre el teclado
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.centerLeft,
                  child: Text("Email"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(controller: _emailController),
                ),
                SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.centerLeft,
                  child: Text("Password"),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 40),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _loginBloc.add(LoginWithEmailEvent(
                        _emailController.text, _passwordController.text));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: kWhite,
                    ),
                  ),
                  color: kLightPurple,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _googleLogIn(bool _) {
    // invocar al login de firebase con el bloc
    // recodar configurar pantallad Oauth en google Cloud
    print("google");
    _loginBloc.add(LoginWithGoogleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // stack background image
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                kLightPurple,
                kBlack,
              ],
            ),
          ),
        ),
        // form content
        SafeArea(
          child: BlocProvider(
            create: (context) {
              _loginBloc = LoginBloc();
              return _loginBloc..add(VerifyLogInEvent());
            },
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginErrorState) {
                  _showLoading = false;
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: Text("${state.error}"),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"),
                          )
                        ],
                      );
                    },
                  );
                } else if (state is LoginLoadingState) {
                  _showLoading = !_showLoading;
                }
              },
              builder: (context, state) {
                if (state is LoginSuccessState) {
                  return HomePage(loginBloc: _loginBloc);
                }
                return SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    child: FormBody(
                      onGoogleLoginTap: _googleLogIn,
                      onEmailLoginTap: _emailLogIn,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _showLoading ? CircularProgressIndicator() : Container(),
        ),
      ],
    );
  }
}
