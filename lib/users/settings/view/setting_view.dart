import 'package:image_picker/image_picker.dart';
import 'package:s_medi/general/consts/consts.dart';

import '../../../auth/auth/controller/signup_controller.dart';
import 'about_us.dart';
import 'terms_condition.dart';
import '../controller/profile_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(
            color: AppColors.primeryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primeryColor,
                            const Color(0xff2A1A6F),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F2A1A6F),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 130,
                                width: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
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
                                        loadingBuilder:
                                            (context, child, progress) {
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
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    _showImagePickerBottomSheet(
                                      context,
                                      controller,
                                    );
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.greenColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            controller.username.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.email.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xE6FFFFFF),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      icon: Icons.shield_outlined,
                      title: 'Terms & Conditions',
                      subtitle: 'Learn about app policies and rules',
                      onTap: () async {
                        Get.to(() => const TermsCondition());
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildInfoTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About Us',
                      subtitle: 'Platform, developer and contact details',
                      onTap: () async {
                        Get.to(() => const AboutUs());
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildInfoTile(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: 'Sign out from your account',
                      onTap: () async {
                        await SignupController().signout();
                      },
                      isDanger: true,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Future<void> Function() onTap,
    bool isDanger = false,
  }) {
    final accentColor = isDanger ? Colors.red : AppColors.primeryColor;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        await onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: accentColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: accentColor,
            ),
          ],
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
