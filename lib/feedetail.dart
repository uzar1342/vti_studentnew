import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart'as http;

import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'configs/globals.dart';
import 'configs/urls.dart';
import 'flutter_flow/flutter_flow.dart';
import 'flutter_flow/flutter_flow_theme.dart';

class feedetail extends StatefulWidget {
  const feedetail({Key? key}) : super(key: key);

  @override
  State<feedetail> createState() => _feedetailState();
}

class _feedetailState extends State<feedetail> {
  @override
  bool isLoading = true;
  bool showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  var profileDetails ;

  fetchFeeDetails() async {
    final url = Uri.parse(Urls().feeDetails);
    var map = new Map<String, dynamic>();
    map['student_id'] = userId;

    print(map);

    http.Response response = await post(
      url,
      body: map,
    );

    if (response.statusCode == 200) {

      setState(() {
        profileDetails = jsonDecode(response.body.toString());
        isLoading = false;
      });
    } else {
      Fluttertoast.showToast(msg: "Please try again later");
    }
  }

  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  var _onPressed;
  late Directory externalDir;

  String convertCurrentDateTimeToString() {
    String formattedDateTime =
    DateFormat('yyyyMMdd_kkmmss').format(DateTime.now()).toString();
    return formattedDateTime;
  }

  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }

  @override
  void initState() {
  fetchFeeDetails();
  if (Platform.isAndroid) {
    platform = TargetPlatform.android;
  } else {
    platform = TargetPlatform.iOS;
  }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return LoaderOverlay(
      child: Scaffold(
        body:SafeArea(
          child:isLoading ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SpinKitFadingCube(
                  color: primaryColor,
                ),
                // CircularProgressIndicator(
                //   color: primaryColor,
                // ),
                // SizedBox(
                //   height: 10.0,
                // ),
                // Text("Loading...")
              ],
            ),
          ):SingleChildScrollView(
            child: Column(children: [

              showSearch ? Row(
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
                    child: const Text("Close",
                        style: TextStyle(
                          color: Colors.black54,
                          decoration: TextDecoration.underline,
                        ))),
              ],
            )
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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

            ],
            ),
            // Container(
            //   height: h * 0.06,
            //   width: h * 0.06,
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage("assets/images/person.jpg"),
            //           fit: BoxFit.cover),
            //       borderRadius: BorderRadius.all(Radius.circular(8.0))),
            // ),
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

            },
            icon: Icon(
            Icons.notifications,
            color: primaryColor,
            size: 25,
            ))
            ],
            )
            ],
            ),
                ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: profileDetails["data"].length,
                itemBuilder: (BuildContext context, int index) {

                  var per =int.parse(profileDetails["data"][index]["outstanding_amt"].toString().replaceAll(",", ""))/int.parse(profileDetails["data"][index]["total_fees"].toString().replaceAll(",", ""));
                  var paidamount=int.parse(profileDetails["data"][index]["total_fees"].toString().replaceAll(",", ""))-int.parse(profileDetails["data"][index]["outstanding_amt"].toString().replaceAll(",", ""));
                  per=1-per;
                  print(per);
                  return  Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                        child: Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFFF1F4F8),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(12, 16, 12, 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '₹ ${profileDetails["data"][index]["paid_amt"].toString()}',
                                      style: FlutterFlowTheme.of(context).subtitle1.override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF101213),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          context.loaderOverlay.show();
                                        });
                                        _permissionReady = await _checkPermission();

                                        if (_permissionReady) {
                                          await _prepareSaveDir();
                                          print("Downloading");
                                          try {



                                            await Dio().download("http://training.virash.in/receipt-voucher?no=${profileDetails["data"][index]["fees_id"]}&vid=${profileDetails["data"][index]["unique_id"]}",
                                                _localPath + "filename.pdf",
                                                onReceiveProgress: (received, total) {

                                                  if (total != -1) {
                                                    print((received / total * 100).toStringAsFixed(0));


                                                  }
                                                });
                                            print("Download Completed.");
setState(() {
  context.loaderOverlay.hide();
});
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text(
                                                      "Download",
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    content:Text("Download Complete"),
                                                    actions: [ElevatedButton(onPressed: () {
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => PDFScreen( path: _localPath + "filename.pdf",)
                                                          ));

                                                    }, child: Text("Open PDF"))],
                                                  ));
                                          } catch (e) {
                                            print("Download Failed.\n\n" + e.toString());
                                          }
                                        }
                                         },
                                      child:  Icon(
                                        Icons.download_rounded,
                                        color: primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                                profileDetails["data"][index]["transaction_id"]!="N/A"? Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                                  child: Text(
                                    '${profileDetails["data"][index]["payment_mode"]}  Transaction ID: ${profileDetails["data"][index]["transaction_id"]}',
                                    style: FlutterFlowTheme.of(context).bodyText2.override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ):Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                                  child: Text(
                                    '${profileDetails["data"][index]["payment_mode"]}',
                                    style: FlutterFlowTheme.of(context).bodyText2.override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Payment Date: ${profileDetails["data"][index]["payment_date"]}',
                                  style: FlutterFlowTheme.of(context).bodyText2.override(
                                    fontFamily: 'Outfit',
                                    color: Color(0xFF57636C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                                  child: LinearPercentIndicator(
                                    percent: per,
                                    width: w*0.7,
                                    lineHeight: 16,
                                    animation: true,
                                    progressColor: primaryColor,
                                    backgroundColor: Color(0xFFF1F4F8),
                                    barRadius: Radius.circular(16),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '${paidamount} ',
                                      style: FlutterFlowTheme.of(context).subtitle1.override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF101213),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      ' of  ${profileDetails["data"][index]["total_fees"]}',
                                      style: FlutterFlowTheme.of(context).subtitle1.override(
                                        fontFamily: 'Outfit',
                                        color: Color(0xFF57636C),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                  child: Text(
                                    'Next Installment: ${profileDetails["data"][index]["next_installment"]}',
                                    style: FlutterFlowTheme.of(context).bodyText2.override(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 24,
                                  thickness: 2,
                                  color: Color(0xFFF1F4F8),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            "View Image",
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Container(
                                            child: SingleChildScrollView(
                                              child: Form(
                                                child: Column(
                                                  children: [
                                                    Image.network(profileDetails["data"][index]["transaction_attachment"])
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          actions: [ElevatedButton(onPressed: () {

                                            Navigator.pop(context);
                                          }, child: Text("OK"))],
                                        ));
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration:  BoxDecoration(
                                          color: primaryColor,
                                          boxShadow: const [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x2B202529),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                        child: const Icon(
                                          Icons.attach_file_rounded,
                                          color: Color(0xFFF6F3F3),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                                          child: Text(
                                            'Show Transaction Attachment',
                                            style:
                                            FlutterFlowTheme.of(context).subtitle2.override(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF57636C),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Color(0xFF57636C),
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );},
              )
            ],),
          ),
        ),
      ),
    );

  }
}


class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, required this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
            false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}