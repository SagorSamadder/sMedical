import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:s_medi/general/consts/colors.dart';
import 'package:s_medi/general/list/home_icon_list.dart';
import 'package:s_medi/general/consts/vx_compat.dart';
import '../../category_details/view/category_details.dart';

class CategoryScreenn extends StatefulWidget {
  const CategoryScreenn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoryScreennState createState() => _CategoryScreennState();
}

class _CategoryScreennState extends State<CategoryScreenn> {
  // Create a map to hold doctor counts for each category
  Map<String, int> categoryDoctorCount = {};

  @override
  void initState() {
    super.initState();
    fetchDoctorCounts();
  }

  // Function to fetch the number of doctors in each category from Firestore
  Future<void> fetchDoctorCounts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Loop through each category and fetch the count of doctors
    for (String category in categoryTitle) {
      QuerySnapshot querySnapshot = await firestore
          .collection('doctors')
          .where('docCategory', isEqualTo: category)
          .get();

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          categoryDoctorCount[category] = querySnapshot.size;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: "Total Category".text.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: categoryImage.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 2,
            mainAxisExtent: 200,
          ),
          itemBuilder: (BuildContext context, int index) {
            String category = categoryTitle[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => CategoryDetailsView(
                      catName: category,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.bgColor,
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Image.asset(
                      categoryImage[index],
                      width: 110,
                    ),
                    const Divider(),
                    category.text.size(18).make(),
                    Text(
                        "${categoryDoctorCount[category]?.toString() ?? ""} Specialists")
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
