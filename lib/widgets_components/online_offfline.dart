import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class IsOnline extends StatefulWidget {
  const IsOnline({super.key});

  @override
  State<IsOnline> createState() => _IsOnlineState();
}

class _IsOnlineState extends State<IsOnline> {
  bool isOnline = false;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    checkOnline();

    // listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.isEmpty ||
    result.contains(ConnectivityResult.none)) {
        setState(() {
      isOnline = false;
        });
    }
    else if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
          setState(() {
      isOnline = true;
        });
        }
    });
  }

  Future<void> checkOnline() async {
    final result = await Connectivity().checkConnectivity();
    if (result.isEmpty ||
    result.contains(ConnectivityResult.none)) {
        setState(() {
      isOnline = false;
        });
    }
    else if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {

          setState(() {
      isOnline = true;
        });
        }
   
      
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
