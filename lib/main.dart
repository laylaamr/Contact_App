import 'package:flutter/material.dart';
import 'package:phone_app/editPhone.dart';
import 'package:phone_app/phoneDetails.dart';
import 'package:phone_app/phoneProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialization
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PhoneProvider phoneProvider;

  @override
  void initState() {
    phoneProvider = PhoneProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "My Contacts",
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          TextEditingController nameController = TextEditingController();
          TextEditingController numberController = TextEditingController();
          TextEditingController coverController = TextEditingController();
          GlobalKey<FormState> formKey = GlobalKey<FormState>();

          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(20).copyWith(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
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
                        SizedBox(height: 40),
                        TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              PhoneDetails phoneDetails = PhoneDetails(
                                id: null, // or auto-generate an ID if needed
                                name: nameController.text.trim(),
                                number: numberController.text.trim(),
                                cover: coverController.text.trim(),
                              );
                              await phoneProvider.insertIntoDatabase(phoneDetails).then((value) {
                                Navigator.of(context).pop();
                                setState(() {});
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            "Add",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add, size: 30),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: phoneProvider.getDtaFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: TextStyle(fontSize: 25, color: Colors.red),
              ),
            );
          }

          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data != null && data.isNotEmpty) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  PhoneDetails phoneDetails = PhoneDetails.fromMap(data[index]);
                  return Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditPhone(phoneDetails: phoneDetails,)),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            CircleAvatar(
                              backgroundImage: NetworkImage(phoneDetails.cover),
                              radius: 40,
                            ),
                            Text(
                              phoneDetails.name,
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                            ),
                            Text(
                              phoneDetails.number,
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "There is no data",
                  style: TextStyle(fontSize: 25, color: Colors.red),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                "No data available",
                style: TextStyle(fontSize: 25, color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}

