import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nexoft_task/home.dart';
import 'package:nexoft_task/image.dart';
import 'package:nexoft_task/services.dart';
import 'package:nexoft_task/utils.dart';
import 'package:image_picker/image_picker.dart';

class MyModalBottom {
  static Widget? moreModalBottomSheet(context,
      {required mainContext, required item, required isEdit, required}) {
    final Map contact = item;
    final firstnameController = TextEditingController();
    final surnameController = TextEditingController();
    final phoneNumberController = TextEditingController();
    final photoUrl = 'photo';

    if (isEdit) {
      firstnameController.text = contact['firstName'];
      surnameController.text = contact['lastName'];
      phoneNumberController.text = contact['phoneNumber'];
    }
    // Remove the leading underscore
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // For scrollable content
      builder: (BuildContext context) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                      ),
                      Text(isEdit ? 'Edit Contact' : 'New Contact',
                          style: TextStyle(fontSize: 20)),
                      TextButton(
                          onPressed: () async {
                            if (isEdit) {
                              Navigator.pop(context);

                              final isSuccess =
                                  await ContactsService.updateToDo(
                                contact['id'],
                                {
                                  "firstName": firstnameController.text,
                                  "lastName": surnameController.text,
                                  "phoneNumber": phoneNumberController.text,
                                  "image": ContactsService.uploadImage(
                                      currentPhoto!.path),
                                },
                              );
                              if (isSuccess) {
                                showSuccessMassage(mainContext,
                                    message: 'Contact Updated successfully');
                                Navigator.pushReplacement(
                                    mainContext,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              } else {
                                showErrorMassage(mainContext,
                                    message: 'Failed to update contact');
                              }
                            } else {
                              Navigator.pop(context);
                              print(currentPhoto!.path);
                              final isSuccess = await ContactsService.addToDo(
                                {
                                  "firstName": firstnameController.text,
                                  "lastName": surnameController.text,
                                  "phoneNumber": phoneNumberController.text,
                                  "image": ContactsService.uploadImage(
                                      currentPhoto!.path),
                                },
                              );
                              if (isSuccess == true) {
                                showSuccessMassage(mainContext,
                                    message: 'Contact Added successfully');
                              } else {
                                showErrorMassage(mainContext,
                                    message: 'Failed to add contact');
                              }
                            }
                          },
                          child: Text(
                            'Done',
                            style: TextStyle(color: Colors.blue, fontSize: 20),
                          ))
                    ],
                  ),
                  isEdit ? ProfileImage() : ProfileImage(),
                  TextField(
                    controller: firstnameController,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                    ),
                  ),
                  TextField(
                    controller: surnameController,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                    ),
                  ),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                    ),
                  ),
                  if (isEdit)
                    TextButton(
                      onPressed: () async {
                        final isSuccess =
                            await ContactsService.deleteById(contact['_id']);
                        if (isSuccess) {
                          Navigator.pop(context);
                          showSuccessMassage(context,
                              message: 'Contact Deleted successfully');
                          Navigator.pushReplacement(
                              mainContext,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          showErrorMassage(context,
                              message: 'Failed to delete');
                        }
                      },
                      child: Text(
                        'Delete Contact',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                    )
                ],
              ),
            ),
          ),
        );
      },
      constraints: BoxConstraints.tightFor(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return null;
  }
}

class MapCreator {
  Map<String, Object> mapCreator(
      String title, String description, bool isCompleted) {
    return {
      "title": "",
      "description": "",
      "isCompleted": false,
    };
  }
}
