import 'package:s_medi/general/consts/consts.dart';
import 'package:s_medi/doctor/home/view/doctor_home.dart';

import '../../../users/home/view/home.dart';
import '../../../users/widgets/coustom_textfield.dart';
import '../../../users/widgets/loading_indicator.dart';
import '../controller/signup_controller.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SignupController());
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 35),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                Image.asset(
                  AppAssets.imgWelcome,
                  width: context.screenHeight * .23,
                ),
                8.heightBox,
                AppString.signupNow.text
                    .size(AppFontSize.size18)
                    .semiBold
                    .make()
              ],
            ),
            15.heightBox,
            Expanded(
              flex: 2,
              child: Form(
                  key: controller.formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CoustomTextField(
                          textcontroller: controller.nameController,
                          hint: AppString.fullName,
                          icon: const Icon(Icons.person),
                          validator: controller.validname,
                        ),
                        15.heightBox,
                        CoustomTextField(
                          textcontroller: controller.emailController,
                          icon: const Icon(Icons.email_outlined),
                          hint: AppString.emailHint,
                          validator: controller.validateemail,
                        ),
                        15.heightBox,
                        CoustomTextField(
                          textcontroller: controller.passwordController,
                          icon: const Icon(Icons.key),
                          hint: AppString.passwordHint,
                          validator: controller.validpass,
                        ),
                        15.heightBox,
                        Obx(
                          () => DropdownButtonFormField<String>(
                            initialValue: controller.selectedRole.value,
                            decoration: const InputDecoration(
                              labelText: 'Register as',
                              prefixIcon: Icon(Icons.badge_outlined),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'user',
                                child: Text('User'),
                              ),
                              DropdownMenuItem(
                                value: 'doctor',
                                child: Text('Doctor'),
                              ),
                            ],
                            onChanged: controller.setRole,
                          ),
                        ),
                        15.heightBox,
                        Obx(
                          () => controller.selectedRole.value == 'doctor'
                              ? Column(
                                  children: [
                                    CoustomTextField(
                                      textcontroller:
                                          controller.phoneController,
                                      icon: const Icon(Icons.phone),
                                      hint: 'Enter your phone number',
                                      validator: controller.validfield,
                                    ),
                                    15.heightBox,
                                    GestureDetector(
                                      onTapDown: (details) {
                                        controller.showDropdownMenu(context);
                                      },
                                      child: TextFormField(
                                        controller:
                                            controller.categoryController,
                                        readOnly: true,
                                        validator: controller.validfield,
                                        onTap: () {
                                          controller.showDropdownMenu(context);
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Select Category',
                                          prefixIcon: Icon(Icons.more_vert),
                                          suffixIcon:
                                              Icon(Icons.arrow_drop_down),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    15.heightBox,
                                    CoustomTextField(
                                      textcontroller: controller.timeController,
                                      icon: const Icon(Icons.timer),
                                      hint: 'write your servise time',
                                      validator: controller.validfield,
                                    ),
                                    15.heightBox,
                                    CoustomTextField(
                                      textcontroller:
                                          controller.aboutController,
                                      icon: const Icon(Icons.person_rounded),
                                      hint: 'write some thing yourself',
                                      validator: controller.validfield,
                                    ),
                                    15.heightBox,
                                    CoustomTextField(
                                      textcontroller:
                                          controller.addressController,
                                      icon: const Icon(Icons.home_rounded),
                                      hint: 'write your address',
                                      validator: controller.validfield,
                                    ),
                                    15.heightBox,
                                    CoustomTextField(
                                      textcontroller:
                                          controller.serviceController,
                                      icon: const Icon(Icons.type_specimen),
                                      hint:
                                          'write some thing about your service',
                                      validator: controller.validfield,
                                    ),
                                    5.heightBox,
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        20.heightBox,
                        SizedBox(
                          width: context.screenWidth * .7,
                          height: 44,
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primeryColor,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () async {
                                await controller.signupUser(context);
                                if (controller.userCredential != null) {
                                  if (controller.selectedRole.value ==
                                      'doctor') {
                                    Get.offAll(() => const DoctorHome());
                                  } else {
                                    Get.offAll(() => const Home());
                                  }
                                }
                              },
                              child: controller.isLoading.value
                                  ? const LoadingIndicator()
                                  : AppString.signup.text.white.make(),
                            ),
                          ),
                        ),
                        20.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppString.alreadyHaveAccount.text.make(),
                            8.widthBox,
                            AppString.login.text.make().onTap(() {
                              Get.back();
                            }),
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
