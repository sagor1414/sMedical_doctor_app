import 'package:s_medical_doctors/general/consts/consts.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getData = getUserData();
  }

  var isLoading = false.obs;
  var currentUser = FirebaseAuth.instance.currentUser;
  var username = ''.obs;
  var email = ''.obs;
  Future? getData;

  getUserData() async {
    if (currentUser == null) {
      print("No user is currently logged in");
      return; // No user, return early
    }

    try {
      isLoading(true);

      // Fetch user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
          .instance
          .collection('doctors')
          .doc(currentUser!.uid)
          .get();

      // Ensure user data exists
      var userData = user.data();
      if (userData != null) {
        username.value = userData['docName'] ?? "Unknown";
        email.value = currentUser!.email ?? "No email available";
      } else {
        print("No user data found in Firestore");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      isLoading(false);
    }
  }
}
