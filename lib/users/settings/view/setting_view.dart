import 'package:image_picker/image_picker.dart';
import 'package:s_medi/general/consts/consts.dart';
import 'package:s_medi/users/widgets/coustom_iconbutton.dart';

import '../../../auth/auth/controller/signup_controller.dart';
import '../controller/profile_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: controller.profileImageUrl.value.isEmpty
                                ? Image.asset(
                                    'assets/images/doctor.png',
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    controller.profileImageUrl.value.trim(),
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Image.asset(
                                        'assets/images/doctor.png',
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      'assets/images/doctor.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  _showImagePickerBottomSheet(
                                      context, controller);
                                },
                                icon: const Icon(
                                  Icons.upload,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(controller.username.value),
                        ),
                      ),
                      10.heightBox,
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(controller.email.value),
                        ),
                      ),
                      20.heightBox,
                      const Divider(),
                      10.heightBox,
                      CoustomIconButton(
                        color: Colors.black.withValues(alpha: .4),
                        onTap: () {},
                        title: "Terms & Condition",
                        icon: const Icon(
                          Icons.edit_document,
                          color: Colors.white,
                        ),
                      ),
                      10.heightBox,
                      CoustomIconButton(
                        color: Colors.red,
                        onTap: () async {
                          await SignupController().signout();
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

  void _showImagePickerBottomSheet(
      BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              await controller.pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              await controller.pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
