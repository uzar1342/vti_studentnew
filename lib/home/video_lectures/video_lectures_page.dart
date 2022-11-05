import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';
import 'package:vti_student/home/video_lectures/video_details_page.dart';

class VideoLecturesPage extends StatefulWidget {
  final List<dynamic> categories;
  const VideoLecturesPage({Key? key, required this.categories})
      : super(key: key);

  @override
  _VideoLecturesPageState createState() => _VideoLecturesPageState();
}

class _VideoLecturesPageState extends State<VideoLecturesPage> {
  bool showSearch = false;

  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  List<dynamic> demoVideos = [];

  List<String> selectedTech = [];
  List<String> selectedTechIds = [];

  List<String> levels = ['Beginner', 'Intermediate', 'Expert'];
  List<String> levelIds = ["1", "2", "3"];

  List<String> selectedLevels = [];
  List<String> selectedLevelIds = [];



  bool isTechSelected(String tech) {
    if (selectedTech.contains(tech)) {
      return true;
    } else {
      return false;
    }
  }

  bool isLevelSelected(String level) {
    if (selectedLevels.contains(level)) {
      return true;
    } else {
      return false;
    }
  }

  fetchInitialVideos() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse(Urls().demoVideoListUrl);
    Response response = await post(
      url,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        demoVideos = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
    }
  }

  fetchFilteredVideos() async {
    setState(() {
      isLoading = true;
    });
    String selectedTechIdsText = '';
    String selectedLevelIdsText = '';
    if (selectedTechIds.isNotEmpty) {
      for (int i = 0; i < selectedTechIds.length; i++) {
        selectedTechIdsText += "${selectedTechIds[i]}|";
      }
      selectedTechIdsText =
          selectedTechIdsText.substring(0, selectedTechIdsText.length - 1);
    }
    if (selectedLevelIds.isNotEmpty) {
      for (int i = 0; i < selectedLevelIds.length; i++) {
        selectedLevelIdsText += "${selectedLevelIds[i]}|";
      }
      selectedLevelIdsText =
          selectedLevelIdsText.substring(0, selectedLevelIdsText.length - 1);
    }
    final url = Uri.parse(Urls().demoVideoListUrl);
    var body = json.encode([
      {
        "cat_technology": selectedTechIdsText,
        "cat_level": selectedLevelIdsText,
      }
    ]);

    Response response = await post(
      url,
      body: body,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        demoVideos = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  showFilterBottomSheet() {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        builder: (context) => StatefulBuilder(builder: (context, stateSetter) {
              return Container(
                height: 430,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Filter Blogs",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.black54,
                            ))
                      ],
                    ),
                    Text(
                      "Select your desired categories to view",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(),
                    Row(
                      children: [
                        Icon(
                          Icons.android,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Technologies"),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 60,
                      child: ListView.builder(
                          itemCount: widget.categories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                stateSetter(() {
                                  if (selectedTech.contains(widget
                                          .categories[index]['technology']) ||
                                      selectedTechIds.contains(widget
                                          .categories[index]['id']
                                          .toString())) {
                                    selectedTech.remove(
                                        widget.categories[index]['technology']);
                                    selectedTechIds.remove(widget
                                        .categories[index]['id']
                                        .toString());
                                    print(selectedTechIds);
                                  } else {
                                    selectedTech.add(
                                        widget.categories[index]['technology']);
                                    selectedTechIds.add(widget.categories[index]
                                            ['id']
                                        .toString());
                                    print(selectedTechIds);
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: isTechSelected(widget.categories[index]
                                          ['technology'])
                                      ? primaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                      widget.categories[index]['technology'],
                                      style: TextStyle(
                                          color: isTechSelected(
                                                  widget.categories[index]
                                                      ['technology'])
                                              ? Colors.white
                                              : primaryColor)),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Divider(),
                    Row(
                      children: [
                        Icon(Icons.speed, color: primaryColor),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text("Experties"),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 60,
                      child: ListView.builder(
                          itemCount: levels.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                stateSetter(() {
                                  if (selectedLevels.contains(levels[index]) ||
                                      selectedLevelIds
                                          .contains(levelIds[index])) {
                                    selectedLevels.remove(levels[index]);
                                    selectedLevelIds.remove(levelIds[index]);
                                  } else {
                                    selectedLevels.add(levels[index]);
                                    selectedLevelIds.add(levelIds[index]);
                                  }
                                });
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: isLevelSelected(levels[index])
                                      ? primaryColor
                                      : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0),
                                  ),
                                  border: Border.all(
                                    color: primaryColor,
                                  ),
                                ),
                                child: Center(
                                  child: Text(levels[index],
                                      style: TextStyle(
                                          color: isLevelSelected(levels[index])
                                              ? Colors.white
                                              : primaryColor)),
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        selectedTech.isEmpty
                            ? Container()
                            : Text("${selectedTech.length} Selected",
                                style: const TextStyle(
                                  color: Colors.black54,
                                )),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            fetchFilteredVideos();
                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(14.0),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  @override
  void initState() {

    fetchInitialVideos();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          onPressed: () {
            showFilterBottomSheet();
          },
          label: Row(
            children: const [
              Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Filter",
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          )),
      body: SafeArea(
          child: isLoading
              ? Center(
                  child: SpinKitFadingCube(
                    color: primaryColor,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(15.0),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12))),
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
                                          hintStyle: const TextStyle(
                                              color: Colors.black26),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18.0)),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 16.0)),
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
                                  "Videos",
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
                        height: h * 0.01,
                      ),
                      const Text(
                        "Below consists the list of the all the Video Lectures.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      selectedTech.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.only(top: 5.0),
                              height: 40,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedTech.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        selectedTech
                                            .remove(selectedTech[index]);
                                        selectedTechIds
                                            .remove(selectedTechIds[index]);
                                        fetchFilteredVideos();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        height: 40,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 3.0),
                                        decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))),
                                        child: Row(
                                          children: [
                                            Text(
                                              selectedTech[index],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: w * 0.01,
                                            ),
                                            Icon(
                                              Icons.close,
                                              color: Colors.white38,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          : Container(),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Expanded(
                          child: ListView.builder(
                              itemCount: demoVideos.length,
                              itemBuilder: (context, index) {
                                if (demoVideos[index]['title']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase())) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoDetailsPage(
                                                    videoId: demoVideos[index]
                                                            ['video_id']
                                                        .toString(),
                                                  )));
                                    },
                                    child: Container(
                                      child: Card(
                                        elevation: 3.0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0))),
                                        child: Container(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: h * 0.2,
                                                width: w,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            demoVideos[index]
                                                                ['thumbnail']),
                                                        fit: BoxFit.cover),
                                                    color: primaryColor,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                14.0))),
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/vti_logo.png",
                                                          height: 35,
                                                          width: 35,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.02,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: w * 0.7,
                                                                child: Text(
                                                                  demoVideos[
                                                                          index]
                                                                      ['title'],
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    h * 0.005,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5.0),
                                                                child: Text(
                                                                  "By Prof. ${demoVideos[index]['faculty_name']}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .yellow,
                                                                      ),
                                                                      Text(
                                                                        demoVideos[index]
                                                                            [
                                                                            'ratings'],
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: w *
                                                                        0.03,
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10.0),
                                                                      ),
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                    child: Text(
                                                                      demoVideos[
                                                                              index]
                                                                          [
                                                                          'tag'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              13.0),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: h * 0.02,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }))
                    ],
                  ),
                )),
    );
  }
}
