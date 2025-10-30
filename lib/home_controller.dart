import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomeController extends GetxController  with GetTickerProviderStateMixin{
  late TabController tabController;
  final RxString  dataId = "".obs;
  final RxBool  isUpdateData = false.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}