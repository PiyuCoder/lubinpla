import 'package:flutter/material.dart';

class ProductNameScreen extends StatefulWidget {
  const ProductNameScreen({super.key});

  @override
  _ProductNameScreenState createState() => _ProductNameScreenState();
}

class _ProductNameScreenState extends State<ProductNameScreen> {
  final TextEditingController productNameController = TextEditingController();

  // Dummy product data
  final List<String> allProducts = [
    'Laptop',
    'Smartphone',
    'Tablet',
    'Smartwatch',
    'Headphones',
    'Keyboard',
    'Mouse',
    'Monitor',
    'Printer',
    'Camera'
  ];

  // Filtered products for search
  List<String> filteredProducts = [];

  @override
  void initState() {
    super.initState();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) =>
                product.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: RichText(
            text: const TextSpan(
              text: '사용할 제품명 입력',
              style: TextStyle(
                fontSize: 18.0, // Main title size
                color: Colors.black, // AppBar text color
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' (1/3)',
                  style: TextStyle(
                    fontSize: 14.0, // Smaller size for the fraction
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: '입력해주세요',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      filteredProducts = [];
                    });
                    productNameController.clear();
                  },
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ListTile(
                    title: Text(product),
                    onTap: () {
                      // Return selected product
                      Navigator.pop(context, product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
