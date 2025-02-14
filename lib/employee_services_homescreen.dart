import 'package:flutter/material.dart';
import 'completed_tickets.dart';
import 'profile_screen.dart';
import 'create_ticket.dart';
import 'ticket_tracker.dart';
import 'repair_status.dart';

class EmployeeServicesHomeScreen extends StatefulWidget {
  const EmployeeServicesHomeScreen({super.key});

  @override
  _EmployeeServicesHomeScreenState createState() =>
      _EmployeeServicesHomeScreenState();
}

class _EmployeeServicesHomeScreenState extends State<EmployeeServicesHomeScreen> {
  int selectedTab = 0;
  String selectedStatus = "Pending";
  String selectedTimeframe = "Today";
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> tickets = [
    {"id": "#1", "name": "John Doe", "status": "Assigned", "repairType": "Software Issue", "date": "2025-02-06", "employee": "Alice"},
    {"id": "#2", "name": "Jane Smith", "status": "Assigned", "repairType": "Screen Replacement", "date": "2025-02-07", "employee": "Bob"},
    {"id": "#3", "name": "Michael Brown", "status": "Assigned", "repairType": "Battery Issue", "date": "2025-02-08", "employee": "Charlie"},
    {"id": "#4", "name": "Emily White", "status": "Assigned", "repairType": "Keyboard Issue", "date": "2025-02-09", "employee": "David"},
    {"id": "#5", "name": "Sophia Green", "status": "Assigned", "repairType": "Motherboard Repair", "date": "2025-02-10", "employee": "Eve"},
    {"id": "#6", "name": "Liam King", "status": "Assigned", "repairType": "Overheating", "date": "2025-02-11", "employee": "Frank"},
    {"id": "#7", "name": "Olivia Scott", "status": "Assigned", "repairType": "Software Update", "date": "2025-02-12", "employee": "Grace"},
    {"id": "#8", "name": "Noah Adams", "status": "Assigned", "repairType": "Hard Drive Replacement", "date": "2025-02-13", "employee": "Hank"},
    {"id": "#9", "name": "Ava Walker", "status": "Assigned", "repairType": "RAM Upgrade", "date": "2025-02-14", "employee": "Ivy"},
    {"id": "#10", "name": "Mason Young", "status": "Assigned", "repairType": "Virus Removal", "date": "2025-02-15", "employee": "Jack"},
  ];

  void _showCompletedTickets() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CompletedTickets()),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen()),
    );
  }

  void _navigateToCreateTicket() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateTicketScreen()),
    );

    if (result != null) {
      setState(() {
        tickets.add({
          "id": "#${tickets.length + 1}",
          "name": result["customerName"],
          "status": "not assigned",
          "repairType": result["problemType"],
          "date": "not confirmed",
          "employee": "NULL"
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: _navigateToProfile,
              child: const Icon(Icons.account_circle, size: 32),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Galaxy Technologies",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTabBar(),
            _buildSearchAndFilters(),
            SizedBox(
              height: 500,
              child: _buildTicketList(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateTicket,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Container(height: 50),
      ),
    );
  }

  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => setState(() => selectedTab = 0),
          child: Text(
            "Services",
            style: TextStyle(
                fontSize: 16,
                fontWeight: selectedTab == 0 ? FontWeight.bold : FontWeight.normal),
          ),
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () => setState(() => selectedTab = 1),
          child: Text(
            "Sales",
            style: TextStyle(
                fontSize: 16,
                fontWeight: selectedTab == 1 ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 45,
            child: TextField(
              controller: searchController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Search by employee name/Ticket Number/Name...",
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: selectedTimeframe,
                items: ["Today", "This Week", "This Month", "This Year"]
                    .map((String value) =>
                    DropdownMenuItem(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 14)),
                    ))
                    .toList(),
                onChanged: (String? newValue) =>
                    setState(() => selectedTimeframe = newValue!),
              ),
              DropdownButton<String>(
                value: selectedStatus,
                items: ["Pending", "Completed"]
                    .map((String value) =>
                    DropdownMenuItem(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 14)),
                    ))
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() => selectedStatus = newValue!);
                  if (newValue == "Completed") {
                    _showCompletedTickets();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList() {
    final filteredTickets = tickets.where((ticket) {
      final id = ticket["id"]!.toLowerCase();
      final name = ticket["name"]!.toLowerCase();
      final employee = ticket["employee"]!.toLowerCase();
      final query = searchQuery.toLowerCase();

      return id.contains(query) ||
          name.contains(query) ||
          employee.contains(query);
    }).toList();

    // Sort tickets in descending order based on ticket number
    filteredTickets.sort((a, b) {
      // Extract numbers from ticket IDs (removing the '#' symbol)
      int aNumber = int.parse(a["id"]!.substring(1));
      int bNumber = int.parse(b["id"]!.substring(1));
      // Sort in descending order (b compared to a)
      return bNumber.compareTo(aNumber);
    });

    return ListView.builder(
      itemCount: filteredTickets.length,
      itemBuilder: (context, index) {
        final ticket = filteredTickets[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RepairStatusPage(),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TicketTrackerScreen(
                            ticketNumber: ticket["id"]!,
                            name: ticket["name"]!,
                            mobile: "8309096227",
                            date: ticket["date"]!,
                            repairType: ticket["repairType"]!,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      ticket["id"]!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ticket["name"]!, style: const TextStyle(fontSize: 14)),
                      Text(ticket["status"]!, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(ticket["repairType"]!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(ticket["date"]!, style: const TextStyle(fontSize: 14)),
                      Text(ticket["employee"]!, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}