class IndustryData {
  final String industry;
  final List<CategoryData> categories;

  IndustryData({required this.industry, required this.categories});
}

class CategoryData {
  final String category;
  final List<AttributeData> attributes;

  CategoryData({required this.category, required this.attributes});
}

class AttributeData {
  final String attribute;
  final List<DynamicField> dynamicFields;

  AttributeData({required this.attribute, required this.dynamicFields});
}

class DynamicField {
  final String fieldName;
  final String fieldType;
  final List<String>?
      options; // If the field has options, like a dropdown list.

  DynamicField(
      {required this.fieldName, required this.fieldType, this.options});
}

// Example Data
final industries = [
  IndustryData(
    industry: 'Technology',
    categories: [
      CategoryData(
        category: 'Software',
        attributes: [
          AttributeData(
            attribute: 'Programming Language',
            dynamicFields: [
              DynamicField(
                  fieldName: 'Language Type',
                  fieldType: 'dropdown',
                  options: ['Compiled', 'Interpreted']),
              DynamicField(
                  fieldName: 'Preferred IDE', fieldType: 'text', options: null),
            ],
          ),
          AttributeData(
            attribute: 'Framework',
            dynamicFields: [
              DynamicField(
                  fieldName: 'Framework Name',
                  fieldType: 'text',
                  options: null),
              DynamicField(
                  fieldName: 'Version', fieldType: 'text', options: null),
            ],
          ),
        ],
      ),
      CategoryData(
        category: 'Hardware',
        attributes: [
          AttributeData(
            attribute: 'Processor Type',
            dynamicFields: [
              DynamicField(
                  fieldName: 'Processor Brand',
                  fieldType: 'text',
                  options: null),
              DynamicField(
                  fieldName: 'Core Count', fieldType: 'text', options: null),
            ],
          ),
        ],
      ),
    ],
  ),
  IndustryData(
    industry: 'Healthcare',
    categories: [
      CategoryData(
        category: 'Medical Equipment',
        attributes: [
          AttributeData(
            attribute: 'Device Type',
            dynamicFields: [
              DynamicField(
                  fieldName: 'Device Model', fieldType: 'text', options: null),
              DynamicField(
                  fieldName: 'Manufacturer', fieldType: 'text', options: null),
            ],
          ),
        ],
      ),
      CategoryData(
        category: 'Pharmaceuticals',
        attributes: [
          AttributeData(
            attribute: 'Drug Category',
            dynamicFields: [
              DynamicField(
                  fieldName: 'Drug Name', fieldType: 'text', options: null),
              DynamicField(
                  fieldName: 'Dosage', fieldType: 'text', options: null),
            ],
          ),
        ],
      ),
    ],
  ),
];
