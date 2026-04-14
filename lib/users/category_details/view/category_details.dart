import '../../../general/consts/consts.dart';
import '../../doctor_profile/view/doctor_view.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategoryDetailsView extends StatelessWidget {
  final String catName;
  const CategoryDetailsView({super.key, required this.catName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: "$catName doctors".text.make(),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('doctors')
            .where('docCategory', isEqualTo: catName)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var data = snapshot.data?.docs;

            // Check if no doctors are found
            if (data == null || data.isEmpty) {
              return const Center(
                child: Text('No doctor found'),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: data.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
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
                            width: 130,
                            color: AppColors.greenColor,
                            child: data[index]['image'] == ''
                                ? Image.asset(
                                    'assets/images/doctor.png',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    data[index]['image'].toString().trim(),
                                    height: 130,
                                    width: 130,
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
                        ),
                        const Divider(),
                        data[index]['docName']
                            .toString()
                            .text
                            .size(AppFontSize.size16)
                            .make(),
                        RatingBarIndicator(
                          rating:
                              double.parse(data[index]['docRating'].toString()),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        )
                      ],
                    ),
                  ).onTap(() {
                    Get.to(() => DoctorProfile(doc: data[index]));
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }
}
