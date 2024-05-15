// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File? currentPhoto;

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key});

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myModalBottomSheet(context);
      },
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 100,
        backgroundImage:
            _selectedImage != null ? FileImage(_selectedImage!) : null,
        child: _selectedImage != null
            ? SizedBox()
            : IconButton(
                padding: EdgeInsets.all(50),
                iconSize: 100,
                onPressed: () {
                  myModalBottomSheet(context);
                },
                icon: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  void myModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  onTap: () {
                    _pickImageFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text(
                    'Photo Library',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  onTap: () {
                    _pickImageFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    'Cancel',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
      currentPhoto = _selectedImage;
    });
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(
      () {
        _selectedImage = File(returnedImage.path);
        currentPhoto = _selectedImage;
      },
    );
  }
}
