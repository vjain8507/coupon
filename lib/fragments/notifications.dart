import 'dart:convert';
import 'package:coupon/extras/constants.dart';
import 'package:coupon/extras/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<ListItem> items = [];
  double turns = 0.0;

  @override
  void initState() {
    PushNotifications.getDeviceToken();
    super.initState();
  }

  Future<bool> _getNotificationData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http(ipAddress, "coupon/function/home.php");
    var response = await http.post(url, body: {
      "method": "detail",
      "userId": prefs.getString("userId").toString(),
    });
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data.length != 0) {
      items.clear();
      for (var i = 0; i < data.length; i++) {
        items.add(NotificationItem(data[i]["user"], data[i]["name"],
            data[i]["coupon"], data[i]["date"]));
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notifications),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _getNotificationData();
            turns += 4 / 4;
          });
        },
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        elevation: 8,
        tooltip: AppLocalizations.of(context)!.refresh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: AnimatedRotation(
          turns: turns,
          duration: const Duration(seconds: 1),
          child: const Icon(
            Icons.refresh,
            size: 24,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _getNotificationData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Please Wait...'));
          } else {
            if (snapshot.hasData == false) {
              return const Center(
                child: Text(
                  "No Notifications!!!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: item.buildTitle(context),
                      isThreeLine: true,
                      subtitle: item.buildBody(context),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildBody(BuildContext context);
}

class NotificationItem implements ListItem {
  final String user;
  final String name;
  final String coupon;
  final String date;

  NotificationItem(this.user, this.name, this.coupon, this.date);

  @override
  Widget buildTitle(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          bottom: 5,
        ),
        child: Text(
          "$coupon Coupon received from $user",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  @override
  Widget buildBody(BuildContext context) =>
      Text("$name Paid you $coupon coupon on $date.");
}
