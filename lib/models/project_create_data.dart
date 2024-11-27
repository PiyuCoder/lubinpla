class SectionData {
  String projectName;
  String owner;
  Map<String, String>?
      collaborator; // Single collaborator with name and profilePic
  List<Map<String, String>> share; // List of users with name and profilePic
  String industry;
  String category;
  String attribute;
  String turningrate;
  List<Product> products; // List of products

  // Constructor with defaults and optional parameters
  SectionData({
    this.projectName = '',
    this.owner = '',
    this.collaborator, // Can be null
    this.share = const [], // Default empty list for share
    this.industry = '',
    this.category = '',
    this.attribute = '',
    this.turningrate = '',
    this.products = const [], // Default empty list for products
  });

  // copyWith method to create a copy with updated values
  SectionData copyWith({
    String? projectName,
    String? owner,
    Map<String, String>? collaborator, // Accept single collaborator
    List<Map<String, String>>? share,
    String? industry,
    String? category,
    String? attribute,
    String? turningrate,
    List<Product>? products, // Accept multiple products
  }) {
    return SectionData(
      projectName: projectName ?? this.projectName,
      owner: owner ?? this.owner,
      collaborator: collaborator ?? this.collaborator,
      share: share ?? this.share,
      industry: industry ?? this.industry,
      category: category ?? this.category,
      attribute: attribute ?? this.attribute,
      turningrate: turningrate ?? this.turningrate,
      products: products ?? this.products, // Use multiple products
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

class TurningRate {
  String condition;
  String explaination;
  String detail;

  TurningRate({
    required this.condition,
    required this.explaination,
    required this.detail,
  });

  @override
  String toString() {
    return 'Product(name: $condition, usageAmount: $explaination, date: $detail)';
  }
}
