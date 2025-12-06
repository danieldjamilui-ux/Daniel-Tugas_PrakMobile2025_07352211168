import 'package:flutter/material.dart';
import '../widgets/rounded_button.dart';
import 'settings_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Map<String, dynamic>>> cartItemsFuture;

  final double _discount = 4.0;
  final double _deliveryCharge = 2.0;

  @override
  void initState() {
    super.initState();
    cartItemsFuture = _loadCartItems();
  }

  Future<List<Map<String, dynamic>>> _loadCartItems() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        "id": "Watch",
        "name": "Watch",
        "brand": "Rolex",
        "price": 40.0,
        "quantity": 2,
        "image": "assets/images/jam.jpg"
      },
      {
        "id": "Airpods",
        "name": "Airpods",
        "brand": "Apple",
        "price": 333.0,
        "quantity": 2,
        "image": "assets/images/airpods.jpg"
      },
      {
        "id": "Hoodie",
        "name": "Hoodie",
        "brand": "Puma",
        "price": 50.0,
        "quantity": 2,
        "image": "assets/images/hoodie.jpg"
      },
    ];
  }

  double _calculateSubtotal(List<Map<String, dynamic>> items) {
    return items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  double _calculateTotal(List<Map<String, dynamic>> items) {
    double subtotal = _calculateSubtotal(items);
    return subtotal - _discount + _deliveryCharge;
  }

  void _updateQuantity(List<Map<String, dynamic>> items, int index, int delta) {
    setState(() {
      int newQuantity = items[index]['quantity'] + delta;
      if (newQuantity > 0) {
        items[index]['quantity'] = newQuantity;
      } else if (newQuantity == 0) {
        items.removeAt(index);
      }
      cartItemsFuture = Future.value(items);
    });
  }

  void _removeItem(List<Map<String, dynamic>> items, int index) {
    setState(() {
      items.removeAt(index);
      cartItemsFuture = Future.value(items);
    });
  }

  void _processCheckout(List<Map<String, dynamic>> items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout Berhasil'),
        content: const Text('Terima kasih telah berbelanja!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                cartItemsFuture = Future.value([]);
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'clear_cart') {
                setState(() {
                  cartItemsFuture = Future.value([]);
                });
              }
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'clear_cart', child: Text('Clear Cart')),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final cartItems = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: cartItems.isEmpty
                      ? const Center(
                          child: Text(
                            'Keranjang kosong',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      item['image'],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 100,
                                          height: 100,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image, size: 40),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['brand'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '\$${item['price'].toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Quantity Controls and Delete
                                  Column(
                                    children: [
                                      // Delete Button
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                        onPressed: () => _removeItem(cartItems, index),
                                      ),
                                      const SizedBox(height: 8),
                                      // Quantity Controls
                                      Row(
                                        children: [
                                          // Decrease Button
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: const BoxDecoration(
                                              color: Colors.deepPurple,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              onPressed: () => _updateQuantity(cartItems, index, -1),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // Quantity Display
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${item['quantity'].toString().padLeft(2, '0')}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          // Increase Button
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: const BoxDecoration(
                                              color: Colors.deepPurple,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              onPressed: () => _updateQuantity(cartItems, index, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Order Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow('Items', cartItems.length.toString()),
                      _buildSummaryRow(
                        'Subtotal',
                        '\$${_calculateSubtotal(cartItems).toStringAsFixed(0)}',
                      ),
                      _buildSummaryRow('Discount', '\$${_discount.toStringAsFixed(0)}'),
                      _buildSummaryRow(
                        'Delivery Charges',
                        '\$${_deliveryCharge.toStringAsFixed(0)}',
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        'Total',
                        '\$${_calculateTotal(cartItems).toStringAsFixed(0)}',
                        isTotal: true,
                      ),
                      const SizedBox(height: 20),
                      RoundedButton(
                        text: 'Check Out',
                        onPressed: cartItems.isNotEmpty
                            ? () => _processCheckout(cartItems)
                            : null,
                        backgroundColor: Colors.deepPurple,
                        textColor: Colors.white,
                        height: 56,
                        borderRadius: 16,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.black : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}