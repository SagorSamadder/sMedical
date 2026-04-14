import 'package:shimmer/shimmer.dart';
import 'package:s_medi/general/consts/consts.dart';

import '../../../general/list/home_icon_list.dart';
import '../../category_details/view/category_details.dart';
import '../../doctor_profile/view/doctor_view.dart';
import '../../search/controller/search_controller.dart';
import '../../search/view/search_view.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final searchController = Get.put(DocSearchController());

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            _buildTopBanner(controller, searchController),
            const SizedBox(height: 16),
            _buildSectionTitle('Popular Category'),
            const SizedBox(height: 10),
            _buildCategoryList(),
            const SizedBox(height: 20),
            _buildSectionTitle('Popular Doctors'),
            const SizedBox(height: 10),
            _buildDoctors(controller),
            const SizedBox(height: 20),
            _buildSectionTitle('Make Reports'),
            const SizedBox(height: 10),
            _buildReports(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBanner(
    HomeController controller,
    DocSearchController searchController,
  ) {
    return Container(
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F2A1A6F),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(Icons.waving_hand_rounded, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () => RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: '${AppString.welcome}\n',
                      style: const TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: controller.userName.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController.searchQueryController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Search doctor',
                      prefixIcon: Icon(Icons.search_rounded),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    ),
                    onFieldSubmitted: (_) => _submitSearch(
                        searchController.searchQueryController.text),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () => _submitSearch(
                      searchController.searchQueryController.text),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primeryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                  child: const Icon(Icons.search_rounded, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: AppColors.primeryColor,
            fontSize: AppFontSize.size18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 118,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: iconListTitle.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(() => CategoryDetailsView(catName: iconListTitle[index]));
            },
            child: Container(
              width: 110,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    AppColors.greenColor.withValues(alpha: .22),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.greenColor.withValues(alpha: .42),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconList[index], width: 44),
                  const SizedBox(height: 8),
                  Text(
                    iconListTitle[index],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textcolor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppFontSize.size12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctors(HomeController controller) {
    return FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
      future: controller.getDoctorList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 220,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 155,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                );
              },
            ),
          );
        }

        final data = snapshot.data!;
        return SizedBox(
          height: 220,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doctorData = data[index].data();
              final imageUrl = (doctorData['image'] ?? '').toString();
              final docName = (doctorData['docName'] ?? 'Unknown').toString();
              final docCategory =
                  (doctorData['docCategory'] ?? 'Unknown').toString();

              return GestureDetector(
                onTap: () {
                  Get.to(() => DoctorProfile(doc: data[index]));
                },
                child: Container(
                  width: 155,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: imageUrl.isEmpty
                            ? Image.asset(
                                'assets/images/doctor.png',
                                height: 135,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                imageUrl.trim(),
                                height: 135,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) {
                                    return child;
                                  }
                                  return Image.asset(
                                    'assets/images/doctor.png',
                                    height: 135,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/doctor.png',
                                  height: 135,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                        child: Text(
                          docName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primeryColor.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            docCategory,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.primeryColor,
                              fontSize: AppFontSize.size12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReports(BuildContext context) {
    final items = [
      ('Lab Test', AppAssets.icBody, const Color(0xffE9F9E0)),
      ('Xray Report', AppAssets.icBody, const Color(0xffE4F2FF)),
      ('MRI Report', AppAssets.icBody, const Color(0xffF2ECFF)),
      ('Others', AppAssets.icBody, const Color(0xffFFF1E8)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: items.map((item) {
          final width = (context.screenWidth - 34) / 2;
          return Container(
            width: width,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: item.$3,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white),
            ),
            child: Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Image.asset(item.$2, width: 28),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) {
      Get.showSnackbar(
        const GetSnackBar(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          title: 'Empty input',
          message: 'Please input something first',
          animationDuration: Duration(milliseconds: 600),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black87,
          dismissDirection: DismissDirection.horizontal,
          duration: Duration(seconds: 2),
          borderRadius: 10,
        ),
      );
      return;
    }

    Get.to(() => SearchView(searchQuery: query.trim()));
  }
}
