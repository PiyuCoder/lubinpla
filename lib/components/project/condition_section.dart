import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:lubinpla/screens/turning_rate_search.dart';

class ConditionSection extends StatelessWidget {
  final SectionData data;
  final ValueChanged<SectionData> onDataChanged;
  final List<TurningRate> turningrates;

  const ConditionSection({
    required this.data,
    required this.onDataChanged,
    required this.turningrates,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Turning Rate"),
                IconButton(
                  style: IconButton.styleFrom(overlayColor: Colors.transparent),
                  icon: const Icon(Icons.question_mark_rounded),
                  onPressed: () {},
                )
              ],
            ),
            GestureDetector(
              onTap: () async {
                // Navigate to TurnoverSearchScreen
                String? selectedTurnover = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TurnoverSearchScreen(
                      onSelectTurnover: (turnover) {
                        onDataChanged(data..turningrate = turnover);
                      },
                    ),
                  ),
                );
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(text: data.turningrate),
                  decoration: const InputDecoration(
                    // labelText: 'Turnover',
                    hintText: '입력해주세요',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),

        // if (turningrates.isEmpty) const Text("No products added yet"),
        for (var turningrate in turningrates)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              width:
                  double.infinity, // Ensures the container spans the full width
              padding: const EdgeInsets.only(
                  bottom: 8.0), // Space between text and border
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey, width: 1.0), // Bottom border only
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    turningrate.condition,
                    style: const TextStyle(
                        // fontSize: 16,
                        ),
                  ),
                  const SizedBox(
                      height: 10), // Space between condition and detail
                  Text(
                    turningrate.detail,
                    style: const TextStyle(
                      color: Colors.black87, // Slightly lighter than pure black
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
