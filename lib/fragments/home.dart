import 'dart:convert';
import 'package:coupon/extras/notification_service.dart';
import 'package:coupon/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../extras/constants.dart';
import '../extras/global.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  double turns = 0.0;

  @override
  void initState() {
    PushNotifications.getDeviceToken();
    super.initState();
  }

  Future<LottieComposition?> lottieDecoder(List<int> bytes) {
    return LottieComposition.decodeZip(bytes, filePicker: (files) {
      return files.firstWhere(
          (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
    });
  }

  _getBalance() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    totalBalance = prefs.getString("userBalance").toString();
    setState(() {});
  }

  _refreshFunction() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http(ipAddress, "coupon/function/home.php");
    var response = await http.post(url, body: {
      "method": "refresh",
      "userId": prefs.getString("userId").toString(),
    });
    prefs.setString("userBalance", response.body.toString());
  }

  _makePayment(qrResult) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.http(ipAddress, "coupon/function/home.php");
    var response = await http.post(url, body: {
      "method": "payment",
      "userId": prefs.getString("userId").toString(),
      "payUser": qrResult,
      "payCoupon": _counter.toString(),
    });
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data["state"] == "paymentDone") {
      _paymentDialog("success", data["line"]);
    } else {
      _paymentDialog("failed", data["line"]);
    }
    _counter = 0;
    _refreshFunction();
  }

  _paymentDialog(lottieAnimation, responseMessage) async {
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
                AppLocalizations.of(context)!.success.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Lottie.network(
                "$baseUrl/img/$lottieAnimation.lottie",
                fit: BoxFit.cover,
                decoder: lottieDecoder,
              ),
              const SizedBox(height: 20),
              Text(
                responseMessage,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 20),
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
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _getBalance();
    return SafeArea(
      child: Scaffold(
        appBar: MyCustomAppBar(
            title: AppLocalizations.of(context)!.rswmLodha.toUpperCase()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _refreshFunction();
              turns += 4 / 4;
            });
          },
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          elevation: 8,
          tooltip: AppLocalizations.of(context)!.refresh,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: AnimatedRotation(
            turns: turns,
            duration: const Duration(seconds: 1),
            child: const Icon(
              Icons.refresh,
              size: 24,
            ),
          ),
        ),
        body: Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: Text(
                  AppLocalizations.of(context)!.totalCoupon(totalBalance),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 50),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_counter > 0) {
                            _counter--;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24, 20, 24, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        elevation: 3,
                      ),
                      child: Text(AppLocalizations.of(context)!.minus),
                    ),
                    Text(
                      "$_counter",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _counter++;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24, 20, 24, 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        elevation: 3,
                      ),
                      child: Text(AppLocalizations.of(context)!.plus),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_counter > 0) {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimpleBarcodeScannerPage(
                          scanType: ScanType.defaultMode,
                          appBarTitle: "Scan QR Code",
                        ),
                      ),
                    );
                    setState(() {
                      if (result is String) {
                        _makePayment(result);
                      }
                    });
                  } else {
                    null;
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 20, 24, 20),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  elevation: 3,
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(AppLocalizations.of(context)!.payNow.toUpperCase()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
