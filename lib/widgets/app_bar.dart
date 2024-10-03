import 'package:coupon/extras/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyCustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    late String qrCode;

    getQrCode() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      qrCode = prefs.getString("userName").toString();
    }

    getQrCode();

    return AppBar(
      leading: Container(
        padding: const EdgeInsets.all(8.0),
        child: Image.network("$baseUrl/img/rswm.png"),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          padding: const EdgeInsets.only(right: 8.0),
          icon: const Icon(Icons.qr_code),
          tooltip: AppLocalizations.of(context)!.qrCode,
          onPressed: () => showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 250,
                      height: 250,
                      child: Image.network(
                        '$baseUrl/function/qrcodes/$qrCode.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            24, 20, 24, 20),
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
          ),
        ),
      ],
    );
  }
}
