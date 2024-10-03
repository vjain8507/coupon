import 'dart:async';
import 'package:coupon/extras/notification_service.dart';
import 'package:coupon/fragments/notifications.dart';
import 'package:coupon/login.dart';
import 'package:coupon/widgets/app_bar.dart';
import 'package:coupon/widgets/password_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../extras/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:another_flushbar/flushbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController oldPasswordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    PushNotifications.getDeviceToken();
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordTextController.dispose();
    newPasswordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }

  _changePasswordDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.changePassword.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              PasswordField(
                passwordTextController: oldPasswordTextController,
                labelText: AppLocalizations.of(context)!.oldPassword,
              ),
              PasswordField(
                passwordTextController: newPasswordTextController,
                labelText: AppLocalizations.of(context)!.newPassword,
              ),
              PasswordField(
                passwordTextController: confirmPasswordTextController,
                labelText: AppLocalizations.of(context)!.confirmPassword,
              ),
              const Text(
                "Note : This will Logout your current Session.",
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _changePasswordFunction(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      elevation: 3,
                    ),
                    child: Text(AppLocalizations.of(context)!.change),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      elevation: 3,
                    ),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changePasswordFunction(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http(ipAddress, "coupon/function/home.php");
    var response = await http.post(url, body: {
      "method": "password",
      "userId": prefs.getString("userId").toString(),
      "oldPass": oldPasswordTextController.text.trim().toString(),
      "newPass": newPasswordTextController.text.trim().toString(),
      "confirmPass": confirmPasswordTextController.text.trim().toString(),
    });
    String data = response.body.toString();
    if (data == "passwordUpdated") {
      Flushbar(
        flushbarStyle: FlushbarStyle.FLOATING,
        message: AppLocalizations.of(context)!.passwordUpdated,
        messageColor: Colors.white,
        duration: const Duration(milliseconds: 2000),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.green,
      ).show(context);
      Timer(const Duration(milliseconds: 1000), () {
        _logoutFunction(context);
      });
    } else {
      Flushbar(
        flushbarStyle: FlushbarStyle.FLOATING,
        message: data,
        messageColor: Colors.white,
        duration: const Duration(milliseconds: 2000),
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red,
      ).show(context);
    }
  }

  _logoutDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(AppLocalizations.of(context)!.sureLogout),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _logoutFunction(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      elevation: 3,
                    ),
                    child: Text(AppLocalizations.of(context)!.yes),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      elevation: 3,
                    ),
                    child: Text(AppLocalizations.of(context)!.no),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _logoutFunction(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
            title: AppLocalizations.of(context)!.rswmLodha.toUpperCase()),
        body: Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.blue,
                ),
                title: Text(AppLocalizations.of(context)!.notifications),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.password,
                  color: Colors.green,
                ),
                title: Text(AppLocalizations.of(context)!.changePassword),
                onTap: () {
                  _changePasswordDialog();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: Text(AppLocalizations.of(context)!.logout),
                onTap: () {
                  _logoutDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
