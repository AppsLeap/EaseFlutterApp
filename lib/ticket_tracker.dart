import 'package:flutter/material.dart';

class TicketTrackerScreen extends StatelessWidget {
  final String ticketNumber;
  final String name;
  final String mobile;
  final String date;
  final String repairType;

  const TicketTrackerScreen({
    Key? key,
    required this.ticketNumber,
    required this.name,
    required this.mobile,
    required this.date,
    required this.repairType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          ticketNumber,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.laptop, size: 40, color: Colors.black),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name - $mobile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      repairType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  buildStep(1, "Ticket Entered", "18 Jan 2025 at 12:17 pm"),
                  buildStep(2, "Ticket Assigned", "18 Jan 2025 at 2:30 pm",
                      showClickToView: true),
                  buildStep(
                      3,
                      "Ticket Assigned and has been updated",
                      "18 Jan 2025 at 2:50 pm",
                      showClickToView: true),
                  buildStep(4, "Delivery rescheduled", "19 Jan 2025 at 10:00 am",
                      showClickToView: true),
                  buildStep(5, "Payment Successful", "19 Jan 2025 at 10:00 am"),
                  buildStep(6, "Product Delivered", "19 Jan 2025 at 10:00 am"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStep(int stepNumber, String title, String time,
      {bool showClickToView = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: Text(
                stepNumber.toString(),
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 40,
              width: 2,
              color: stepNumber == 6 ? Colors.transparent : Colors.grey,
            ),
          ],
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                time,
                style: TextStyle(color: Colors.black54),
              ),
              if (showClickToView)
                Text(
                  "click to view",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}