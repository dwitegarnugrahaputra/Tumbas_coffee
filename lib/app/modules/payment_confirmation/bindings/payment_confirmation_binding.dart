import 'package:get/get.dart';

import '../controllers/payment_confirmation_controller.dart';

class PaymentConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentConfirmationController>(
      () => PaymentConfirmationController(),
    );
  }
}
