import 'package:ecommerce_app/event/event_pref.dart';
import 'package:ecommerce_app/model/user.dart';
import 'package:get/get.dart';

class CUser extends GetxController {
  Rx<User> _user = User(0, '', '', '').obs;

  get user => _user.value;
  setUser(User? newUser) => _user.value = newUser!;

  void _getUser() async {
    User? user = await EventPref.getUser();
    _user.value = user!;
  }

  @override
  void onInit() {
    _getUser();
    super.onInit();
  }
}
