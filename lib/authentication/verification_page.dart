import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:vti_student/authentication/registration_page.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _uniqueCodeController = TextEditingController();

  final GlobalKey<FormState> _verificationKey = GlobalKey();

  bool isLoading = false;

  verifyUniqueCode() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().verifyStudentUrl);

    var body = json.encode([
      {
        "unique_id": _uniqueCodeController.text,
      }
    ]);

    Response response = await post(
      url,
      body: body,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(response.body);

      if (res[0]['success'] == '1') {
        Fluttertoast.showToast(msg: res[0]['message']);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegistrationPage(
                      phoneNumber: res[0]['mobile_number'],
                      uniqueId: _uniqueCodeController.text,
                    )));
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

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _verificationKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            // top: 10.0,
                            // left: 15.0,
                            ),
                        //padding: const EdgeInsets.only(left: 5.0),
                        height: h * 0.05,
                        width: h * 0.05,
                        decoration: BoxDecoration(
                            // color: primaryColor,
                            border:
                                Border.all(color: Colors.black26, width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black87,
                          size: 18.0,
                        ),
                      ),
                    ),
                    Text(
                      "Verification",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0),
                    ),
                    IconButton(
                      onPressed: () {
                        //Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  height: h * 0.4,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/login.png"))),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                const Text(
                  "Enter the verification code, which you received.",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  width: w * 0.9,
                  child: TextFormField(
                    controller: _uniqueCodeController,
                    //controller: editingControllerPhone,
                    validator: (value) {
                      if (value!.length < 3) {
                        return 'Enter a valid unique id';
                      }
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black12, width: 2.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        labelText: 'Admission Code',
                        labelStyle: TextStyle(color: primaryColor),
                        suffixIcon: const Icon(
                          Icons.password,
                          color: Colors.black45,
                        )),
                  ),
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                InkWell(
                  onTap: () {
                    if (_verificationKey.currentState!.validate()) {
                      verifyUniqueCode();
                    }
                  },
                  child: Container(
                    height: 60,
                    width: w * 0.9,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoading
                            ? const SpinKitChasingDots(
                                color: Colors.white,
                              )
                            : const Text("Verify",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
