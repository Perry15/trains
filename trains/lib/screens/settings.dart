import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trains/models/user.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:simple_image_crop/simple_image_crop.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Image _image;

// no need of the file extension, the name will do fine.
  Future checkImage(BuildContext context) async {
    final user = Provider.of<User>(context);
    try {
      final String url = await FirebaseStorage.instance
          .ref()
          .child('profileImages/${user.uid}')
          .getDownloadURL();
      //print("url $url");
      setState(() {
        _image = Image.network(
          url,
          fit: BoxFit.cover,
        );
      });
    } catch (e) {
      print("errore ${e.toString()}");
      if (this.mounted) {
        setState(() {
          _image = Image(
            image: AssetImage("assets/default.png"),
            fit: BoxFit.cover,
          );
        });
      }
    }

    /*var url = await ref.getDownloadURL();
    print(url);*/
  }

  Future getImage(BuildContext context) async {
    File image = await FilePicker.getFile(type: FileType.IMAGE);
    
    //upload
    final user = Provider.of<User>(context);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profileImages/${user.uid}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
    await uploadTask.onComplete;
    setState(() {
      _image = Image.file(image);
    });
  }

  /*Future uploadPic(BuildContext context) async{
    final user = Provider.of<User>(context);
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('profileImages/${user.uid}');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
    });
  }*/
  final imgCropKey = GlobalKey<ImgCropState>();
  @override
  Widget build(BuildContext context) {
    checkImage(context);
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Modifica Profilo'),
        backgroundColor: Color(0xff9b0014),
        elevation: 0.0,
      ),
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            //TODO imageCrop
            /*ImgCrop(
              key: imgCropKey,
              chipRadius: 150,  // crop area radius
              chipShape: 'circle', // crop type "circle" or "rect"
              image: Image.file(_image),
            ),*/
            Positioned(
              top: 20,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Color(0xff9b0014),
                child: ClipOval(
                  child: new SizedBox(
                    width: 180.0,
                    height: 180.0,
                    child: (_image != null)
                        ? _image
                        : CircularProgressIndicator(
                            strokeWidth: 7,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 180,
              left: 230,
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                onPressed: () {
                  getImage(context);
                },
                tooltip: 'Modifica immagine',
                child: Icon(Icons.add_a_photo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
