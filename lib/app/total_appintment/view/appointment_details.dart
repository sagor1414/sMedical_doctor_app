import '../../../general/consts/consts.dart';

class AppointmentDetails extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetails({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenColor,
        title: Text("Appointment Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Doctor Name: ${appointment['appDocName']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Appointment with: ${appointment['appName']}"),
            Text("Mobile: ${appointment['appMobile']}"),
            Text("Message: ${appointment['appMsg']}"),
            Text("Day: ${appointment['appDay']}"),
            Text("Time: ${appointment['appTime']}"),
            Text("Doctor Number: ${appointment['appDocNum']}"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
