import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:random_string/random_string.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'package:vti_student/authentication/verification_page.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/shared_prefs_keys.dart';
import 'package:vti_student/configs/urls.dart';
import 'package:vti_student/home/dash_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool currentViewIsOtpPage = false;
  bool isLoading = false;

  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  // final GlobalKey<FormState> _otpFormKey = GlobalKey();

  late String otp;
  TextEditingController editingControllerPhone = TextEditingController();

  late FocusNode focusNodePin;

  final _pinEditingController = TextEditingController();

  String strCode = '';

  String signature = "{{ app signature }}";

  @override
  void initState() {
    setState(() {
      otp = randomNumeric(4);
      ("OTP: $otp");
    });
    super.initState();
  }

  Future sendOTP() async {

    setState(() {
      isLoading = true;
    });
    signature = await SmsAutoFill().getAppSignature;
    SmsAutoFill().listenForCode;
    final url = Uri.parse(Urls().sendOtpUrl);
    var body = json.encode([
      {
        "mobile_number": editingControllerPhone.text,
        "otp": otp,
        "hash_code": signature
      }
    ]);
    print("Body: $body");
    Response response = await post(
      url,
      body: body,
      headers: {'Content-type': 'application/json'},
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);

      if (res[0]['success'] == '1') {
        Fluttertoast.showToast(msg: res[0]['message']);
        setState(() {
          isLoading = false;
          currentViewIsOtpPage = true;
        });
      } else {
        Fluttertoast.showToast(msg: res[0]['message']);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
      setState(() {
        isLoading = false;
      });
    }
  }

  login() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().loginUrl);
    var map = new Map<String, dynamic>();
    map['mobile_number'] = editingControllerPhone.value.text;

    Response response = await post(
      url,
      body: map,

    );

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body.toString());

      if (res['success'] == '1') {
        Fluttertoast.showToast(msg: res['message']);
        SharedPreferences _prefs = await SharedPreferences.getInstance();
         _prefs.setBool(userLoginStatusKey, true);
        // _prefs.setString(userPhoneKey, res[0]['mobile_number']);
        // _prefs.setString(userFirstNameKey, res[0]['first_name']);
        // _prefs.setString(userEmailKey, res[0]['email']);
        // _prefs.setString(userIdKey, res[0]['student_id'].toString());
        // setState(() {
        //   userPhone = res[0]['mobile_number'];
        //   userFirstName = res[0]['first_name'];
        //   userEmail = res[0]['email'];
        //   userId = res[0]['student_id'].toString();
        // });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashPage()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: res['message']);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      }
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: currentViewIsOtpPage
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentViewIsOtpPage = false;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                                left: 15.0,
                              ),
                              //padding: const EdgeInsets.only(left: 5.0),
                              height: h * 0.05,
                              width: h * 0.05,
                              decoration: BoxDecoration(
                                  // color: primaryColor,
                                  border: Border.all(
                                      color: Colors.black26, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black87,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: Container(
                          height: h * 0.3,
                          width: h * 0.4,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/login.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("OTP Verification",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              'Enter the OTP sent to +91 - ${editingControllerPhone.text}',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black38),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Center(child: getOtpWidget()),
                      SizedBox(
                        height: h * 0.04,
                      ),
                      InkWell(
                        onTap: () {
                          if (otp == strCode) {
                            login();
                          } else {
                            Fluttertoast.showToast(msg: "Please check the OTP");
                          }
                        },
                        child: Center(
                          child: Container(
                            height: 60,
                            width: w * 0.8,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(18.0),
                              ),
                            ),
                            child: isLoading
                                ? const Center(
                                    child: SpinKitChasingDots(
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              //sendOTP();
                            },
                            child: SizedBox(
                              child: RichText(
                                text: TextSpan(children: [
                                  const TextSpan(
                                    text: 'Didn\'t recieve the OTP? ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  TextSpan(
                                      text: '   RESEND OTP',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          if (editingControllerPhone
                                                  .text.length ==
                                              10) {
                                            Fluttertoast.showToast(
                                                msg: "OTP Re-Sent");
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please enter a valid phone number");
                                          }
                                        }),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 10.0,
                                    left: 15.0,
                                  ),
                                  //padding: const EdgeInsets.only(left: 3.0),
                                  height: h * 0.05,
                                  width: h * 0.05,
                                  decoration: BoxDecoration(
                                      // color: primaryColor,
                                      border: Border.all(
                                          color: Colors.black26, width: 1.0),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0))),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.black87,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: h * 0.06,
                    ),
                    Container(
                      height: h * 0.3,
                      width: h * 0.4,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/login.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // child: RiveAnimation.asset(
                      //   'assets/images/login.riv',
                      // ),
                    ),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    inputFields(),
                    SizedBox(
                      height: h * 0.03,
                    ),
                    InkWell(
                      onTap: () {
                        if (_loginFormKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: Container(
                        height: 60,
                        width: w * 0.84,
                        margin: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoading
                                ? const SpinKitChasingDots(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "GET OTP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account ?",
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const VerificationPage()));
                            },
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget inputFields() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      width: w * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "OTP Verification",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            const Text(
              "We will send you a One Time Password on this mobile number",
              style:
                  TextStyle(color: Colors.black38, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Container(
              width: w * 0.9,
              child: TextFormField(
                controller: editingControllerPhone,
                validator: (value) {
                  if (value!.length != 10) {
                    return 'Enter a valid phone number';
                  }
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 2.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    labelText: 'Mobile number',
                    labelStyle: TextStyle(color: primaryColor),
                    suffixIcon: const Icon(
                      Icons.phone,
                      color: Colors.black45,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getOtpWidget() {
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w * 0.9,
      height: 56,
      child: PinFieldAutoFill(
        //decoration: _pinDecoration,
        decoration: BoxLooseDecoration(
          textStyle: const TextStyle(fontSize: 20, color: Colors.black),
          //colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
          strokeColorBuilder:
              PinListenColorBuilder(primaryColor, Colors.black12),
        ),
        codeLength: 4,
        controller: _pinEditingController,

        currentCode: strCode,
        onCodeSubmitted: (pin) {
          strCode = pin;
        },
        onCodeChanged: (pin) {
          strCode = pin!;
        },
      ),
    );
  }
}
