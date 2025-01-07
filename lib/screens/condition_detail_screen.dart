import 'package:flutter/material.dart';
import 'package:lubinpla/models/project_create_data.dart';
import 'package:lubinpla/screens/edit_condition.dart';
import 'package:lubinpla/screens/turning_rate_explain.dart';

class ConditionDetailsScreen extends StatefulWidget {
  final SectionData data;
  // final List<Condition> turningrates;
  final ValueChanged<SectionData> onDataChanged;

  const ConditionDetailsScreen({
    required this.data,
    // required this.turningrates,
    required this.onDataChanged,
  });

  @override
  _ConditionDetailsScreenState createState() => _ConditionDetailsScreenState();
}

class _ConditionDetailsScreenState extends State<ConditionDetailsScreen> {
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("조건 칼럼 설명",
            style: TextStyle(
              fontSize: 18.0, // Main title size
              color: Colors.black, // AppBar text color
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          style: IconButton.styleFrom(overlayColor: Colors.transparent),
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isEditable = !isEditable;
              });
            },
            child: Text(
              isEditable ? "완료" : "편집",
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var turningrate in widget.data.conditions ?? [])
              GestureDetector(
                onTap: isEditable
                    ? () async {
                        final editedDetail = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditConditionScreen(
                              condition: turningrate.condition,
                              initialDetail: turningrate.explaination,
                            ),
                          ),
                        );

                        if (editedDetail != null) {
                          setState(() {
                            turningrate.explaination = editedDetail;
                          });
                        }
                      }
                    : null,
                child: Padding(
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
                          turningrate.condition,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          turningrate.explaination,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
