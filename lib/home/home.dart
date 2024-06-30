import 'package:flutter/material.dart';
import '../add_contact/add_contact.dart';
import '../edit_contact/edit_contact.dart';
import 'home_controller.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _controller.refreshContacts().then((_) {
      setState(() {});
    });
  }

  void _showDeleteConfirmationDialog(int contactId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this contact?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _controller.deleteContact(contactId).then((_) {
                  _controller.refreshContacts().then((_) {
                    setState(() {});
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "Kontak Telpon",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _controller.contacts.length,
              itemBuilder: (context, index) => Card(
                color: Colors.white,
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditContact(
                          contactId: _controller.contacts[index]['id'],
                        ),
                      ),
                    );
                    _controller.refreshContacts().then((_) {
                      setState(() {});
                    });
                  },
                  leading: _controller.contacts[index]['imagePath'] != null &&
                          _controller.contacts[index]['imagePath'].isNotEmpty
                      ? ClipOval(
                          child: Image.file(
                            File(_controller.contacts[index]['imagePath']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey.shade800,
                          ),
                        ),
                  title: Text(
                    '${_controller.contacts[index]['firstName'] ?? ''} ${_controller.contacts[index]['lastName'] ?? ''}',
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    _controller.contacts[index]['phoneNumber'],
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete,
                        color: Color.fromARGB(255, 134, 129, 129)),
                    onPressed: () => _showDeleteConfirmationDialog(
                        _controller.contacts[index]['id']),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddContact()),
          );
          _controller.refreshContacts().then((_) {
            setState(() {}); // Update the UI after adding a new contact
          });
        },
        tooltip: 'Add Contact',
        backgroundColor: const Color.fromARGB(255, 10, 113, 197),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        child: const Icon(Icons.add),
      ),
    );
  }
}
