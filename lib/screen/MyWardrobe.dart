import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterdemoappwardrobe/database/WardrobeDb.dart';
import 'package:flutterdemoappwardrobe/model/PhotoVO.dart';
import 'package:flutterdemoappwardrobe/utility/Utility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MyWardrobe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyWardrobeState();
  }
}

class MyWardrobeState extends State<MyWardrobe> {
  WardrobeDb db;
  List<PhotoVO> photoTopList, photoBottomList;
  int topCount = 0, bottomCount = 0;
  String topWear;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = WardrobeDb();
    refreshPhotos();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Wardrobe"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.vertical_align_bottom,
            ),
            tooltip: "Bottom",
            onPressed: () {
              topWear = "0";
              openGallery();
//              showClickOptions();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.vertical_align_top,
            ),
            tooltip: "Top",
            onPressed: () {
              topWear = "1";
              openGallery();
//              showClickOptions();
            },
          ),
        ],
      ),
      body: setUI(),
    );
  }

  setUI() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            child: getTopWear(),
          ),
          Expanded(
            child: getBottomWear(),
          )
        ],
      ),
    );
  }

  getTopWear() {
    return Builder(builder: (_) {
      return ListView.builder(
        itemCount: topCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext c, int position) {
          return Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Text("TOP WEAR : ${position + 1}"),
                SizedBox(
                  height: 20,
                ),
                IconButton(
                  icon: Icon(Icons.beenhere,
                      color: setColor(photoTopList[position].isFav)),
                  onPressed: () {
                    if (photoTopList[position].isFav == "1") {
                      photoTopList[position].isFav = "0";
                      db.updateFav(photoTopList[position]);
                    } else {
                      photoTopList[position].isFav = "1";
                      db.updateFav(photoTopList[position]);
                    }
                    refreshPhotos();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 150,
                  child: Utility.imageFromBase64String(
                      photoTopList[position].imageString),
                )
              ],
            ),
          );
        },
      );
    });
  }

  getBottomWear() {
    return Builder(builder: (_) {
      return ListView.builder(
        itemCount: bottomCount,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext c, int position) {
          return Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            elevation: 2.0,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Text("BOTTOM WEAR : ${position + 1}"),
                SizedBox(
                  height: 20,
                ),
                IconButton(
                  icon: Icon(Icons.beenhere,
                      color: setColor(photoBottomList[position].isFav)),
                  onPressed: () {
                    if (photoBottomList[position].isFav == "1") {
                      photoBottomList[position].isFav = "0";
                      db.updateFav(photoBottomList[position]);
                    } else {
                      photoBottomList[position].isFav = "1";
                      db.updateFav(photoBottomList[position]);
                    }
                    refreshPhotos();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 150,
                  child: Utility.imageFromBase64String(
                      photoBottomList[position].imageString),
                )
              ],
            ),
          );
        },
      );
    });
  }

  openGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
      String imgString = Utility.base64String(imageFile.readAsBytesSync());
      print(topWear);
      PhotoVO photo = PhotoVO(imgString, topWear, "0");
      db.save(photo);
      refreshPhotos();
    });
  }

  openCamera() async {
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      String imgString = Utility.base64String(file.readAsBytesSync());
      print(imgString);
      print(topWear);
      PhotoVO photo = PhotoVO(imgString, topWear, "0");
      db.save(photo);
      refreshPhotos();
    } else{
      print("null image");
    }
  }

  void refreshPhotos() {
    db.getList().then((img) {
      setState(() {
        if (photoTopList != null) {
          photoTopList.clear();
        }
        if (photoBottomList != null) {
          photoBottomList.clear();
        }
        photoTopList = new List();
        photoBottomList = new List();
        for (int l = 0; l < img.length; l++) {
          if (img[l].wearON == "1") {
            photoTopList.add(img[l]);
          } else {
            photoBottomList.add(img[l]);
          }
        }
        topCount = photoTopList.length;
        bottomCount = photoBottomList.length;
      });
    });
  }

  setColor(String isFav) {
    if (isFav == "1") {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  void showClickOptions() {
    showModalBottomSheet(context: context, builder: (BuildContext build){
      return SafeArea(
          child: Container(
            width: 300,
            child: Column(
              children: <Widget>[
                new ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("Gallery"),
                  onTap: (){
                    openGallery();
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                  onTap: (){
                    openCamera();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
      );
    });
  }
}
