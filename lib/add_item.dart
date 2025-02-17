import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sales_screen.dart';
import 'cart_item.dart';

class AddItemScreen extends StatefulWidget {
  final String? customerName;
  final String? mobileNumber;
  final String? address;
  final String? email;
  final List<CartItem>? existingItems;

  const AddItemScreen({
    Key? key,
    this.customerName,
    this.mobileNumber,
    this.address,
    this.email,
    this.existingItems,
  }) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _actualPriceController = TextEditingController();
  final TextEditingController _finalPriceController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();

  int _quantity = 1;
  int? _editingIndex;
  bool _hasChanges = false;
  bool _isInitialLoad = true;

  late List<CartItem> cartItems;

  String? selectedItemType;
  String? selectedModel;

  // Sample specifications data
  final Map<String, Map<String, String>> itemSpecifications = {
    'iPhone 12': {
      'Display': '6.1-inch Super Retina XDR',
      'Processor': 'A14 Bionic chip',
      'Camera': '12MP dual-camera system',
      'Battery': '2815 mAh',
      'Storage': '64GB/128GB/256GB',
    },
    'iPad Air': {
      'Display': '10.9-inch Liquid Retina',
      'Processor': 'M1 chip',
      'Camera': '12MP Wide camera',
      'Battery': '28.6-watt-hour',
      'Storage': '64GB/256GB',
    },
  };

  final Map<String, List<String>> itemModels = {
    'Mobile Phone': [
      'iPhone 12',
      'iPhone 13',
      'iPhone 14',
      'Samsung Galaxy S21',
      'Samsung Galaxy S22',
      'Samsung Galaxy S23',
    ],
    'Tablet': [
      'iPad Pro',
      'iPad Air',
      'Samsung Galaxy Tab S8',
      'Samsung Galaxy Tab S7',
    ],
    'Laptop': [
      'MacBook Air',
      'MacBook Pro',
      'Dell XPS 13',
      'Dell XPS 15',
      'Lenovo ThinkPad X1',
      'Lenovo ThinkPad T14',
    ],
  };

  @override
  void initState() {
    super.initState();
    cartItems = widget.existingItems?.toList() ?? [];
    _isInitialLoad = true;

    // Add listeners to track changes
    _actualPriceController.addListener(_onFieldChanged);
    _finalPriceController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _actualPriceController.removeListener(_onFieldChanged);
    _finalPriceController.removeListener(_onFieldChanged);
    _descriptionController.removeListener(_onFieldChanged);
    _actualPriceController.dispose();
    _finalPriceController.dispose();
    _descriptionController.dispose();
    _unitPriceController.dispose();
    _totalPriceController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_isInitialLoad) {
      setState(() {
        _hasChanges = true;
      });
      _updatePrices();
    }
  }

  void _updatePrices() {
    final actualPrice = double.tryParse(_actualPriceController.text) ?? 0.0;
    _unitPriceController.text = '₹${actualPrice.toStringAsFixed(2)}';
    _totalPriceController.text = '₹${(actualPrice * _quantity).toStringAsFixed(2)}';
  }

  List<String> get availableModels {
    return selectedItemType != null ? itemModels[selectedItemType]! : [];
  }

  void _updateSpecifications(String model) {
    if (itemSpecifications.containsKey(model)) {
      final specs = itemSpecifications[model]!;
      final specText = specs.entries
          .map((e) => '${e.key}:\n${e.value}')
          .join('\n\n');
      _descriptionController.text = specText;
    }
  }

  Future<bool> _onWillPop() async {
    if (_hasChanges) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Save Changes?'),
          content: const Text('Do you want to save your changes before leaving?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        ),
      );

      if (result ?? false) {
        _addItemToCart();
      }
    }
    return true;
  }

  void _addItemToCart() {
    if (_formKey.currentState!.validate()) {
      final double actualPrice = double.tryParse(_actualPriceController.text) ?? 0.0;
      final double finalPrice = double.tryParse(_finalPriceController.text) ?? 0.0;

      if (actualPrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Actual price must be greater than 0')),
        );
        return;
      }

      if (finalPrice > actualPrice) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Final price cannot be greater than actual price')),
        );
        return;
      }

      setState(() {
        final newItem = CartItem(
          item: selectedItemType!,
          model: selectedModel!,
          description: _descriptionController.text.trim(),
          quantity: _quantity,
          actualPrice: actualPrice,
          updatedPrice: finalPrice,
        );

        if (_editingIndex != null) {
          cartItems[_editingIndex!] = newItem;
          _editingIndex = null;
        } else {
          cartItems.add(newItem);
        }
        _clearForm();
      });
    }
  }

  void _clearForm() {
    setState(() {
      selectedItemType = null;
      selectedModel = null;
      _descriptionController.clear();
      _actualPriceController.clear();
      _finalPriceController.clear();
      _unitPriceController.clear();
      _totalPriceController.clear();
      _quantity = 1;
      _editingIndex = null;
      _hasChanges = false;
      _isInitialLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Items'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalesScreen(
                      customerName: widget.customerName,
                      mobileNumber: widget.mobileNumber,
                      address: widget.address,
                      email: widget.email,
                      cartItems: cartItems,
                      totalActualCost: cartItems.fold(0, (sum, item) => sum! + ((item.actualPrice ?? 0) * (item.quantity ?? 0))),
                      totalFinalCost: cartItems.fold(0, (sum, item) => sum! + ((item.updatedPrice ?? 0) * (item.quantity ?? 0))),

                    ),
                  ),
                );
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedItemType,
                  decoration: const InputDecoration(
                    labelText: 'Select Item Type*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  items: itemModels.keys.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItemType = newValue;
                      selectedModel = null;
                      _descriptionController.clear();
                      _hasChanges = true;
                    });
                  },
                  validator: (value) => value == null ? 'Please select an item type' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedModel,
                  decoration: const InputDecoration(
                    labelText: 'Select Model*',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  items: availableModels.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: selectedItemType == null ? null : (String? newValue) {
                    setState(() {
                      selectedModel = newValue;
                      if (newValue != null) {
                        _updateSpecifications(newValue);
                      }
                      _hasChanges = true;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a model' : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Quantity*'),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                            _hasChanges = true;
                          });
                          _updatePrices();
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Text('$_quantity'),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (_quantity < 6) {
                          setState(() {
                            _quantity++;
                            _hasChanges = true;
                          });
                          _updatePrices();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _unitPriceController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Unit Price',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _totalPriceController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Total Price',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Specifications',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _actualPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Actual Price*',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter actual price';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    if (double.parse(value) <= 0) return 'Actual price must be greater than 0';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _finalPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Final Price*',
                    border: OutlineInputBorder(),
                    prefixText: '₹ ',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter final price';
                    if (double.tryParse(value) == null) return 'Please enter a valid number';
                    final finalPrice = double.parse(value);
                    final actualPrice = double.tryParse(_actualPriceController.text) ?? 0;
                    if (finalPrice > actualPrice) return 'Final price cannot be greater than actual price';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _hasChanges ? _addItemToCart : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      _editingIndex == null ? 'Add Item' : 'Update Item',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Rest of your existing code for cart items list...
              ],
            ),
          ),
        ),
      ),
    );
  }
}