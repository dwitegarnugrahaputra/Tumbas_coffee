// Lokasi: lib/app/modules/main/bindings/main_binding.dart

import 'package:get/get.dart'; // Typo package0 sudah diperbaiki jadi package
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../../history/controllers/history_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<OrderController>(() => OrderController());
    Get.lazyPut<HistoryController>(() => HistoryController());

    // Inisialisasi awal ProfileController agar siap dipakai di MainView/ProfileView
    Get.put<ProfileController>(ProfileController());
  }
}