import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/data_helper.dart';

class EditContactController {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  String? imagePath;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imagePath = pickedFile.path;
    }
  }

  Future<void> loadContact(int id) async {
    final contact = await SqlHelpers.getContact(id);
    if (contact.isNotEmpty) {
      final data = contact.first;
      firstNameController.text = data['firstName'];
      lastNameController.text = data['lastName'];
      phoneNumberController.text = data['phoneNumber'];
      emailController.text = data['email'];
      addressController.text = data['address'];
      imagePath = data['imagePath'];
    }
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
  }

  Future<void> saveContact(BuildContext context, int id) async {
    if (formKey.currentState!.validate()) {
      await SqlHelpers.updateContact(
        id,
        firstNameController.text,
        lastNameController.text,
        phoneNumberController.text,
        emailController.text,
        addressController.text,
        imagePath ?? '',
      );

      Navigator.pop(context);
    }
  }
}

