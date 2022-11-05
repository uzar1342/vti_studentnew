import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:vti_student/authentication/login_page.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';

class RegistrationPage extends StatefulWidget {
  final String phoneNumber, uniqueId;
  const RegistrationPage(
      {Key? key, required this.phoneNumber, required this.uniqueId})
      : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _registrationFormKey = GlobalKey();

  String dateOfBirth = 'Date of Birth';

  bool isLoading = true;

  bool submitLoading = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _motherNameController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();

  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _collegeNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  List<dynamic> countriesList = [];
  List<dynamic> statesList = [];
  List<dynamic> citiesList = [];

  String countryName = 'Country';
  String countryId = '';

  String stateName = 'State';
  String stateId = '';

  String cityName = 'City';
  String cityId = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirth = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  registerUser() async {
    setState(() {
      submitLoading = true;
    });
    final url = Uri.parse(Urls().signUpUserUrl);

    var body = json.encode([
      {
        "unique_id": widget.uniqueId,
        "mobile_number": widget.phoneNumber,
        "email": _emailAddressController.text,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "middle_name": _middleNameController.text,
        "mother_name": _motherNameController.text,
        "country": countryName,
        "state": stateName,
        "city": cityName,
        "dob": dateOfBirth,
        "address": _addressLine1Controller.text,
        "pin_code": _pinCodeController.text,
        "college_org_name": _collegeNameController.text,
        "parent_mobile_number": _parentPhoneController.text,
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
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false);
      } else {
        Fluttertoast.showToast(msg: res[0]['message']);
        setState(() {
          submitLoading = true;
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
      setState(() {
        submitLoading = true;
      });
    }
  }

  fetchCountriesList() async {
    final url =
        Uri.parse('https://virashtechnologies.com/vti-22/api/countries.php');

    Response response = await get(url);

    if (response.statusCode == 200) {
      setState(() {
        countriesList = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
      setState(() {
        isLoading = false;
      });
    }
  }

  fetchStateList() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
        "https://virashtechnologies.com/vti-22/api/states.php?country_id=$countryId");
    Response response = await get(url);

    if (response.statusCode == 200) {
      setState(() {
        statesList = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  fetchCitiesList() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(
        "https://virashtechnologies.com/vti-22/api/cities.php?state_id=$stateId");

    Response response = await get(url);

    if (response.statusCode == 200) {
      setState(() {
        citiesList = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchCountriesList();
    super.initState();
  }

  showDialogForDropDownCountry() {
    showDialog(
        context: context,
        builder: (context) {
          double h = MediaQuery.of(context).size.height;
          double w = MediaQuery.of(context).size.width;
          return StatefulBuilder(builder: (context, setter) {
            return Container(
              height: h * 0.6,
              width: w * 0.9,
              child: AlertDialog(
                title: Text("Country",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold)),
                content: Container(
                  height: h * 0.6,
                  width: w,
                  child: Column(
                    children: [
                      Container(
                        width: w * 0.9,
                        child: Card(
                          //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18))),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _searchController,
                            onChanged: (value) {
                              setter(() {});
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black26,
                                ),
                                hintText: "Search for Country",
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: countriesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (countriesList[index]['country_name']
                                .toString()
                                .toLowerCase()
                                .contains(
                                    _searchController.text.toLowerCase())) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    countryName =
                                        countriesList[index]['country_name'];
                                    countryId = countriesList[index]
                                            ['country_id']
                                        .toString();
                                    stateId = '';
                                    stateName = "State";
                                    cityId = '';
                                    cityName = "City";
                                  });
                                  _searchController.clear();
                                  fetchStateList();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: Card(
                                    child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(countriesList[index]
                                            ['country_name'])),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showDialogForDropDownState() {
    showDialog(
        context: context,
        builder: (context) {
          double h = MediaQuery.of(context).size.height;
          double w = MediaQuery.of(context).size.width;
          return StatefulBuilder(builder: (context, setter) {
            return Container(
              height: h * 0.6,
              width: w * 0.9,
              child: AlertDialog(
                title: Text("States",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold)),
                content: Container(
                  height: h * 0.6,
                  width: w,
                  child: Column(
                    children: [
                      Container(
                        width: w * 0.9,
                        child: Card(
                          //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18))),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _searchController,
                            onChanged: (value) {
                              setter(() {});
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black26,
                                ),
                                hintText: "Search for States",
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: statesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (statesList[index]['state_name']
                                .toString()
                                .toLowerCase()
                                .contains(
                                    _searchController.text.toLowerCase())) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    stateName = statesList[index]['state_name'];
                                    stateId = statesList[index]['state_id']
                                        .toString();
                                    cityId = '';
                                    cityName = "City";
                                  });
                                  _searchController.clear();
                                  fetchCitiesList();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: Card(
                                    child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            statesList[index]['state_name'])),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  showDialogForDropDownCity() {
    showDialog(
        context: context,
        builder: (context) {
          double h = MediaQuery.of(context).size.height;
          double w = MediaQuery.of(context).size.width;
          return StatefulBuilder(builder: (context, setter) {
            return Container(
              height: h * 0.6,
              width: w * 0.9,
              child: AlertDialog(
                title: Text("City",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold)),
                content: Container(
                  height: h * 0.6,
                  width: w,
                  child: Column(
                    children: [
                      Container(
                        width: w * 0.9,
                        child: Card(
                          //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                          elevation: 4,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18))),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _searchController,
                            onChanged: (value) {
                              setter(() {});
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black26,
                                ),
                                hintText: "Search for city",
                                hintStyle: TextStyle(color: Colors.black26),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(18.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: citiesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (citiesList[index]['city_name']
                                .toString()
                                .toLowerCase()
                                .contains(
                                    _searchController.text.toLowerCase())) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    cityName = citiesList[index]['city_name'];
                                    cityId =
                                        citiesList[index]['city_id'].toString();
                                  });
                                  _searchController.clear();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5.0),
                                  child: Card(
                                    child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                            citiesList[index]['city_name'])),
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: h * 0.35,
                      ),
                      SpinKitFadingCube(
                        color: primaryColor,
                      )
                    ],
                  ),
                )
              : Form(
                  key: _registrationFormKey,
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
                          Text(
                            "Registration Form",
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
                      const Text(
                        "Fill out the form below to complete the registration process.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: w * 0.02,
                          ),
                          Text(
                            "Personal Information",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _firstNameController,
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Enter a valid First Name';
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.person,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _middleNameController,
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Enter a valid Middle Name';
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'Middle Name',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.person,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _lastNameController,
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Enter a valid Last Name';
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'Surname/Last Name',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.person,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _motherNameController,
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Enter a valid Name';
                            }
                          },
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'Mothers Name',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.person,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      // Container(
                      //   width: w * 0.9,
                      //   child: TextFormField(
                      //     //controller: editingControllerPhone,

                      //     keyboardType: TextInputType.name,
                      //     decoration: InputDecoration(
                      //         border: const OutlineInputBorder(
                      //             borderSide:
                      //                 BorderSide(color: Colors.black12, width: 2.0),
                      //             borderRadius: BorderRadius.all(
                      //               Radius.circular(12.0),
                      //             )),
                      //         focusedBorder: OutlineInputBorder(
                      //             borderSide:
                      //                 BorderSide(color: primaryColor, width: 2.0),
                      //             borderRadius:
                      //                 const BorderRadius.all(Radius.circular(12.0))),
                      //         labelText: 'Date of Birth',
                      //         labelStyle: TextStyle(color: primaryColor),
                      //         suffixIcon: const Icon(
                      //           Icons.date_range,
                      //           color: Colors.black45,
                      //         )),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: w * 0.9,
                          height: h * 0.075,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black38,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateOfBirth,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                              ),
                              const Icon(
                                Icons.date_range,
                                color: Colors.black54,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: w * 0.02,
                          ),
                          Text(
                            "Contact Information",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        height: h * 0.075,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black38,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.phoneNumber,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0),
                            ),
                            const Icon(
                              Icons.phone,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _parentPhoneController,
                          validator: (value) {
                            if (value!.length != 10) {
                              return 'Enter a valid Phone Number';
                            }
                          },
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              counterText: "",
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'Parents Phone number',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.phone_android,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _emailAddressController,
                          validator: (value) {
                            if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!)) {
                            } else {
                              return 'Enter a valid email';
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'Email Address',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.email,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: w * 0.02,
                          ),
                          Text(
                            "Address Information",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 4,
                          //controller: editingControllerPhone,
                          controller: _addressLine1Controller,
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Enter a valid Address';
                            }
                          },
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'Address',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.home,
                                color: Colors.black45,
                              )),
                        ),
                      ),

                      SizedBox(
                        height: h * 0.01,
                      ),
                      InkWell(
                        onTap: () {
                          showDialogForDropDownCountry();
                        },
                        child: Container(
                          width: w * 0.9,
                          height: h * 0.075,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black38,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                countryName,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                              ),
                              const Icon(
                                Icons.public,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      InkWell(
                        onTap: () {
                          showDialogForDropDownState();
                        },
                        child: Container(
                          width: w * 0.9,
                          height: h * 0.075,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black38,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                stateName,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                              ),
                              const Icon(
                                Icons.location_city_rounded,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      InkWell(
                        onTap: () {
                          showDialogForDropDownCity();
                        },
                        child: Container(
                          width: w * 0.9,
                          height: h * 0.075,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black38,
                              ),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cityName,
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0),
                              ),
                              const Icon(
                                Icons.apartment,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _pinCodeController,
                          validator: (value) {
                            if (value!.length != 6) {
                              return 'Enter a valid Pincode';
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'Pincode',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.location_on,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: w * 0.02,
                          ),
                          Text(
                            "Educational Information",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Container(
                        width: w * 0.9,
                        child: TextFormField(
                          //controller: editingControllerPhone,
                          controller: _collegeNameController,
                          validator: (value) {
                            if (value!.length < 3) {
                              return 'Enter a valid College/Organization name';
                            }
                          },
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black12, width: 2.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: primaryColor, width: 2.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              labelText: 'College Name/Organization',
                              labelStyle: TextStyle(color: primaryColor),
                              suffixIcon: const Icon(
                                Icons.school,
                                color: Colors.black45,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                      InkWell(
                        onTap: () {
                          if (_registrationFormKey.currentState!.validate()) {
                            if (countryId != '' &&
                                stateId != '' &&
                                cityId != '') {
                              registerUser();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Select Countries, States & City");
                            }
                          }
                        },
                        child: Container(
                          height: h * 0.07,
                          width: w * 0.9,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(14.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              submitLoading
                                  ? const SpinKitChasingDots(
                                      color: Colors.white,
                                    )
                                  : const Text("Register",
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
