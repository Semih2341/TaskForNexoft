import 'package:flutter/material.dart';
import 'package:nexoft_task/deneme.dart';

class Contacts extends StatefulWidget {
  final int index;
  final Map item;

  const Contacts({
    super.key,
    required this.index,
    required this.item,
  });

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final firstnameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          print(widget.item['title']);
          firstnameController.text = widget.item['title'];
          surnameController.text = widget.item['description'];

          //phoneNumberController.text = widget.item['phoneNumber'];
          MyModalBottom.moreModalBottomSheet(context,
              item: widget.item, isEdit: true, mainContext: context);
        },
        leading: CircleAvatar(
          child: Text(
            '${widget.index + 1}',
          ),
        ),
        title: Text(widget.item['title']),
        subtitle: Text(widget.item['description']),
      ),
    );
  }
}
