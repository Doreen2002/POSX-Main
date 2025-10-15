import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/api_requests/login.dart';
import 'package:offline_pos/common_utils/app_colors.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'items_cart.dart';
import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey safeAreaKey = GlobalKey();
  final TextEditingController httpType = TextEditingController();
  final TextEditingController frappeInstance = TextEditingController();
  final TextEditingController usr = TextEditingController();
  final TextEditingController pwd = TextEditingController();
  final TextEditingController licenseKey = TextEditingController();
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // <-- Added Form Key
  bool _obscureText = true;
  bool licenseKey_readOnly = true;

  @override
  void initState() {
    super.initState();
    httpType.text = 'https';
    frappeInstance.text = UserPreference.getString(PrefKeys.baseUrl) ?? '';
    usr.text = UserPreference.getString(PrefKeys.userName) ?? '';
    licenseKey.text = UserPreference.getString(PrefKeys.licenseKey) ?? '';
  }

  @override
  void dispose() {
    httpType.dispose();
    frappeInstance.dispose();
    usr.dispose();
    pwd.dispose();
    super.dispose();
  }

  // Extracted login logic into a separate function
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return; // Validate form fields

    await DialogUtils.showLoginLoading(context: context);

    try {
      final success = await loginRequest(
        'https',
        frappeInstance.text,
        usr.text,
        pwd.text,
      );

      Navigator.of(context).pop(); // Dismiss progress dialog

      if (success) {
        await UserPreference.putString(PrefKeys.licenseKey, licenseKey.text);
        await UserPreference.putString(PrefKeys.deviceID, await getWindowsDeviceId());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartItemScreen()),
        );
      } else {
        _showErrorDialog(
          'Invalid Credentials.\nPlease check your username and password.',
        );
      }
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss dialog if error
      _showErrorDialog(
        'An error occurred while trying to login.\nPlease try again.',
      );
     logErrorToFile("Login failed $e");
    }
  }

  void _showErrorDialog(String message) {
    DialogUtils.showLoginError(
      context: context,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.cartListColor,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    // <-- Wrapped in Form
                    key: _formKey, // <-- Added Form Key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Login to POS',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            fontFamily: '',
                          ),
                        ),
                        const SizedBox(height: 15),

                        const Text(
                          'ERPNext Link',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: frappeInstance,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(7),
                              child: Icon(
                                Icons.link_outlined,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter ERPNext URL';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        const Text(
                          'User ID',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: usr,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(7),
                              child: Icon(
                                Icons.email_outlined,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: pwd,
                          obscureText: _obscureText,
                          style: const TextStyle(fontSize: 18),
                          textInputAction:
                              TextInputAction.go, // <-- Triggers login on Enter
                          onFieldSubmitted:
                              (_) => _handleLogin(), // <-- Calls login
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(7),
                              child: Icon(
                                Icons.lock_outlined,
                                size: 24,
                                color: Color(0xFF006A35),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF006A35),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        Visibility(child: 
                        const SizedBox(height: 15),
                        ),
                         
                        Visibility(child: 
                        const Text(
                          'License Key',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ),
                        Visibility(child: const SizedBox(height: 5),),
                        Visibility(child:
                        TextFormField(
                          controller: licenseKey,
                          readOnly:  licenseKey_readOnly,
                          style: const TextStyle(fontSize: 18),
                          textInputAction:
                              TextInputAction.go, 
                          onFieldSubmitted:
                              (_) => _handleLogin(), 
                          decoration: InputDecoration(
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(7),
                              child: Icon(
                                Icons.key_outlined,
                                size: 24,
                                color: Color(0xFF006A35),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                licenseKey_readOnly
                                    ? Icons.edit_off
                                    : Icons.edit,
                                color: const Color(0xFF006A35),
                              ),
                              onPressed: () {
                                setState(() {
                                  licenseKey_readOnly = !licenseKey_readOnly;
                                });
                              },
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
                        ),
                        
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 180,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                backgroundColor: const Color(0xFF006A35),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed:
                                  _handleLogin, // <-- Reuse the same function
                              child: const Text(
                                'Log in',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Logo moved to the right
          if (size.width > 800)
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF018644), Color(0xFF2B3691)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/9T9_Logo_2023.png',
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Point of Sales by',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          '9T9 Information Technology  -  Bahrain',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: '',
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


Future<String> getWindowsDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  final windowsInfo = await deviceInfo.windowsInfo;

  return windowsInfo.deviceId; 
}