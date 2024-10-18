import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'appointment_details.dart'; // Make sure the AppointmentDetails page is properly imported
import '../../../general/consts/consts.dart';
import '../controller/total_appointment.dart';

class TotalAppointment extends StatefulWidget {
  const TotalAppointment({super.key});

  @override
  _TotalAppointmentState createState() => _TotalAppointmentState();
}

class _TotalAppointmentState extends State<TotalAppointment> {
  var controller = Get.put(TotalAppointmentController());

  // Function to limit the characters in a string
  String _limitCharacters(String text, int maxChars) {
    if (text.length > maxChars) {
      return text.substring(0, maxChars) + '...';
    }
    return text;
  }

  // Refresh appointments when pulled down
  Future<void> refreshAppointments() async {
    await controller.getAppointments();
    setState(() {}); // Trigger rebuild to reflect the updated data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greenColor,
        title: const Text("All Appointments"),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: controller.getAppointments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching appointments"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No appointment booked"),
            );
          } else {
            var data = snapshot.data!.docs;

            return RefreshIndicator(
              onRefresh: refreshAppointments,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, index) {
                    var appointment = data[index].data() as Map<String, dynamic>;
                    String appointmentId = data[index].id;
                    String appBy = appointment['appBy'] ?? '';
                    String appName = appointment['appName'] ?? 'Unknown Name';
                    String appMobile = appointment['appMobile'] ?? 'Unknown Mobile';
                    String appMsg = appointment['appMsg'] ?? 'No Message';
                    String appDay = appointment['appDay'] ?? 'Unknown Day';
                    String appTime = appointment['appTime'] ?? 'Unknown Time';
                    String status = appointment['status'] ?? 'pending';

                    // Fetch the user's image based on the appBy ID
                    return Card(
                      elevation: 1,
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(13.w),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Display user image if available
                                      Obx(() => controller.userImage.value != ''
                                          ? Image.network(
                                              controller.userImage.value,
                                              height: 50.h,
                                              width: 50.h,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(Icons.account_circle, size: 50)),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          _limitCharacters("Appointment: $appName", 20)
                                              .text
                                              .size(13.sp)
                                              .semiBold
                                              .make(),
                                          SizedBox(width: 8.w),
                                          const Icon(
                                            Icons.verified,
                                            color: Colors.blue,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Text(_limitCharacters("Mobile: $appMobile", 20)),
                                      Text(_limitCharacters("Message: $appMsg", 20)),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(Icons.schedule, size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          _limitCharacters("$appDay - $appTime", 20)
                                              .text
                                              .color(Colors.grey[600]!)
                                              .make(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(status),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Text(
                                        status.capitalizeFirst!,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    ElevatedButton(
                                      onPressed: () async {
                                        var result = await Get.to(() => AppointmentDetails(
                                              appointment: appointment,
                                              appointmentId: appointmentId, // Pass the appointmentId
                                            ));

                                        // Reload appointments if the status was updated
                                        if (result == 'updated') {
                                          refreshAppointments();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                      ),
                                      child: const Text(
                                        "View Details",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Method to get the color based on status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accept':
        return Colors.green;
      case 'reject':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'complete':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
