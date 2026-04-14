import 'package:s_medi/general/consts/consts.dart';

class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({super.key});

  Future<List<Map<String, dynamic>>> _getReviewsWithUserData() async {
    // Reference to doctor's reviews collection
    CollectionReference reviewsCollection = FirebaseFirestore.instance
        .collection('doctors')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('reviews');

    // Fetch all reviews for the doctor
    QuerySnapshot reviewsSnapshot = await reviewsCollection.get();
    List<Map<String, dynamic>> reviewsWithUserData = [];

    for (var reviewDoc in reviewsSnapshot.docs) {
      Map<String, dynamic> reviewData =
          reviewDoc.data() as Map<String, dynamic>;

      // Fetch reviewer's details from the 'users' collection using reviewBy id
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(reviewData['reviewBy'])
          .get();

      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Combine review and user data into one map
      reviewsWithUserData.add({
        'review': reviewData,
        'user': userData,
      });
    }
    return reviewsWithUserData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Reviews"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getReviewsWithUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading reviews"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reviews available"));
          }

          List<Map<String, dynamic>> reviews = snapshot.data!;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var review = reviews[index]['review'];
              var user = reviews[index]['user'];
              final userImage = (user['image'] ?? '').toString();

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: userImage.isEmpty
                            ? Image.asset(
                                'assets/images/doctor.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                userImage.trim(),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Image.asset(
                                    'assets/images/doctor.png',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/doctor.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    title: Text(
                      "Reviewer :${user['fullname']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      review['comment'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        Text(
                          review['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  child: ClipOval(
                                    child: userImage.isEmpty
                                        ? Image.asset(
                                            'assets/images/doctor.png',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            userImage.trim(),
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, progress) {
                                              if (progress == null) {
                                                return child;
                                              }
                                              return Image.asset(
                                                'assets/images/doctor.png',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
                                              'assets/images/doctor.png',
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(user['fullname']),
                                ),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Behavior: ${review['behavior']}"),
                                const SizedBox(height: 8),
                                Text("Comment: ${review['comment']}"),
                                const SizedBox(height: 8),
                                Text("Rating: ${review['rating']}"),
                                const SizedBox(height: 8),
                                Text("Reviewed by: ${user['fullname']}"),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
