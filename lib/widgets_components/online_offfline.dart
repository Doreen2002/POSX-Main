import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class IsOnline extends StatefulWidget {
  const IsOnline({super.key});

  @override
  State<IsOnline> createState() => _IsOnlineState();
}

class _IsOnlineState extends State<IsOnline> {
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    monitorConnection();
  }

  void monitorConnection() {
    Connectivity().onConnectivityChanged.listen((result) async {
      bool hasInternet = await InternetConnection().hasInternetAccess;

      setState(() {
        isOnline = hasInternet;
      });
    });

    _initialCheck();
  }

  Future<void> _initialCheck() async {
    bool hasInternet = await InternetConnection().hasInternetAccess;
    setState(() {
      isOnline = hasInternet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: isOnline ? Colors.green : Colors.red,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          isOnline ? "Online" : "Offline",
          style: TextStyle(
            color: isOnline ? Colors.green : Colors.red,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
