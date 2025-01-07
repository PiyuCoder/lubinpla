import 'dart:ffi';

class SectionData {
  String projectName;
  Map<String, String>? owner;
  Map<String, String>?
      collaborator; // Single collaborator with name and profilePic
  List<Map<String, String>> share; // List of users with name and profilePic
  String industry;
  String category;
  String attribute;
  List<Map<String, String>>
      extraFields; // List of subcategory data (key-value pairs)
  List<Condition> conditions;
  String turningrate;
  List<Product> products;

  SectionData({
    this.projectName = '',
    this.owner,
    this.collaborator,
    this.share = const [],
    this.industry = '',
    this.category = '',
    this.attribute = '',
    this.extraFields = const [],
    List<Condition>? conditions,
    this.turningrate = '',
    this.products = const [],
  }) : conditions = conditions ?? [];

  SectionData copyWith({
    String? projectName,
    Map<String, String>? owner,
    Map<String, String>? collaborator,
    List<Map<String, String>>? share,
    String? industry,
    String? category,
    String? attribute,
    List<Map<String, String>>?
        extraFields, // Fixed the missing `?` and added comma
    List<Condition>? conditions,
    String? turningrate,
    List<Product>? products,
  }) {
    return SectionData(
      projectName: projectName ?? this.projectName,
      owner: owner ?? this.owner,
      collaborator: collaborator ?? this.collaborator,
      share: share ?? this.share,
      industry: industry ?? this.industry,
      category: category ?? this.category,
      attribute: attribute ?? this.attribute,
      extraFields:
          extraFields ?? this.extraFields, // Update extraFields if passed
      conditions: conditions ?? this.conditions,
      turningrate: turningrate ?? this.turningrate,
      products: products ?? this.products,
    );
  }
}

class Product {
  String name;
  String usageAmount;
  String date;

  Product({
    required this.name,
    required this.usageAmount,
    required this.date,
  });

  @override
  String toString() {
    return 'Product(name: $name, usageAmount: $usageAmount, date: $date)';
  }
}

class Condition {
  String condition;
  String explaination;
  String? detail;
  bool required;
  bool newCondition;
  Map<String, dynamic>? edited;
  String? id;

  Condition({
    required this.condition,
    required this.explaination,
    this.detail,
    required this.required,
    this.newCondition = false,
    this.edited,
    this.id,
  });

  @override
  String toString() {
    return 'Condition(condition: $condition, explaination: $explaination, detail: $detail)';
  }
}
