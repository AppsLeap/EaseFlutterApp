import 'package:flutter/material.dart';
import 'sales_screen.dart';
class DraftItem {
  final String customerName;
  final String date;
  final String draftId;
  final double totalAmount;
  final bool isIncomplete;

  DraftItem({
    required this.customerName,
    required this.date,
    required this.draftId,
    required this.totalAmount,
    this.isIncomplete = true,
  });
}

class DraftsScreen extends StatefulWidget {
  final String? customerName;
  final List<dynamic>? items;
  final String? mobileNumber;
  final String? paymentMethod;
  final double? totalAmount;

  const DraftsScreen({
    Key? key,
    this.customerName,
    this.items,
    this.mobileNumber,
    this.paymentMethod,
    this.totalAmount,
  }) : super(key: key);

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  final List<DraftItem> _drafts = [
    DraftItem(
      customerName: 'John Doe',
      date: '25 Jan 2025, 11:00 AM',
      draftId: '#12345',
      totalAmount: 25000,
    ),
    DraftItem(
      customerName: 'John Doe',
      date: '25 Jan 2025, 11:00 AM',
      draftId: '#12345',
      totalAmount: 25000,
    ),
    DraftItem(
      customerName: 'John Doe',
      date: '25 Jan 2025, 11:00 AM',
      draftId: '#12345',
      totalAmount: 25000,
    ),
    DraftItem(
      customerName: 'John Doe',
      date: '25 Jan 2025, 11:00 AM',
      draftId: '#12345',
      totalAmount: 25000,
    ),
    DraftItem(
      customerName: 'John Doe',
      date: '25 Jan 2025, 11:00 AM',
      draftId: '#12345',
      totalAmount: 25000,
    ),
  ];

  void _editDraft(int index) {
    // TODO: Implement edit functionality
  }

  void _deleteDraft(int index) {
    setState(() {
      _drafts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sales Drafts',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _drafts.length,
            itemBuilder: (context, index) {
              final draft = _drafts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[900], // Dark Gray Color
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5), // Shadow Color
                                  spreadRadius: 1, // How much the shadow spreads
                                  blurRadius: 5, // Blur effect
                                  offset: Offset(2, 2), // Shadow position (x, y)
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent, // Keeps only the container color
                              radius: 5,
                            ),
                          ),

                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer Name: ${draft.customerName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Date: ${draft.date}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Draft ID: ${draft.draftId}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Total Amount: ₹${draft.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: draft.isIncomplete ? Colors.amber : Colors.green,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                draft.isIncomplete ? 'Incomplete' : 'Complete',
                                style: TextStyle(
                                  color: draft.isIncomplete ? Colors.amber : Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => _editDraft(index),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                child: const Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () => _deleteDraft(index),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                child: const Text('Delete'),
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
          Positioned(
            bottom: 30,   // Keep it near the bottom
            right: 25,    // Move it to the right corner
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalesScreen()),
                );
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.add, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}