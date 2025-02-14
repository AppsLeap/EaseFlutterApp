import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'employee_services_homescreen.dart';
import 'completed_tickets.dart';
import 'profile_screen.dart';
import 'create_ticket.dart';
import 'repair_status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repair Status',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => EmployeeServicesHomeScreen(),
        '/completedTickets': (context) => CompletedTickets(),
        '/employeeServicesHome': (context) => EmployeeServicesHomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/createTicket': (context) => CreateTicketScreen(),
        '/repairStatus': (context) => const RepairStatusPage(),
      },
    );
  }
}