
import '../database/data_helper.dart';

class HomeController {
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get contacts => _contacts;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
  }

  Future<void> refreshContacts() async {
    final data = await SqlHelpers.getContacts();
    _contacts = data;
    _isLoading = false;
  }

  Future<void> deleteContact(int id) async {
    await SqlHelpers.deleteContact(id);
  }
}
