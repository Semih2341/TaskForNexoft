import 'package:flutter/material.dart';
import 'package:nexoft_task/Views/mymodelbottom.dart';

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
          firstnameController.text = widget.item['firstName'];
          surnameController.text = widget.item['lastName'];
          phoneNumberController.text = widget.item['phoneNumber'];

          MyModalBottom.moreModalBottomSheet(context,
              item: widget.item, isEdit: true, mainContext: context);
        },
        leading: CircleAvatar(
          child: Text(
            '${widget.index + 1}',
          ),
        ),
        title: Text(widget.item['title'] + ' ' + widget.item['lastName']),
        subtitle: Text(widget.item['phoneNumber']),
      ),
    );
  }
}
