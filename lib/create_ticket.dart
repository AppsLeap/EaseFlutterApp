import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _mobileNumberController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _deviceIdController = TextEditingController();
  final _problemTypeController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  String? _selectedServiceItem;
  String? _selectedDevicePhoto;

  List<PhotoData> _capturedPhotos = [];

  final List<String> _serviceItems = [
    'Laptop',
    'Laptop (Mac)',
    'CPU',
    'Monitors',
  ];

  final List<String> _devicePhotoOptions = [
    'Top View',
    'Bottom View',
    'Front View',
    'Back View',
    'Left View',
    'Right View',
  ];

  Future<void> _capturePhoto() async {
    if (_selectedDevicePhoto == null) return;

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _capturedPhotos.add(
          PhotoData(
            file: File(photo.path),
            view: _selectedDevicePhoto!,
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  void _deletePhoto(int index) {
    setState(() {
      _capturedPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Create Ticket',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _mobileNumberController,
              decoration: InputDecoration(
                labelText: 'Mobile Number *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(
                labelText: 'Customer Name *',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Id',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Service Item *',
                border: OutlineInputBorder(),
              ),
              value: _selectedServiceItem,
              items: _serviceItems.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedServiceItem = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _deviceIdController,
              decoration: InputDecoration(
                labelText: 'Device ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _problemTypeController,
              decoration: InputDecoration(
                labelText: 'Problem Type *',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Device Photos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Photo View',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDevicePhoto,
                  items: _devicePhotoOptions.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDevicePhoto = value;
                    });
                    _capturePhoto();
                  },
                ),
                SizedBox(height: 16),
                ..._capturedPhotos.asMap().entries.map((entry) {
                  final index = entry.key;
                  final photo = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.file(
                                photo.file,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deletePhoto(index),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'View: ${photo.view}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Date: ${DateFormat('yyyy-MM-dd').format(photo.timestamp)}',
                                ),
                                Text(
                                  'Time: ${DateFormat('HH:mm:ss').format(photo.timestamp)}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'customerName': _customerNameController.text,
                    'problemType': _problemTypeController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoData {
  final File file;
  final String view;
  final DateTime timestamp;

  PhotoData({
    required this.file,
    required this.view,
    required this.timestamp,
  });
}