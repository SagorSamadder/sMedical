import 'package:s_medi/general/consts/consts.dart';

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
                                  Get.offAll(() => const Home());
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
