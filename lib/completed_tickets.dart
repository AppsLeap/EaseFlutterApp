import 'package:flutter/material.dart';

class Ticket {
  final String ticketNumber;
  final String name;
  final String mobile;

  Ticket({required this.ticketNumber, required this.name, required this.mobile});
}

class CompletedTickets extends StatefulWidget {
  const CompletedTickets({super.key});

  @override
  _CompletedTicketsState createState() => _CompletedTicketsState();
}

class _CompletedTicketsState extends State<CompletedTickets> {
  final List<Ticket> tickets = [];
  String searchQuery = '';
  String dropdownValue = 'completed';
  String timeframeValue = 'Today';

  @override
  void initState() {
    super.initState();
    tickets.addAll([
      Ticket(ticketNumber: 'Ticket 001', name: 'John Doe', mobile: '123-456-7890'),
      Ticket(ticketNumber: 'Ticket 002', name: 'Jane Smith', mobile: '987-654-3210'),
      Ticket(ticketNumber: 'Ticket 003', name: 'Alice Johnson', mobile: '456-789-0123'),
      Ticket(ticketNumber: 'Ticket 004', name: 'Michael Brown', mobile: '654-321-9870'),
      Ticket(ticketNumber: 'Ticket 005', name: 'Sarah Wilson', mobile: '321-654-0987'),
      Ticket(ticketNumber: 'Ticket 006', name: 'David Lee', mobile: '987-123-4567'),
      Ticket(ticketNumber: 'Ticket 007', name: 'Emily White', mobile: '765-432-1098'),
      Ticket(ticketNumber: 'Ticket 008', name: 'Sophia Green', mobile: '876-543-2109'),
      Ticket(ticketNumber: 'Ticket 009', name: 'Liam King', mobile: '234-567-8901'),
      Ticket(ticketNumber: 'Ticket 010', name: 'Olivia Scott', mobile: '890-123-4567'),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final filteredTickets = tickets.where((ticket) {
      final query = searchQuery.toLowerCase();
      return ticket.ticketNumber.toLowerCase().contains(query) ||
          ticket.name.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Galaxy Technologies',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Sales',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by Ticket Number/Name...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchQuery = '';
                              });
                            },
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: timeframeValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(),
                      items: ['Today', 'This Week', 'This Month', 'This Year']
                          .map((String value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          timeframeValue = newValue!;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      underline: Container(),
                      items: ['completed', 'pending']
                          .map((String value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                          .toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null && newValue == 'pending') {
                          Navigator.pushReplacementNamed(context, '/employeeServicesHome');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredTickets.isNotEmpty
                ? Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = filteredTickets[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2, // Added shadow with elevation
                      margin: const EdgeInsets.only(bottom: 4.0), // Kept the reduced spacing
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            ticket.ticketNumber,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ticket.name),
                              Text(ticket.mobile),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )
                : const Center(child: Text('No tickets found!')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_ticket');
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        height: 60,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 30), // For balance
            SizedBox(width: 30), // For balance
          ],
        ),
      ),
    );
  }
}