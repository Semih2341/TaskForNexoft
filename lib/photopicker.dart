// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_image/universal_image.dart';
import 'dart:convert';

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
        MyModalBottomSheet(context);
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
                  MyModalBottomSheet(context);
                },
                icon: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  void MyModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _pickImageFromGallery();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop();
                },
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
