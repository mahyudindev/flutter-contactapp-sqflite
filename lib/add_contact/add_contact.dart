import 'package:flutter/material.dart';
import 'dart:io';
import 'add_contact_controller.dart';

class AddContact extends StatefulWidget {
  AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final controller = AddContactController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "Tambah Kontak",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      await controller.pickImage();
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: controller.imagePath != null
                          ? FileImage(File(controller.imagePath!))
                          : null,
                      child: controller.imagePath == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.grey.shade800,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Input Fields
                Column(
                  children: [
                    // Nama Depan
                    TextFormField(
                      controller: controller.firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Depan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama depan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nama Belakang
                    TextFormField(
                      controller: controller.lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Belakang',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nomor HP
                    TextFormField(
                      controller: controller.phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor HP',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor HP tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Masukkan email yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Alamat
                    TextFormField(
                      controller: controller.addressController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),

                // Tombol Simpan
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: ElevatedButton(
                      onPressed: () => controller.saveContact(context),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 18, 109, 184),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
