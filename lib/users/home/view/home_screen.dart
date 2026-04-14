import 'package:s_medi/general/consts/consts.dart';

import '../../../general/list/home_icon_list.dart';
import '../../category_details/view/category_details.dart';
import '../../doctor_profile/view/doctor_view.dart';
import '../../search/controller/search_controller.dart';
import '../../search/view/search_view.dart';
import '../controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var searchcontroller = Get.put(DocSearchController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: Row(
          children: [
            AppString.welcome.text.make(),
            5.widthBox,
            Expanded(
              child: Obx(
                () => Text(
                  "${controller.userName}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            )
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //search section
            Container(
              padding: const EdgeInsets.all(8),
              height: 70,
              color: AppColors.whiteColor,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchcontroller.searchQueryController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.primeryColor, width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: AppColors.primeryColor, width: 2.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2.0),
                        ),
                        hintText: "Search doctor",
                      ),
                      style: TextStyle(color: AppColors.primeryColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  10.widthBox,
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primeryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (searchcontroller
                            .searchQueryController.text.isNotEmpty) {
                          Get.to(
                            () => SearchView(
                              searchQuery:
                                  searchcontroller.searchQueryController.text,
                            ),
                          );
                        } else {
                          Get.showSnackbar(
                            const GetSnackBar(
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              title: "Empry input",
                              message: "Please input someting first",
                              animationDuration: Duration(seconds: 1),
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.grey,
                              dismissDirection: DismissDirection.horizontal,
                              duration: Duration(seconds: 2),
                              borderRadius: 10,
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        color: AppColors.whiteColor,
                        size: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
            4.heightBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: "Populer Category"
                        .text
                        .color(AppColors.primeryColor)
                        .size(AppFontSize.size16)
                        .make(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => CategoryDetailsView(
                                catName: iconListTitle[index],
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Image.asset(
                                  iconList[index],
                                  width: 50,
                                ),
                                5.heightBox,
                                iconListTitle[index].text.make()
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  15.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: "Populer Doctors"
                        .text
                        .color(AppColors.primeryColor)
                        .size(AppFontSize.size16)
                        .make(),
                  ),
                  10.heightBox,
                  FutureBuilder<
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                    future: controller.getDoctorList(),
                    builder: (BuildContext context,
                        AsyncSnapshot<
                                List<
                                    QueryDocumentSnapshot<
                                        Map<String, dynamic>>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        // Use a shimmer effect while loading
                        return SizedBox(
                          height: 195,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 5, // Number of shimmer items
                            itemBuilder: (BuildContext context, int index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  margin: const EdgeInsets.only(right: 8),
                                  height: 120,
                                  width: 130,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          height: 130,
                                          width: double.infinity,
                                          color: Colors.grey[
                                              300], // Shimmer effect for the image
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 16,
                                        width: 100,
                                        color: Colors.grey[
                                            300], // Shimmer effect for the text
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        height: 12,
                                        width: 60,
                                        color: Colors.grey[
                                            300], // Shimmer effect for category
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        var data = snapshot.data;
                        return SizedBox(
                          height: 195,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: data?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              final doctorData = data![index].data();
                              final imageUrl =
                                  (doctorData['image'] ?? '').toString();
                              final docName =
                                  (doctorData['docName'] ?? 'Unknown')
                                      .toString();
                              final docCategory =
                                  (doctorData['docCategory'] ?? 'Unknown')
                                      .toString();

                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => DoctorProfile(
                                        doc: data[index],
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.bgDarkColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.only(bottom: 5),
                                  margin: const EdgeInsets.only(right: 8),
                                  height: 120,
                                  width: 130,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Container(
                                          child: imageUrl.isEmpty
                                              ? Image.asset(
                                                  'assets/images/doctor.png',
                                                  height: 130,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  imageUrl.trim(),
                                                  height: 130,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, progress) {
                                                    if (progress == null) {
                                                      return child;
                                                    }
                                                    return Image.asset(
                                                      'assets/images/doctor.png',
                                                      height: 130,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Image.asset(
                                                    'assets/images/doctor.png',
                                                    height: 130,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          docName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      docCategory.text
                                          .size(AppFontSize.size12)
                                          .make(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  20.heightBox,
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Make Reports",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primeryColor,
                        ),
                      ),
                    ),
                  ),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: .4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 110,
                        child: Column(
                          children: [
                            Image.asset(
                              AppAssets.icBody,
                              width: context.screenWidth * .16,
                            ),
                            5.heightBox,
                            "lab test".text.make()
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 110,
                        child: Column(
                          children: [
                            Image.asset(
                              AppAssets.icBody,
                              width: context.screenWidth * .16,
                            ),
                            5.heightBox,
                            "Xry report".text.make()
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 110,
                        child: Column(
                          children: [
                            Image.asset(
                              AppAssets.icBody,
                              width: context.screenWidth * .16,
                            ),
                            5.heightBox,
                            "Mri report".text.make()
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 110,
                        child: Column(
                          children: [
                            Image.asset(
                              AppAssets.icBody,
                              width: context.screenWidth * .16,
                            ),
                            5.heightBox,
                            "Others".text.make()
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
