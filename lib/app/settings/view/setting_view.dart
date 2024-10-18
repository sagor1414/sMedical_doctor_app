import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:s_medical_doctors/general/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controller/signup_controller.dart';
import '../../auth/view/login_page.dart';
import '../../widgets/coustom_iconbutton.dart';
import '../controller/profile_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    var controler = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Obx(
        () => controler.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Padding(
                  padding:  EdgeInsets.all(8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAssets.imgLogin,
                        width: 200.w,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: 'Username: ', // Static label text
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: controler.username.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: 10.h),
                      Padding(
                        padding:  EdgeInsets.only(left: 20.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: 'Email: ', // Static label text
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: controler.email.value,
                                  style:  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                       SizedBox(height: 20.sp),
                      const Divider(),
                       SizedBox(height: 10.sp),
                      CoustomIconButton(
                        color: AppColors.redcolor,
                        onTap: () {
                          SignupController().signout();
                          Get.offAll(() => const LoginView());
                        },
                        title: "Logout",
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
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
