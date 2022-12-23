import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:vti_student/configs/globals.dart';

class Uploadimg extends StatefulWidget {
  const Uploadimg({
    Key? key,

  }) : super(key: key);

  @override
  _UploadimgState createState() => _UploadimgState();
}

class _UploadimgState extends State<Uploadimg> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
 File? image;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _body(),
      ],
    );
  }

  Widget _body() {
    if (_croppedFile != null &&  _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 250, width: 230,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  3,3,3,3),
              child: _image(),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    const screenWidth = 200;
    const screenHeight = 200;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 0.7 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path), fit: BoxFit.fill,),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 0.3 * screenWidth,
          maxHeight: 0.2 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                uploadimg();
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Upload',
              child: const Icon(Icons.upload_rounded),
            ),
          )
      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 320.0,
          height: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [6, 4],
                    color: Theme.of(context).highlightColor.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Choose Your Profile Photo',
                            style: kIsWeb
                                ? Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                color: Theme.of(context).highlightColor)
                                : Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                color:
                                Theme.of(context).highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                       child: ElevatedButton(
                         onPressed: () {
                           _uploadImage();
                         },
                         child: const Text('Gallery'),
                       ),
                    ),
                  SizedBox(width: 30,),
                   Container(
                    child: ElevatedButton(
                   onPressed: () {
                     _camerasImage();
                   },
                   child: const Text('Camera'),
                    ),
                  ),],),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Future<void>_cameraImage() async{
  //   final image=ImagePicker.pickImage(source: ImageSource.camera, maxWidth:200, maxHeight: 200,
  //  imageQuality: 1080,  );
  //   if (image == null) return;
  //
  //   final imageTemporary = File(image.path);
  //    setState(() => this.image= imageTemporary;
  // }


  void uploadimg() async {
    final url = Uri.parse('http://training.virash.in/uploadProfileImage');
    var request = MultipartRequest("POST", url);
    request.fields['student_id '] = userId;
    File file = File(_croppedFile!.path);
    var multiPartFile =
    await http.MultipartFile.fromPath("image", file.path);
    request.files.add(multiPartFile);
    print(request.fields);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      if(response.statusCode==200)
      {
        
        print(value.split(",").first.split(":").last);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: value.split(",").last.split(":").last.replaceAll('"', '').replaceAll("}", ""));
      }
      else
      {
       Navigator.pop(context);
        Fluttertoast.showToast(msg: value.toString());

      }
    }
    );

  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        maxHeight: 1080,
        maxWidth: 1080,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              lockAspectRatio: true,
              showCropGrid:true,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: false,
              cropFrameStrokeWidth:3,
          ),
          IOSUiSettings(
            title: 'Crop Your Image',
          ),
          WebUiSettings(
            context: context,
            enableResize:false,
            enforceBoundary:true,
            presentStyle: CropperPresentStyle.page,
            boundary: const CroppieBoundary(
              width: 500,
              height:500,
            ),
            viewPort:
            const CroppieViewPort(
                width: 520, height: 520, type: 'square'),
            enableExif: true,
            enableZoom: true,
            showZoomer: false,
          ),
        ],

      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
    await ImagePicker().pickImage(
        source: ImageSource.gallery, );
    if (pickedFile != null) {
      setState(() {
        _pickedFile=pickedFile;
        _cropImage();
      });
    }
  }
  Future<void> _camerasImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }
}