import 'package:s_medical_doctors/app/auth/view/login_page.dart';
import 'appointment_details.dart';
import '../../../general/consts/consts.dart';
import '../controller/total_appointment.dart';

class TotalAppointment extends StatelessWidget {
  const TotalAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TotalAppointmentcontroller());
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Get.offAll(() => const LoginView());
      }),
      appBar: AppBar(
        backgroundColor: AppColors.greenColor,
        title: "All Appointments".text.make(),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: controller.getAppointments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: "Error fetching appointments".text.make(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: "No appointment booked".text.make(),
            );
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, index) {
                  var appointment = data[index].data() as Map<String, dynamic>;

                  return ListTile(
                    onTap: () {
                      // Navigate to the AppointmentDetails page and pass the appointment data
                      Get.to(
                          () => AppointmentDetails(appointment: appointment));
                    },
                    leading: CircleAvatar(
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.imgDoctor,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    title: appointment['appDocName']
                        .toString()
                        .text
                        .semiBold
                        .make(),
                    subtitle:
                        "${appointment['appDay']} - ${appointment['appTime']}"
                            .toString()
                            .text
                            .make(),
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
