import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:trains/models/user.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:trains/services/database.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final DatabaseService _dbService = DatabaseService();
  Image _image;

  /*Future checkImage(BuildContext context) async {
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
  }*/

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
    final user = Provider.of<User>(context);
    //checkImage(context);
    print("width: ${MediaQuery.of(context).size.width}height:${MediaQuery.of(context).size.height}");
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
            FutureBuilder<Image>(
                  future: _dbService.checkUserImageById(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Positioned(
                        top: MediaQuery.of(context).size.height/2,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width/3,
                          backgroundColor: Colors.brown[50],
                          child: ClipOval(
                            child: new SizedBox(
                              width: MediaQuery.of(context).size.width/1.5,
                              height: MediaQuery.of(context).size.width/1.5,
                              child: snapshot.data,
                            ),
                          ),
                        ),
                      );
                    } 
                    else if(snapshot.hasError){
                      return Positioned(
                        top: MediaQuery.of(context).size.height/2,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width/3,
                          backgroundColor: Colors.brown[50],
                          child: ClipOval(
                              child: new SizedBox(
                                width: MediaQuery.of(context).size.width/1.5,
                                height: MediaQuery.of(context).size.width/1.5,
                                child: Image(image: AssetImage("assets/default.png"),
                                  fit: BoxFit.cover,),
                              ),
                          ),
                        ),
                       );          
                    } else {
                      return Positioned(
                        top: MediaQuery.of(context).size.height/2,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width/3,
                          backgroundColor: Colors.brown[50],
                          child: ClipOval(
                            child: new SizedBox(
                              width: MediaQuery.of(context).size.width/1.5,
                              height: MediaQuery.of(context).size.width/1.5,
                              child: CircularProgressIndicator(
                                strokeWidth: 7,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            Positioned(
              top: MediaQuery.of(context).size.height/1.33,
              left: MediaQuery.of(context).size.width/1.6,
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
