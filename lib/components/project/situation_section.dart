import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';

class CurrentSituationScreen extends StatelessWidget {
  final SectionData sectionData;
  final List<Product> products;
  final bool editingMode;

  const CurrentSituationScreen({
    super.key,
    required this.sectionData,
    required this.products,
    required this.editingMode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            // controller: searchController,
            decoration: InputDecoration(
              hintText: "입력해주세요",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade500,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {},
              ),
              fillColor: Colors.grey.shade100,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "사용량 / 제품명",
                style: TextStyle(color: Colors.black38),
              ),
              Text(
                "사용날짜",
                style: TextStyle(color: Colors.black38),
              ),
            ],
          ),
          if (products.isEmpty)
            const Column(
              children: [
                SizedBox(height: 160.0),
                Center(
                    child: Text(
                  "새로운 현황을 추가해주세요",
                  style: TextStyle(color: Colors.black38),
                )),
              ],
            ),
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
                      Text(product.usageAmount,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(product.name,
                          style: const TextStyle(
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
    );
  }
}
