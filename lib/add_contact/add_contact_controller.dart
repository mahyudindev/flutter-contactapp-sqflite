import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../database/data_helper.dart';

class AddContactController {
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

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
  }

  Future<void> saveContact(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      await SqlHelpers.createContact(
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
