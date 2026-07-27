import 'package:get/get.dart';

class HomeController extends GetxController {
  var userName = 'Tegar!'.obs;
  var userLocation = 'Jl. Sudirman No. 42, Jakarta'.obs;
  var selectedCategory = 0.obs;

  void selectCategory(int index) {
    selectedCategory.value = index;
  }
}