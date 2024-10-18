import 'package:s_medical_doctors/general/consts/consts.dart';

class TotalAppointmentcontroller extends GetxController {
  var docName = ''.obs;
  Future<QuerySnapshot<Map<String, dynamic>>> getAppointments() async {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where(
          'appWith',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .get();
  }
}
