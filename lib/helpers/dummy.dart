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

final industryData = [
  {
    "id": 3,
    "name": "Plant식물",
    "hierarchy": ["Plant식물"],
    "subcategories": [
      {
        "id": 6,
        "name": "Tree나무",
        "hierarchy": ["Plant식물", "Tree나무"],
        "subcategories": [
          {
            "id": 12,
            "name": "PineTree소나무",
            "hierarchy": ["Plant식물", "Tree나무", "PineTree소나무"],
            "subcategories": [],
            "conditions": [
              {
                "name": "Condition A",
                "description":
                    "This Condition is the first required Condition of PineTree소나무",
                "required": true
              },
              {
                "name": "Condition B",
                "description":
                    "This Condition is the second required Condition of PineTree소나무",
                "required": true
              },
              {
                "name": "Condition C",
                "description":
                    "This Condition is the third required Condition of PineTree소나무",
                "required": true
              },
              {
                "name": "Condition D",
                "description":
                    "This Condition is the fourth required Condition of PineTree소나무",
                "required": true
              },
              {
                "name": "Condition E",
                "description":
                    "This Condition is the fifth required Condition of PineTree소나무",
                "required": true
              },
              {
                "name": "Condition F",
                "description":
                    "This Condition is the sixth required Condition of PineTree소나무",
                "required": true
              },
              {
                "name": "Condition X",
                "description": "One optional Condition.",
                "required": false
              },
              {
                "name": "Condition Y",
                "description": "Another optional Condition.",
                "required": false
              },
              {
                "name": "Condition Z",
                "description": "One more optional Condition.",
                "required": false
              },
              {
                "name": "Condition 마지막",
                "description": "Two more optional Condition.",
                "required": false
              }
            ],
            "leaf": true
          }
        ],
        "conditions": [],
        "leaf": false
      },
      {
        "id": 7,
        "name": "Flower꽃",
        "hierarchy": ["Plant식물", "Flower꽃"],
        "subcategories": [
          {
            "id": 13,
            "name": "Tulip튤립",
            "hierarchy": ["Plant식물", "Flower꽃", "Tulip튤립"],
            "subcategories": [],
            "conditions": [
              {
                "name": "Condition A",
                "description":
                    "This Condition is the first required Condition of Tulip튤립",
                "required": true
              },
              {
                "name": "Condition B",
                "description":
                    "This Condition is the second required Condition of Tulip튤립",
                "required": true
              },
              {
                "name": "Condition C",
                "description":
                    "This Condition is the third required Condition of Tulip튤립",
                "required": true
              },
              {
                "name": "Condition D",
                "description":
                    "This Condition is the fourth required Condition of Tulip튤립",
                "required": true
              },
              {
                "name": "Condition E",
                "description":
                    "This Condition is the fifth required Condition of Tulip튤립",
                "required": true
              },
              {
                "name": "Condition F",
                "description":
                    "This Condition is the sixth required Condition of Tulip튤립",
                "required": true
              },
              {
                "name": "Condition X",
                "description": "One optional Condition.",
                "required": false
              },
              {
                "name": "Condition Y",
                "description": "Another optional Condition.",
                "required": false
              },
              {
                "name": "Condition Z",
                "description": "One more optional Condition.",
                "required": false
              },
              {
                "name": "Condition 마지막",
                "description": "Two more optional Condition.",
                "required": false
              }
            ],
            "leaf": true
          }
        ],
        "conditions": [],
        "leaf": false
      }
    ],
    "conditions": [],
    "leaf": false
  },
  {
    "id": 2,
    "name": "Animal동물",
    "hierarchy": ["Animal동물"],
    "subcategories": [
      {
        "id": 5,
        "name": "Birds조류",
        "hierarchy": ["Animal동물", "Birds조류"],
        "subcategories": [
          {
            "id": 10,
            "name": "Dove비둘기",
            "hierarchy": ["Animal동물", "Birds조류", "Dove비둘기"],
            "subcategories": [],
            "conditions": [
              {
                "name": "Height",
                "description":
                    "This condition is the first required condition of Dove비둘기",
                "required": true
              },
              {
                "name": "Weight",
                "description":
                    "This condition is the second required condition of Dove비둘기",
                "required": true
              },
              {
                "name": "Age",
                "description":
                    "This condition is the third required condition of Dove비둘기",
                "required": true
              },
              {
                "name": "Name",
                "description": "Name is optional condition.",
                "required": false
              }
            ],
            "leaf": true
          },
          {
            "id": 11,
            "name": "Sparrow참새",
            "hierarchy": ["Animal동물", "Birds조류", "Sparrow참새"],
            "subcategories": [],
            "conditions": [
              {
                "name": "Height",
                "description":
                    "This condition is the first required condition of Sparrow참새",
                "required": true
              },
              {
                "name": "Weight",
                "description":
                    "This condition is the second required condition of Sparrow참새",
                "required": true
              },
              {
                "name": "Age",
                "description":
                    "This condition is the third required condition of Sparrow참새",
                "required": true
              },
              {
                "name": "Name",
                "description": "Name is optional condition.",
                "required": false
              }
            ],
            "leaf": true
          }
        ],
        "conditions": [],
        "leaf": false
      },
      {
        "id": 4,
        "name": "Mammals포유류",
        "hierarchy": ["Animal동물", "Mammals포유류"],
        "subcategories": [
          {
            "id": 8,
            "name": "Dog개",
            "hierarchy": ["Animal동물", "Mammals포유류", "Dog개"],
            "subcategories": [
              {
                "id": 15,
                "name": "Beagle비글",
                "hierarchy": ["Animal동물", "Mammals포유류", "Dog개", "Beagle비글"],
                "subcategories": [],
                "conditions": [
                  {
                    "name": "Height",
                    "description":
                        "This condition is the first required condition of Beagle비글",
                    "required": true
                  },
                  {
                    "name": "Weight",
                    "description":
                        "This condition is the second required condition of Beagle비글",
                    "required": true
                  },
                  {
                    "name": "Age",
                    "description":
                        "This condition is the third required condition of Beagle비글",
                    "required": true
                  },
                  {
                    "name": "Name",
                    "description": "Name is optional condition.",
                    "required": false
                  }
                ],
                "leaf": true
              },
              {
                "id": 14,
                "name": "Bulldog불독",
                "hierarchy": ["Animal동물", "Mammals포유류", "Dog개", "Bulldog불독"],
                "subcategories": [
                  {
                    "id": 16,
                    "name": "AmericanBulldog아메리칸불독",
                    "hierarchy": [
                      "Animal동물",
                      "Mammals포유류",
                      "Dog개",
                      "Bulldog불독",
                      "AmericanBulldog아메리칸불독"
                    ],
                    "subcategories": [],
                    "conditions": [
                      {
                        "name": "Height",
                        "description":
                            "This condition is the first required condition of AmericanBulldog아메리칸불독",
                        "required": true
                      },
                      {
                        "name": "Weight",
                        "description":
                            "This condition is the second required condition of AmericanBulldog아메리칸불독",
                        "required": true
                      },
                      {
                        "name": "Age",
                        "description":
                            "This condition is the third required condition of AmericanBulldog아메리칸불독",
                        "required": true
                      },
                      {
                        "name": "Name",
                        "description": "Name is optional condition.",
                        "required": false
                      }
                    ],
                    "leaf": true
                  },
                  {
                    "id": 17,
                    "name": "FrenchBulldog프렌치불독",
                    "hierarchy": [
                      "Animal동물",
                      "Mammals포유류",
                      "Dog개",
                      "Bulldog불독",
                      "FrenchBulldog프렌치불독"
                    ],
                    "subcategories": [],
                    "conditions": [
                      {
                        "name": "Height",
                        "description":
                            "This condition is the first required condition of FrenchBulldog프렌치불독",
                        "required": true
                      },
                      {
                        "name": "Weight",
                        "description":
                            "This condition is the second required condition of FrenchBulldog프렌치불독",
                        "required": true
                      },
                      {
                        "name": "Age",
                        "description":
                            "This condition is the third required condition of FrenchBulldog프렌치불독",
                        "required": true
                      },
                      {
                        "name": "Name",
                        "description": "Name is optional condition.",
                        "required": false
                      }
                    ],
                    "leaf": true
                  }
                ],
                "conditions": [],
                "leaf": false
              }
            ],
            "conditions": [],
            "leaf": false
          },
          {
            "id": 9,
            "name": "Cat고양이",
            "hierarchy": ["Animal동물", "Mammals포유류", "Cat고양이"],
            "subcategories": [],
            "conditions": [
              {
                "name": "Height",
                "description":
                    "This condition is the first required condition of Cat고양이",
                "required": true
              },
              {
                "name": "Weight",
                "description":
                    "This condition is the second required condition of Cat고양이",
                "required": true
              },
              {
                "name": "Age",
                "description":
                    "This condition is the third required condition of Cat고양이",
                "required": true
              },
              {
                "name": "Name",
                "description": "Name is optional condition.",
                "required": false
              }
            ],
            "leaf": true
          }
        ],
        "conditions": [],
        "leaf": false
      }
    ],
    "conditions": [],
    "leaf": false
  }
];
