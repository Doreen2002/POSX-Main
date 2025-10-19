import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/common_utils/app_colors.dart';
import 'package:offline_pos/common_widgets/cash_payment_textfield.dart';
import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/pages/login_screen.dart';
import 'package:mysql1/mysql1.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final TextEditingController passWD = TextEditingController();
  final TextEditingController host = TextEditingController();
  final TextEditingController port = TextEditingController();
  final TextEditingController user = TextEditingController();
  final TextEditingController dbName = TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    host.dispose();
    port.dispose();
    user.dispose();
    dbName.dispose();
    passWD.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await UserPreference.getInstance();
    // initialize controllers once (avoid setState in build)
    host.text = UserPreference.getString(PrefKeys.databaseHostUrl) ?? '';
    port.text = UserPreference.getString(PrefKeys.databasePort) ?? '3306';
    user.text = UserPreference.getString(PrefKeys.databaseUser) ?? '';
    passWD.text = UserPreference.getString(PrefKeys.databasePassword) ?? '';
    dbName.text = UserPreference.getString(PrefKeys.databaseName) ?? '';
    _checkLogin();
  }

  void _checkLogin() async {
    await UserPreference.getInstance();
    final host = UserPreference.getString(PrefKeys.databaseHostUrl);
    final db = UserPreference.getString(PrefKeys.databaseName);
    final user = UserPreference.getString(PrefKeys.databaseUser);
    final port = UserPreference.getString(PrefKeys.databasePort) ;
    final pass = UserPreference.getString(PrefKeys.databasePassword);

    if (host!.isNotEmpty && db!.isNotEmpty && user!.isNotEmpty && port!.isNotEmpty && pass!.isNotEmpty) {
      bool isConnected = await checkDatabaseExists(host, db, user, int.parse(port), pass); 
      if (isConnected) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        });
      } 
    }
  }

  @override
  Widget build(BuildContext context) {
    // controllers are initialized in _init()
    
    return Scaffold(
      backgroundColor: AppColors.cartListColor,
      body: Stack(
        children: [
          Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Database',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Host',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: host,
                        onChanged: (value) {
                          UserPreference.putString(
                            PrefKeys.databaseHostUrl,
                            value,
                          );
                        },
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(7),
                            child: Icon(
                              Icons.mail_sharp,
                              size: 24,
                              color: Color(0xFF006A35),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF006A35),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      const Text(
                        'User',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: user,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(7),
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 24,
                              color: Color(0xFF006A35),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF006A35),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      const Text(
                        'Database Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: dbName,
                        onChanged:
                            (value) => UserPreference.putString(
                              PrefKeys.databaseName,
                              value,
                            ),
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(7),
                            child: Icon(
                              Icons.dataset_linked_outlined,
                              size: 24,
                              color: Color(0xFF006A35),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF006A35),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      const Text(
                        'Port',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: port,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(7),
                            child: Icon(
                              Icons.attach_file,
                              size: 24,
                              color: Color(0xFF006A35),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: Color(0xFF006A35),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: passWD,
                        obscureText: false,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(7),
                            child: Icon(
                              Icons.lock_outline,
                              size: 24,
                              color: Color(0xFF006A35),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF006A35),
                              width: 2,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // InkWell(
                      //   onTap: () async{
                      //     print("${UserPreference.getString('databasePort')}");

                      //     showDialog(
                      //       context: context,
                      //       builder: (context) => createDatabaseDialog(context),
                      //     );
                      //     // Add logic for creating a new database
                      //   },
                      //   child: Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: Container(
                      //       padding: EdgeInsets.all(5.r),
                      //       child: SingleText(
                      //         text: 'Create New Database',
                      //         fontSize: 5.sp,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () async {
                      setState((){
                        _isChecking = true;
                      });
                      bool connected = await checkDatabaseExists(
                        host.text,
                        dbName.text,
                        user.text,
                        int.tryParse(port.text) ?? 3306,
                        passWD.text,
                      );
                      setState((){
                        _isChecking = false;
                      });
                      if (connected) {
                        await UserPreference.putString(
                          PrefKeys.databasePort,
                          port.text,
                        );
                        await UserPreference.putString(
                          PrefKeys.databaseHostUrl,
                          host.text,
                        );
                        await UserPreference.putString(
                          PrefKeys.databaseName,
                          dbName.text,
                        );
                        await UserPreference.putString(
                          PrefKeys.databaseUser,
                          user.text,
                        );
                        await UserPreference.putString(
                          PrefKeys.databasePassword,
                          passWD.text,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Error'),
                                content: Text(
                                  'Path Does not exist or Database does not exist at the specified path.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                        );
                      }

                    },
                    child: Container(
                      height: 50.h,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: Color(0xFF006A35),
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      child: Center(
                        child: SingleText(
                          text: 'Submit',
                          fontWeight: FontWeight.bold,
                          fontSize: 4.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ), // end GestureDetector
                ], // end children of inner Column
              ), // end inner Column
            ), // end Container
          ], // end children of outer Column
        ), // end outer Column
      ), // end Center
      // loading overlay
      if (_isChecking)
        Container(
          color: Colors.black45,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
    ], // end Stack children
  ), // end Stack
); // end Scaffold
  }
}

createDatabaseDialog(BuildContext context) {
  final host = TextEditingController();
  final port = TextEditingController();
  final user = TextEditingController();
  final passWD = TextEditingController();
  final dbName = TextEditingController();
  UserPreference.getInstance();
  host.text = UserPreference.getString(PrefKeys.databaseHostUrl) ?? '';
  port.text = UserPreference.getString(PrefKeys.databasePort) ?? '3306';
  user.text = UserPreference.getString(PrefKeys.databaseUser) ?? '';
  // passWD.text = UserPreference.getString(PrefKeys.databasePassword)??'';
  dbName.text = UserPreference.getString(PrefKeys.databaseName) ?? '';

  return StatefulBuilder(
    builder: (context, setState) {
      return IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(left: 130.w, right: 130.w),
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: AppColors.white,
            child: Material(
              // color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 25.h,
                  bottom: 65.h,
                  left: 20.w,
                  right: 20.w,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.arrow_back, size: 25.r),
                              ),
                              SizedBox(width: 15.w),
                              SingleText(
                                text: 'Create New Database',
                                fontWeight: FontWeight.bold,
                                fontSize: 6.sp,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          CashPaymentTextField(
                            controller: host,
                            icon: Icon(Icons.mail_sharp, size: 30.r),
                            hintText: 'Host',
                            onChange: (value) {
                              UserPreference.putString(
                                PrefKeys.databaseHostUrl,
                                value,
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                          CashPaymentTextField(
                            controller: user,
                            icon: Icon(Icons.mail_sharp, size: 30.r),
                            hintText: 'User',
                            onChange: (value) {
                              UserPreference.putString(
                                PrefKeys.databaseUser,
                                value,
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                          CashPaymentTextField(
                            controller: dbName,
                            icon: Icon(
                              Icons.dataset_linked_outlined,
                              size: 30.r,
                            ),
                            hintText: 'Database Name',
                            onChange: (value) {
                              UserPreference.putString(
                                PrefKeys.databaseName,
                                value,
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                          CashPaymentTextField(
                            controller: port,
                            icon: Icon(Icons.attach_file, size: 30.r),
                            hintText: 'Port',
                            onChange: (value) {
                              UserPreference.putString(
                                PrefKeys.databasePort,
                                value,
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                          CashPaymentTextField(
                            controller: passWD,
                            icon: Icon(Icons.lock_outline, size: 30.r),
                            hintText: '.....',
                            isObsecure: true,
                            onChange: (value) {
                              // UserPreference.putString(PrefKeys.databasePassword, value);
                            },
                            suffixIcon: GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(right: 3.0.w),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: SingleText(
                                      text: 'Show',
                                      fontSize: 4.sp,
                                      color: AppColors.cartTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () async {
                          // createDB(
                          //       host.text,
                          //       port.text,
                          //       user.text,
                          //       passWD.text,
                          //       dbName.text,
                          //     )
                          //     .then((isConnected) {
                          //       if (isConnected == true) {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => const LoginScreen(),
                          //           ),
                          //         );
                          //       } else {
                          //         showDialog(
                          //           context: context,
                          //           builder:
                          //               (context) => AlertDialog(
                          //                 title: const Text('Error'),
                          //                 content: const Text(
                          //                   'Failed Create Database.',
                          //                 ),
                          //                 actions: [
                          //                   TextButton(
                          //                     onPressed: () {
                          //                       Navigator.of(context).pop();
                          //                     },
                          //                     child: const Text('OK'),
                          //                   ),
                          //                 ],
                          //               ),
                          //         );
                          //       }
                          //     })
                          //     .catchError((error) {
                          //       // Handle any errors that might occur during the Future execution
                          //       print(
                          //         "Error during  Database Creation: $error",
                          //       );
                          //       showDialog(
                          //         context: context,
                          //         builder:
                          //             (context) => AlertDialog(
                          //               title: const Text('Error'),
                          //               content: Text(
                          //                 'An unexpected error occurred: $error',
                          //               ),
                          //               actions: [
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.of(context).pop();
                          //                   },
                          //                   child: const Text('OK'),
                          //                 ),
                          //               ],
                          //             ),
                          //       );
                          //     });
                        },
                        child: Container(
                          height: 50.h,
                          width: 1.sw,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                          ),
                          child: Center(
                            child: SingleText(
                              text: 'Submit',
                              fontWeight: FontWeight.bold,
                              fontSize: 4.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

bool dbExists = false;
Future<bool> checkDatabaseExists(
  String host,
  String dbName,
  String user,
  int port,
  String passwd,
) async {
  MySqlConnection? conn;
  try {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: passwd,
      db: dbName,
    );

    // limit connect attempt to 6 seconds to keep UI responsive
    conn = await MySqlConnection.connect(settings).timeout(const Duration(seconds: 6));
    var results = await conn.query("SHOW DATABASES LIKE '\$dbName';");
    dbExists = results.isNotEmpty;
    return results.isNotEmpty;
  } catch (e) {
    logErrorToFile('Error: $e');
    dbExists = false;
    return false;
  } finally {
    try {
      await conn?.close();
    } catch (_) {}
  }
}
