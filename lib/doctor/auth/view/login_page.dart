import 'package:s_medi/general/consts/consts.dart';

import '../../widgets/coustom_textfield.dart';
import '../../widgets/loading_indicator.dart';
import '../controller/login_controller.dart';
import 'signup_page.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: const Color(0xfff8f8f6),
      body: Container(
        margin: const EdgeInsets.only(top: 35),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                Image.asset(
                  AppAssets.imgLogin,
                  width: context.screenHeight * .23,
                ),
                5.heightBox,
                AppString.welcome.text.size(AppFontSize.size18).bold.make(),
                8.heightBox,
                AppString.weAreExcuited.text
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
                          validator: controller.validateemail,
                          textcontroller: controller.emailController,
                          icon: const Icon(Icons.email_outlined),
                          hint: AppString.emailHint,
                        ),
                        18.heightBox,
                        CoustomTextField(
                          validator: controller.validpass,
                          textcontroller: controller.passwordController,
                          icon: const Icon(Icons.key),
                          hint: AppString.passwordHint,
                        ),
                        20.heightBox,
                        Align(
                          alignment: Alignment.centerRight,
                          child: "Forget Password ?".text.make(),
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
                                controller.loginUser(context);
                              },
                              child: controller.isLoading.value
                                  ? const LoadingIndicator()
                                  : AppString.login.text.white.make(),
                            ),
                          ),
                        ),
                        20.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppString.dontHaveAccount.text.make(),
                            8.widthBox,
                            AppString.signup.text
                                .color(AppColors.primeryColor)
                                .make()
                                .onTap(() {
                              Get.to(() => const SignupView());
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
