import 'package:flutter/material.dart';
import 'package:nexoft_task/Cards.dart';
import 'package:nexoft_task/mymodelbottom.dart';
import 'package:nexoft_task/services.dart';
import 'package:nexoft_task/snackbarhelper.dart';

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
    print('buda olur');
    // TODO: implement initState
    super.initState();
    fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Contacts'),
                  IconButton(
                      onPressed: () {
                        //pop menu açılcak
                        MyModalBottom.moreModalBottomSheet(
                          context,
                          isEdit: false,
                          item: Map(),
                          mainContext: context,
                        );
                      },
                      icon: Icon(Icons.add))
                ],
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Visibility(
              visible: isLoading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
              replacement: RefreshIndicator(
                onRefresh: fetchContacts,
                child: Visibility(
                  visible: items.isNotEmpty,
                  replacement: Center(
                    child: Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 30,
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'No Contacts',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          ),
                          Text('Contacts you’ve added will appear here.'),
                          TextButton(
                            onPressed: () {
                              MyModalBottom.moreModalBottomSheet(
                                context,
                                isEdit: false,
                                item: Map(),
                                mainContext: context,
                              );
                            },
                            child: Text('Add Contacts'),
                          ),
                        ],
                      ),
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
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchContacts() async {
    final response = await ContactsService.fetchContacts();
    print(response);
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
