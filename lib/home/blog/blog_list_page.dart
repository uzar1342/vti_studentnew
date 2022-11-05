import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';
import 'package:vti_student/home/blog/blog_webview_page.dart';
import 'package:vti_student/home/notifications/notifications_page.dart';

class BlogListPage extends StatefulWidget {
  final List<dynamic> blogCategories;
  final List<dynamic> blogs;
  final String? categoryId;
  final String? categoryName;
  const BlogListPage(
      {Key? key,
      required this.blogCategories,
      required this.blogs,
      this.categoryId,
      this.categoryName})
      : super(key: key);

  @override
  _BlogListPageState createState() => _BlogListPageState();
}

class _BlogListPageState extends State<BlogListPage> {
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;

  bool showSearch = false;

  List<String> selectedTech = [];
  List<String> selectedTechIds = [];

  List<String> levels = ['Beginner', 'Intermediate', 'Expert'];
  List<String> levelIds = ["1", "2", "3"];

  List<String> selectedLevels = [];
  List<String> selectedLevelIds = [];
  List<dynamic> blogs = [];

  fetchInitialBlogs() async {
    final url = Uri.parse(Urls().blogUrl);
    var body;
    if (widget.categoryId != null) {
      selectedTech.add(widget.categoryName!);
      selectedTechIds.add(widget.categoryId!);
      body = json.encode([
        {
          "cat_technology": widget.categoryId,
          "cat_level": "",
        }
      ]);
    } else {
      body = json.encode([
        {
          "cat_technology": "",
          "cat_level": "",
        }
      ]);
    }

    Response response = await post(
      url,
      body: body,
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        blogs = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

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

  fetchFilteredBlog() async {
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
    final url = Uri.parse(Urls().blogUrl);
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
        blogs = jsonDecode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchInitialBlogs();
    super.initState();
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
                          itemCount: widget.blogCategories.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                stateSetter(() {
                                  if (selectedTech.contains(
                                          widget.blogCategories[index]
                                              ['technology']) ||
                                      selectedTechIds.contains(widget
                                          .blogCategories[index]['id']
                                          .toString())) {
                                    selectedTech.remove(widget
                                        .blogCategories[index]['technology']);
                                    selectedTechIds.remove(widget
                                        .blogCategories[index]['id']
                                        .toString());
                                    print(selectedTechIds);
                                  } else {
                                    selectedTech.add(widget
                                        .blogCategories[index]['technology']);
                                    selectedTechIds.add(widget
                                        .blogCategories[index]['id']
                                        .toString());
                                    print(selectedTechIds);
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: isTechSelected(widget
                                          .blogCategories[index]['technology'])
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
                                      widget.blogCategories[index]
                                          ['technology'],
                                      style: TextStyle(
                                          color: isTechSelected(
                                                  widget.blogCategories[index]
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
                            fetchFilteredBlog();
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
          child: Container(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCube(
                      color: primaryColor,
                    ),
                  ],
                ),
              )
            : Column(
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
                              "Our Blog",
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
                  const Text(
                    "Do check out our blog content, it contains gems of programming",
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
                                    selectedTech.remove(selectedTech[index]);
                                    selectedTechIds
                                        .remove(selectedTechIds[index]);
                                    fetchFilteredBlog();
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    height: 40,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 3.0),
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
                    height: h * 0.01,
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: blogs.length,
                          itemBuilder: (context, index) {
                            if (widget.blogs[index]['title']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase()) ||
                                widget.blogs[index]['cat_technology']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase()) ||
                                widget.blogs[index]['cat_level']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase()) ||
                                widget.blogs[index]['added_by']
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                        _searchController.text.toLowerCase())) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BlogWebviewPage(
                                              url: widget.blogs[index]
                                                  ['post_url'])));
                                },
                                child: Card(
                                  elevation: 3.0,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(14.0))),
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: h * 0.2,
                                          width: w,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      blogs[index]
                                                          ['thumbnail']),
                                                  fit: BoxFit.cover),
                                              color: primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14.0))),
                                        ),
                                        SizedBox(
                                          height: h * 0.02,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              blogs[index]['title'],
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: h * 0.005,
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.category,
                                                    color: primaryColor),
                                                SizedBox(
                                                  width: w * 0.02,
                                                ),
                                                Text(
                                                  blogs[index]
                                                      ['cat_technology'],
                                                  style: TextStyle(
                                                      letterSpacing: 1.0,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.speed,
                                                    color: primaryColor),
                                                SizedBox(
                                                  width: w * 0.02,
                                                ),
                                                Text(
                                                  blogs[index]['cat_level'],
                                                  style: TextStyle(
                                                      letterSpacing: 1.0,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.person,
                                                        color: primaryColor),
                                                    SizedBox(
                                                      width: w * 0.02,
                                                    ),
                                                    Text(
                                                      blogs[index]['added_by'],
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          letterSpacing: 1.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.amber,
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
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
