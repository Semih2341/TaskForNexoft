import 'package:flutter/material.dart';
import 'package:nexoft_task/Views/home.dart';
import 'package:nexoft_task/photopicker.dart';
import 'package:nexoft_task/Services/services.dart';
import 'package:nexoft_task/Utils/snackbarhelper.dart';

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
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
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                      Text(
                        isEdit ? 'Edit Contact' : 'New Contact',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
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
                                        builder: (context) =>
                                            const HomeScreen()));
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
                          child: const Text(
                            'Done',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 16,
                                color: Colors.blue),
                          ))
                    ],
                  ),
                  isEdit ? const ProfileImage() : const ProfileImage(),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.black),
                    controller: firstnameController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.black),
                    controller: surnameController,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                  ),
                  TextField(
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.black),
                    controller: phoneNumberController,
                    decoration: const InputDecoration(
                      hintText: 'Phone Number',
                    ),
                  ),
                  if (isEdit)
                    TextButton(
                      onPressed: () async {
                        final isSuccess =
                            await ContactsService.deleteById(contact['id=']);
                        if (isSuccess) {
                          Navigator.pop(context);
                          showSuccessMassage(context,
                              message: 'Contact Deleted successfully');
                          Navigator.pushReplacement(
                              mainContext,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        } else {
                          showErrorMassage(context,
                              message: 'Failed to delete');
                        }
                      },
                      child: const Text(
                        'Delete Contact',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 16,
                            color: Colors.red),
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
