import 'package:flutter/material.dart';
import 'package:lubinpla/components/project/usage_amount.dart';

class ProductNameScreen extends StatefulWidget {
  const ProductNameScreen({super.key});

  @override
  _ProductNameScreenState createState() => _ProductNameScreenState();
}

class _ProductNameScreenState extends State<ProductNameScreen> {
  final TextEditingController productNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Product Name")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: productNameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to next screen with product name
                final productName = productNameController.text;
                // Navigator.pop(context);
                Navigator.pop(context, productName);

                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => UsageAmountScreen(
                //       productName: productName, // Pass product name
                //     ),
                //   ),
                // );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
