// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nexoft_task/Views/Cards.dart';
import 'package:nexoft_task/Views/mymodelbottom.dart';
import 'package:nexoft_task/Services/services.dart';
import 'package:nexoft_task/Utils/snackbarhelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isEdit = false;
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Contacts',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                    IconButton(
                      onPressed: () {
                        //pop menu açılcak
                        MyModalBottom.moreModalBottomSheet(
                          context,
                          isEdit: false,
                          item: {},
                          mainContext: context,
                        );
                      },
                      icon: const Icon(Icons.add_circle_rounded),
                      color: Colors.blue,
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Çerçeve rengi
                    borderRadius:
                        BorderRadius.circular(10), // Köşe yuvarlaklığı
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder
                          .none, // TextField'in kendi çerçevesini kaldırma
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
            child: Visibility(
              visible: isLoading,
              replacement: RefreshIndicator(
                onRefresh: fetchContacts,
                child: Visibility(
                  visible: items.isNotEmpty,
                  replacement: Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 30,
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'No Contacts',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24),
                        ),
                        const Text(
                          'Contacts you’ve added will appear here.',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.black,
                              fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            MyModalBottom.moreModalBottomSheet(
                              context,
                              isEdit: false,
                              item: {},
                              mainContext: context,
                            );
                          },
                          child: const Text(
                            'Add Contacts',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                color: Colors.blue,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final item = items[index] as Map;
                      return Contacts(
                        index: index,
                        item: item,
                      );
                    },
                  ),
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchContacts() async {
    final response = await ContactsService.fetchContacts();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMassage(context, message: 'Failed to fetch todo');
    }
    setState(() {
      isLoading = false;
    });
  }
}
