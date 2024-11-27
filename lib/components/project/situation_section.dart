import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';

class CurrentSituationScreen extends StatelessWidget {
  final SectionData sectionData;
  final List<Product> products;

  const CurrentSituationScreen({
    super.key,
    required this.sectionData,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (products.isEmpty) const Text("No products added yet"),
            for (var product in products)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Space between the left and right
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left column (Product Name and Usage Amount)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${product.usageAmount}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${product.name}",
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      ],
                    ),
                    // Right side (Start Date)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("${product.date}",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
