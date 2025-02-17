import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'invoice_screen.dart';
import 'add_item.dart';
import 'drafts_screen.dart';
import 'cart_item.dart';

class SalesScreen extends StatefulWidget {
  final String? customerName;
  final String? mobileNumber;
  final String? address;
  final String? email;
  final List<CartItem>? cartItems;
  final double? totalActualCost;
  final double? totalFinalCost;

  const SalesScreen({
    super.key,
    this.customerName,
    this.mobileNumber,
    this.address,
    this.email,
    this.cartItems,
    this.totalActualCost,
    this.totalFinalCost,
  });

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _mobileController;
  late final TextEditingController _customerNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _emailController;
  late List<CartItem> _cartItems;

  String _selectedPaymentMode = 'cash';
  String _paymentStatus = 'pending';
  int _customerRating = 0;
  bool _showMobileError = false;
  bool _showNameError = false;

  @override
  void initState() {
    super.initState();
    _cartItems = widget.cartItems?.toList() ?? [];
    _mobileController = TextEditingController(text: widget.mobileNumber)
      ..addListener(_validateMobile);
    _customerNameController = TextEditingController(text: widget.customerName)
      ..addListener(_validateName);
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _pincodeController = TextEditingController();
    _emailController = TextEditingController(text: widget.email);

    if (widget.address != null) {
      final addressParts = widget.address!.split(',');
      if (addressParts.length >= 4) {
        _addressController.text = addressParts[0].trim();
        _cityController.text = addressParts[1].trim();
        _stateController.text = addressParts[2].trim();
        _pincodeController.text = addressParts[3].trim();
      }
    }
  }

  void _validateMobile() {
    setState(() {
      _showMobileError = _mobileController.text.isEmpty;
    });
  }

  void _validateName() {
    setState(() {
      _showNameError = _customerNameController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _customerNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String get combinedAddress {
    return [
      _addressController.text,
      _cityController.text,
      _stateController.text,
      _pincodeController.text,
    ].where((s) => s.isNotEmpty).join(', ');
  }

  void _editItem(int index) {
    // Navigate to AddItemScreen with the item to edit
    final itemToEdit = _cartItems[index];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(
          customerName: _customerNameController.text,
          mobileNumber: _mobileController.text,
          address: combinedAddress,
          email: _emailController.text,
          existingItems: _cartItems,
        ),
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  bool get _canSubmit {
    return _formKey.currentState?.validate() == true &&
        _cartItems.isNotEmpty &&
        (_paymentStatus != 'paid' || _customerRating > 0);
  }

  Widget _buildToggleButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
              child: const Text('Services',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Sales',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatsCard(
              'Total Items', _cartItems.length.toString()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatsCard('Actual Cost',
              '₹${widget.totalActualCost?.toStringAsFixed(2) ?? "0"}'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatsCard(
              'Final Cost', '₹${widget.totalFinalCost?.toStringAsFixed(2) ?? "0"}'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                AppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Galaxy Technologies',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildToggleButtons(),
                      const SizedBox(height: 20),
                      _buildStatsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Mobile Number*',
                        errorText: _showMobileError ? 'Please enter mobile number' : null,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.phone),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // TODO: Implement search functionality
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name*',
                        errorText: _showNameError ? 'Please enter customer name' : null,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter customer name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'City',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stateController,
                            decoration: const InputDecoration(
                              labelText: 'State',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Pincode',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Id',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_cartItems.isNotEmpty) ...[
                      Row(
                        children: const [
                          Icon(Icons.shopping_cart),
                          SizedBox(width: 8),
                          Text(
                            'Cart',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.item} - ${item.model}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text('Quantity: ${item.quantity}'),
                                        Text(
                                          'Price: ₹${item.updatedPrice}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _editItem(index),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeItem(index),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(8),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddItemScreen(
                                    customerName: _customerNameController.text,
                                    mobileNumber: _mobileController.text,
                                    address: combinedAddress,
                                    email: _emailController.text,
                                    existingItems: _cartItems,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                          icon: const Icon(Icons.add, size: 22, color: Colors.white),
                          label: const Text(
                            'Add Item',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_cartItems.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Payment Status*',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Radio(
                            value: 'paid',
                            groupValue: _paymentStatus,
                            onChanged: (value) {
                              setState(() => _paymentStatus = value.toString());
                            },
                          ),
                          const Text('Paid'),
                          const SizedBox(width: 16),
                          Radio(
                            value: 'pending',
                            groupValue: _paymentStatus,
                            onChanged: (value) {
                              setState(() => _paymentStatus = value.toString());
                            },
                          ),
                          const Text('Pending'),
                        ],
                      ),
                      if (_paymentStatus == 'paid') ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Payment Mode*',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio(
                              value: 'cash',
                              groupValue: _selectedPaymentMode,
                              onChanged: (value) {
                                setState(() => _selectedPaymentMode = value.toString());
                              },
                            ),
                            const Text('Cash'),
                            const SizedBox(width: 16),
                            Radio(
                              value: 'card',
                              groupValue: _selectedPaymentMode,
                              onChanged: (value) {
                                setState(() => _selectedPaymentMode = value.toString());
                              },
                            ),
                            const Text('Card'),
                            const SizedBox(width: 16),
                            Radio(
                              value: 'upi',
                              groupValue: _selectedPaymentMode,
                              onChanged: (value) {
                                setState(() => _selectedPaymentMode = value.toString());
                              },
                            ),
                            const Text('UPI'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Customer Rating*',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                setState(() => _customerRating = index + 1);
                              },
                              icon: Icon(
                                index < _customerRating ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 32,
                              ),
                            );
                          }),
                        ),
                        if (_customerRating == 0) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Please rate the customer',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ],
                    ],
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DraftsScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  'DRAFTS',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[800],
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  'SAVE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  'DISCARD',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _canSubmit
                                    ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InvoiceScreen(
                                        customerName: _customerNameController.text,
                                        mobileNumber: _mobileController.text,
                                        items: _cartItems,
                                        totalAmount: widget.totalFinalCost ?? 0.0,
                                        paymentMethod: _selectedPaymentMode,
                                      ),
                                    ),
                                  );
                                }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  disabledBackgroundColor: Colors.grey,
                                ),
                                child: const Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}