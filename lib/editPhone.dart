import 'package:flutter/material.dart';
import 'package:phone_app/phoneDetails.dart';
import 'package:phone_app/phoneProvider.dart';

import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyHomePage())); // Run the MyHomePage as the initial screen
}

class EditPhone extends StatefulWidget {
  final PhoneDetails phoneDetails;

  const EditPhone({Key? key, required this.phoneDetails}) : super(key: key);

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController coverController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.phoneDetails.name);
    numberController = TextEditingController(text: widget.phoneDetails.number);
    coverController = TextEditingController(text: widget.phoneDetails.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Contact Details",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 30),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.phoneDetails.cover),
                radius: 120,
              ),
              Form(
                key: formKey,
                child: Column(children: [
                  TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name can\'t be null';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Contact Name"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: numberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Number can\'t be null';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Contact Number"),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: coverController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cover can\'t be null';
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Contact Cover"),
                  ),
                  SizedBox(height: 30),
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                'Edit contact',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                            content: Text(
                                'Are you sure you want to save this contact?',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                    'No',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                onPressed: () async {
                                  var updatedContact = PhoneDetails(
                                    id: widget.phoneDetails.id,
                                    name: nameController.text,
                                    number: numberController.text,
                                    cover: coverController.text,
                                  );

                                  await PhoneProvider().contactUpdate(updatedContact);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                                          (route) => false);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                'Delete Contact',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                            ),
                            content: Text(
                                'Are you sure you want to delete this contact?',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  'Yes',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),
                                ),
                                onPressed: () async {
                                  await PhoneProvider().deleteFromDatabase(widget.phoneDetails.id!);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) => const MyHomePage()),
                                          (route) => false);
                                  setState(() {
                                    // Refresh the UI
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.blue, fontSize: 25),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


