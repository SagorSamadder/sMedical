import 'package:s_medi/general/consts/consts.dart';
import '../../doctor_profile/view/doctor_view.dart';

class SearchView extends StatelessWidget {
  final String searchQuery;
  const SearchView({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: "Search results".text.make(),
        elevation: 0,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('doctors').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var filteredDocs = snapshot.data!.docs.where((doc) {
              String docName = doc['docName'].toString().toLowerCase();
              return docName.contains(searchQuery.toLowerCase());
            }).toList();

            if (filteredDocs.isEmpty) {
              return Center(
                child: "No doctor found, try another name.".text.makeCentered(),
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
                itemCount: filteredDocs.length,
                itemBuilder: (BuildContext context, index) {
                  var doc = filteredDocs[index];
                  final imageUrl = (doc['image'] ?? '').toString().trim();
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => DoctorProfile(
                          doc: doc,
                        ),
                      );
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
                              width: 130,
                              color: AppColors.greenColor,
                              child: imageUrl.isEmpty
                                  ? Image.asset(
                                      'assets/images/doctor.png',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) {
                                          return child;
                                        }
                                        return Image.asset(
                                          'assets/images/doctor.png',
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        'assets/images/doctor.png',
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          const Divider(),
                          doc['docName']
                              .toString()
                              .text
                              .size(AppFontSize.size16)
                              .make(),
                          VxRating(
                            onRatingUpdate: (value) {},
                            maxRating: 5,
                            count: 5,
                            value: double.parse(doc['docRating'].toString()),
                            stepInt: true,
                          ),
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
    );
  }
}
