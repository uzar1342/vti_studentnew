import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';

class AllResourcesPage extends StatefulWidget {
  const AllResourcesPage({Key? key}) : super(key: key);

  @override
  _AllResourcesPageState createState() => _AllResourcesPageState();
}

class _AllResourcesPageState extends State<AllResourcesPage> {
  final TextEditingController _searchController = TextEditingController();
  bool showSearch = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                showSearch
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: w * 0.7,
                            child: Card(
                              //margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                              elevation: 4,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: TextFormField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.orange.shade200,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.black38,
                                        size: 20.0,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                        });
                                      },
                                    ),
                                    hintText: "Search",
                                    hintStyle:
                                        const TextStyle(color: Colors.black26),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18.0)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 16.0)),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  showSearch = false;
                                  _searchController.clear();
                                });
                              },
                              child: Text("Close",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    decoration: TextDecoration.underline,
                                  ))),
                        ],
                      )
                    : Row(
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
                            "Resouces/Notes",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showSearch = true;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: primaryColor,
                                  )),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NotificationsPage()));
                                },
                                icon: Icon(
                                  Icons.notifications,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                SizedBox(
                  height: h * 0.02,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      // if (index == 4) {
                      //   return InkWell(
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => AllResourcesPage()));
                      //     },
                      //     child: Container(
                      //       margin: EdgeInsets.only(top: 10.0, right: 10.0),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //           Text(
                      //             "View More",
                      //             style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontWeight: FontWeight.bold),
                      //           ),
                      //           Icon(
                      //             Icons.arrow_forward_ios,
                      //             color: primaryColor,
                      //             size: 25.0,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   );
                      // }

                      return Card(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0))),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  index % 2 == 0
                                      ? Icon(Icons.picture_as_pdf,
                                          color: Colors.red.shade300)
                                      : const FaIcon(
                                          FontAwesomeIcons.globe,
                                          color: Colors.blue,
                                        ),
                                  SizedBox(
                                    width: w * 0.02,
                                  ),
                                  Container(
                                    width: w * 0.7,
                                    child: index % 2 == 0
                                        ? const Text(
                                            "Code example of looping in Java",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const Text(
                                            "How to setup Flutter in windows",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold),
                                          ),
                                  )
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
