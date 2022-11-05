import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';
import 'package:vti_student/home/profile/settings.dart';

import '../../authentication/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = true;

  String appName = 'Virash';
  String version = '';
  String buildNumber = '';
  var profileDetails ;

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    setState(() {
      appName = packageInfo.appName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  fetchProfileDetails() async {
    final url = Uri.parse(Urls().profileUrl);

    var map = new Map<String, dynamic>();
    map['mobile_number'] = '7718953211';


    Response response = await post(
      url,
      body: map,
    );

    if (response.statusCode == 200) {
      getPackageInfo();
      setState(() {
        profileDetails = jsonDecode(response.body.toString());
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
    }
  }

  @override
  void initState() {
    fetchProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: h * 0.4,
                        ),
                        SpinKitFadingCube(
                          color: primaryColor,
                        )
                      ],
                    ),
                  )
                : Column(
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
                          const Text(
                            "My Profile",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16.0))),
                                        title: Text(
                                          "Logout",
                                          style: TextStyle(
                                              color: Colors.red.shade400,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: const Text(
                                            "Do you wish to logout?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                  color: primaryColor),
                                            ),
                                          ),
                                          // TextButton(
                                          //   onPressed: () async {
                                          //     Navigator.pushAndRemoveUntil(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 const LoginPage()),
                                          //         (route) => false);
                                          //     Fluttertoast.showToast(
                                          //         msg: "Logged out");
                                          //   },
                                          //   child: Text(
                                          //     "Yes",
                                          //     style: TextStyle(
                                          //         color: primaryColor),
                                          //   ),
                                          // )
                                          GestureDetector(
                                            onTap: () async {
                                              SharedPreferences _prefs = await SharedPreferences.getInstance();
                                              _prefs.clear();
                                              Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginPage()),
                                                          (route) => false);
                                                      Fluttertoast.showToast(
                                                          msg: "Logged out");
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14.0),
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(14.0))),
                                              child: const Text(
                                                "Yes",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.exit_to_app,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * 0.04,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity - 100,
                        child: Card(
                          elevation: 3.0,
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.02,
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  "Name",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    "${profileDetails["data"][0]["name"].toString()} ${profileDetails["data"][0]['last_name'].toString()}"),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              // ListTile(
                              //   leading: Container(
                              //     height: h * 0.06,
                              //     width: h * 0.06,
                              //     decoration: BoxDecoration(
                              //       color: primaryColor.withOpacity(0.4),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Icon(
                              //       Icons.person,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   title: const Text(
                              //     "Middle name",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   ),
                              //   subtitle:
                              //       Text("${profileDetails["data"][0]['middle_name']}"),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios,
                              //     size: 20.0,
                              //     color: Colors.grey.shade300,
                              //   ),
                              // ),
                              // ListTile(
                              //   leading: Container(
                              //     height: h * 0.06,
                              //     width: h * 0.06,
                              //     decoration: BoxDecoration(
                              //       color: primaryColor.withOpacity(0.4),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Icon(
                              //       Icons.person,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   title: const Text(
                              //     "Mother's name",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   ),
                              //   subtitle:
                              //       Text("${profileDetails["data"][0]['mother_name']}"),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios,
                              //     size: 20.0,
                              //     color: Colors.grey.shade300,
                              //   ),
                              // ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  "Date of Birth",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  profileDetails["data"][0]['dob'].toString(),
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  "Email",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  profileDetails["data"][0]['student_mail'].toString(),
                                  style: const TextStyle(fontSize: 12.0),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  "Phone number",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    "+91-${profileDetails["data"][0]['mobile_number'].toString()}"),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              // ListTile(
                              //   leading: Container(
                              //     height: h * 0.06,
                              //     width: h * 0.06,
                              //     decoration: BoxDecoration(
                              //       color: primaryColor.withOpacity(0.4),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Icon(
                              //       Icons.phone,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   title: const Text(
                              //     "Parents number",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   ),
                              //   subtitle: Text(
                              //       "+91-${profileDetails["data"][0]['parent_mobile_number']}"),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios,
                              //     size: 20.0,
                              //     color: Colors.grey.shade300,
                              //   ),
                              // ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity - 100,
                        child: Card(
                          elevation: 3.0,
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.02,
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.school,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  "Courses",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(profileDetails["data"][0]['course'].toString()),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.school,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: const Text(
                                  "Batch",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  profileDetails["data"][0]['batch'].toString(),
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity - 100,
                        child: Card(
                          elevation: 3.0,
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.02,
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.school,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  "College/Org",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(profileDetails["data"][0]['college_org_name'].toString()),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity - 100,
                        child: Card(
                          elevation: 3.0,
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.02,
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.home,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: const Text(
                                  "Address",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  profileDetails["data"][0]['address']
                                      .toString()
                                      .trim(),
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              // ListTile(
                              //   leading: Container(
                              //     height: h * 0.06,
                              //     width: h * 0.06,
                              //     decoration: BoxDecoration(
                              //       color: primaryColor.withOpacity(0.4),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Center(
                              //       child: FaIcon(
                              //         FontAwesomeIcons.globeAfrica,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              //   title: const Text(
                              //     "Country",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   ),
                              //   subtitle: Text(profileDetails["data"][0]['country']),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios,
                              //     size: 20.0,
                              //     color: Colors.grey.shade300,
                              //   ),
                              // ),
                              // ListTile(
                              //   leading: Container(
                              //     height: h * 0.06,
                              //     width: h * 0.06,
                              //     decoration: BoxDecoration(
                              //       color: primaryColor.withOpacity(0.4),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Center(
                              //       child: FaIcon(
                              //         FontAwesomeIcons.globeAmericas,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              //   title: const Text(
                              //     "State",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   ),
                              //   subtitle: Text(profileDetails["data"][0]['state']),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios,
                              //     size: 20.0,
                              //     color: Colors.grey.shade300,
                              //   ),
                              // ),
                              // ListTile(
                              //   leading: Container(
                              //     height: h * 0.06,
                              //     width: h * 0.06,
                              //     decoration: BoxDecoration(
                              //       color: primaryColor.withOpacity(0.4),
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: const Center(
                              //       child: FaIcon(
                              //         FontAwesomeIcons.globeEurope,
                              //         color: Colors.white,
                              //       ),
                              //     ),
                              //   ),
                              //   title: const Text(
                              //     "City",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   ),
                              //   subtitle: Text(profileDetails["data"][0]['city']),
                              //   trailing: Icon(
                              //     Icons.arrow_forward_ios,
                              //     size: 20.0,
                              //     color: Colors.grey.shade300,
                              //   ),
                              // ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.addressCard,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: const Text(
                                  "Pincode",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    profileDetails["data"][0]['pin_code'].toString()),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity - 100,
                        child: Card(
                          elevation: 3.0,
                          child: Column(
                            children: [
                              SizedBox(
                                height: h * 0.02,
                              ),
                              ListTile(
                                leading: Container(
                                  height: h * 0.06,
                                  width: h * 0.06,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.school,
                                    color: Colors.white,
                                  ),
                                ),
                                title: const Text(
                                  "Registration Date",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle:
                                    Text(profileDetails["data"][0]['register_date'].toString()),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.0,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(
                                height: h * 0.02,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$appName - $buildNumber ($version)",
                        style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
