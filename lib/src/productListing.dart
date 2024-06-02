import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({super.key});

  @override
  State<ProductListingPage> createState() => _ProductListingPageState();
}

class Product {
  final int id;
  final String title;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(), // Parse price as a double
      image: json['image'],
    );
  }
}

class _ProductListingPageState extends State<ProductListingPage> {
  List<Product> _products = [];
  bool _isLoading = false; // Flag to indicate data fetching state
  String? _errorMessage; // Variable to hold error messages

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true; // Set loading state to true
      _errorMessage = null; // Reset error message
    });

    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          _products = data.map((item) => Product.fromJson(item)).toList();
          _isLoading = false; // Set loading state to false after data retrieval
        });
      } else {
        setState(() {
          _isLoading = false; // Set loading state to false on error
          _errorMessage = 'Failed to load products: ${response.statusCode}'; // Set error message with status code
        });
        print('Error fetching products: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Set loading state to false on error
        _errorMessage = 'An error occurred: $error'; // Set error message with the caught error
      });
      print('Error fetching products: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Products'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Display loading indicator
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!)) // Display error message if any
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.network(
                            product.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '\$${product.price}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}