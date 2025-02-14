import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repair Status',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const RepairStatusPage(),
    );
  }
}

class SpareItem {
  String name;
  String quantity;
  String warranty;
  String cost;

  SpareItem({
    required this.name,
    required this.quantity,
    this.warranty = '2 years',
    this.cost = '₹1000',
  });

  double getCost() {
    return double.tryParse(cost.replaceAll('₹', '').replaceAll('k', '000')) ?? 0;
  }
}

class RepairStatusPage extends StatefulWidget {
  const RepairStatusPage({super.key});

  @override
  State<RepairStatusPage> createState() => _RepairStatusPageState();
}

class _RepairStatusPageState extends State<RepairStatusPage> {
  String? selectedTechnician;
  String selectedDeliveryType = 'Pickup';
  bool isPaid = false;
  bool isDelivered = false;
  double rating = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  double serviceCost = 0;
  double finalCost = 0;

  final List<File> afterRepairPhotos = [];
  final ImagePicker _picker = ImagePicker();

  List<SpareItem> spareItems = [];

  final List<String> technicians = [
    'Ram',
    'John',
    'Sarah',
    'Mike',
    'David',
    'Emma'
  ];

  final List<String> deliveryTypes = ['Pickup', 'Home Delivery'];

  final List<String> availableSpares = [
    'Screen',
    'Keyboard',
    'RAM',
    'Hard Disk',
    'SSD',
    'Battery',
    'Charger',
    'Motherboard',
    'CPU Fan',
    'GPU',
    'Webcam',
    'Speakers',
    'Touchpad',
    'Hinges',
    'LCD Cable',
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _serviceCostController = TextEditingController();
  final TextEditingController _finalCostController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _takeAfterRepairPhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        setState(() {
          afterRepairPhotos.add(File(photo.path));
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
    }
  }

  void _removeAfterRepairPhoto(int index) {
    setState(() {
      afterRepairPhotos.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _serviceCostController.dispose();
    _finalCostController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  double calculateSpareCost() {
    return spareItems.fold(0, (sum, item) => sum + item.getCost());
  }

  double calculateTotalCost() {
    return serviceCost + calculateSpareCost();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _addNewSpareItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Spare Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return availableSpares.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String selection) {
                    _nameController.text = selection;
                  },
                  fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Spare Name',
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _quantityController.text.isNotEmpty) {
                  setState(() {
                    spareItems.add(
                      SpareItem(
                        name: _nameController.text,
                        quantity: _quantityController.text,
                      ),
                    );
                  });
                  _nameController.clear();
                  _quantityController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeSpareItem(int index) {
    setState(() {
      spareItems.removeAt(index);
    });
  }

  Widget _buildAfterRepairSection() {
    return Expanded(
      child: Column(
        children: [
          const Text(
            'After Repair',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Container(
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: afterRepairPhotos.isEmpty
                ? InkWell(
              onTap: _takeAfterRepairPhoto,
              child: const Center(
                child: Icon(Icons.add_a_photo, size: 40),
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: afterRepairPhotos.length + 1,
                    itemBuilder: (context, index) {
                      if (index == afterRepairPhotos.length) {
                        return afterRepairPhotos.length < 5
                            ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: _takeAfterRepairPhoto,
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add_a_photo, size: 40),
                            ),
                          ),
                        )
                            : const SizedBox.shrink();
                      }
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              afterRepairPhotos[index],
                              width: 120,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () => _removeAfterRepairPhoto(index),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '${afterRepairPhotos.length}/5 photos',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'Repair Status',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Row(
                      children: [
                        _buildCostBox('Service Cost', '₹${serviceCost.toStringAsFixed(0)}', Colors.white70),
                        _buildCostBox('Spare Cost', '₹${calculateSpareCost().toStringAsFixed(0)}', Colors.white70),
                        _buildCostBox('Total Cost', '₹${calculateTotalCost().toStringAsFixed(0)}', Colors.white70),
                        _buildCostBox('Final Cost', '₹${finalCost.toStringAsFixed(0)}', Colors.white70),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ticket assigned to *',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTechnician,
                          isExpanded: true,
                          hint: const Text('Select a technician'),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          items: technicians.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTechnician = newValue;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Date & Time *',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectDate(context),
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(selectedDate),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () => _selectTime(context),
                              child: Text(
                                selectedTime.format(context),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Spares Used',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(0.5),
                      },
                      children: [
                        const TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Spares',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Qty',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Warranty',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Cost',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        ...List.generate(
                          spareItems.length,
                              (index) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  spareItems[index].name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  spareItems[index].quantity,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  spareItems[index].warranty,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  spareItems[index].cost,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _removeSpareItem(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _addNewSpareItem,
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text(
                          'Add Item',
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Service Cost',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _serviceCostController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixText: '₹',
                        ),
                        onChanged: (value) {
                          setState(() {
                            serviceCost = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Final Cost',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _finalCostController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixText: '₹',
                        ),
                        onChanged: (value) {
                          setState(() {
                            finalCost = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Home delivery/Pickup',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDeliveryType,
                          isExpanded: true,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          items: deliveryTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDeliveryType = newValue!;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Device Photos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Before Repair',
                                style: TextStyle(fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: 160,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add_a_photo, size: 40),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildAfterRepairSection(),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Paid',
                              style: TextStyle(fontSize: 14),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: isPaid,
                                onChanged: (value) {
                                  setState(() {
                                    isPaid = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              'Delivered',
                              style: TextStyle(fontSize: 14),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: isDelivered,
                                onChanged: (value) {
                                  setState(() {
                                    isDelivered = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Overall Experience',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBox(String title, String amount, Color color) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
