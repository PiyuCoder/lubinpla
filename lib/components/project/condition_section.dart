import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart'; // Ensure that Condition is part of SectionData
import 'package:lubinpla/screens/condition_detail_screen.dart'; // For Condition details
import 'package:lubinpla/screens/turning_rate_search.dart'; // For Turnover selection

class ConditionSection extends StatelessWidget {
  final SectionData data; // Ensure this contains the updated conditions
  final ValueChanged<SectionData> onDataChanged;
  final bool editingMode;

  const ConditionSection({
    required this.data,
    required this.onDataChanged,
    required this.editingMode,
  });

  @override
  Widget build(BuildContext context) {
    print(
        'Conditions in ConditionSection: ${data.conditions}'); // Debug print to check conditions

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and info button
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Conditions"),
                  IconButton(
                    style:
                        IconButton.styleFrom(overlayColor: Colors.transparent),
                    icon: const Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConditionDetailsScreen(
                            data: data,
                            onDataChanged: onDataChanged,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
              GestureDetector(
                onTap: () async {
                  String? selectedTurnover = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TurnoverSearchScreen(
                        onSelectTurnover: (turnover) {
                          onDataChanged(data.copyWith(turningrate: turnover));
                        },
                      ),
                    ),
                  );
                },
                child: AbsorbPointer(
                    // child: TextFormField(
                    //   controller: TextEditingController(text: data.turningrate),
                    //   enabled: false,
                    //   decoration: const InputDecoration(
                    //     hintText: '입력해주세요',
                    //   ),
                    // ),
                    ),
              ),
              const SizedBox(height: 16),
            ],
          ),

          // Display conditions
          if (data.conditions.isEmpty) const Text("No conditions added yet"),
          for (var condition in data.conditions)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 8.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${condition.condition} ${condition.required ? '*' : ''}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      condition.detail!,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
