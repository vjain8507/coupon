import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:coupon/main.dart';
import 'package:coupon/widgets/password_field.dart';
import 'package:coupon/widgets/plain_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'extras/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
  ));
  runApp(const LoginPage());
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPageWidget(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool passwordVisibility = false;

  login(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http(ipAddress, "coupon/function/index.php");
    var response = await http.post(url, body: {
      "method": "login",
      "username": usernameTextController.text.trim().toString(),
      "password": passwordTextController.text.trim().toString(),
    });
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data["message"] == "noData") {
      Flushbar(
        flushbarStyle: FlushbarStyle.FLOATING,
        message: AppLocalizations.of(context)!.usernamePasswordIncorrect,
        messageColor: Colors.white,
        duration: const Duration(milliseconds: 2000),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
    } else {
      Flushbar(
        flushbarStyle: FlushbarStyle.FLOATING,
        message: AppLocalizations.of(context)!.loginSuccess,
        messageColor: Colors.white,
        duration: const Duration(milliseconds: 2000),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.green,
      ).show(context);
      await prefs.setString('userId', data["userId"]);
      await prefs.setString('userName', data["userName"]);
      await prefs.setString('userBalance', data["userBalance"]);
      Timer(const Duration(milliseconds: 1000), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4B39EF),
                  Color(0xFFFF5963),
                  Color(0xFFEE8B60)
                ],
                stops: [0, 0.5, 1],
                begin: AlignmentDirectional(-1, -1),
                end: AlignmentDirectional(1, 1),
              ),
            ),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x00FFFFFF), Colors.white],
                  stops: [0, 1],
                  begin: AlignmentDirectional(0, -1),
                  end: AlignmentDirectional(0, 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xCCFFFFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.network("$baseUrl/img/rswm_logo.png"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                    child: Text(
                      AppLocalizations.of(context)!.login.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF101213),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Text(
                      AppLocalizations.of(context)!.useBelowAccount,
                      style: const TextStyle(
                        color: Color(0xFF57636C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlainTextField(
                      textController: usernameTextController,
                      labelText: AppLocalizations.of(context)!.username),
                  PasswordField(
                      passwordTextController: passwordTextController,
                      labelText: AppLocalizations.of(context)!.password),
                  Align(
                    alignment: const AlignmentDirectional(0, 0),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (usernameTextController.text.trim() == "") {
                            Flushbar(
                              flushbarStyle: FlushbarStyle.FLOATING,
                              message:
                                  AppLocalizations.of(context)!.enterUsername,
                              messageColor: Colors.white,
                              duration: const Duration(milliseconds: 2000),
                              margin: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: Colors.red,
                            ).show(context);
                          } else if (passwordTextController.text.trim() == "") {
                            Flushbar(
                              flushbarStyle: FlushbarStyle.FLOATING,
                              message:
                                  AppLocalizations.of(context)!.enterPassword,
                              messageColor: Colors.white,
                              duration: const Duration(milliseconds: 2000),
                              margin: const EdgeInsets.all(8),
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: Colors.red,
                            ).show(context);
                          } else {
                            login(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              24, 20, 24, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          elevation: 3,
                        ),
                        child: Text(AppLocalizations.of(context)!.signIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(AppLocalizations.of(context)!.copyright),
          ),
        ],
      ),
    );
  }
}
