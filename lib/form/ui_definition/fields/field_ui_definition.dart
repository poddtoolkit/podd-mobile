import 'package:podd_app/form/ui_definition/condition_definition.dart';
import 'package:podd_app/form/ui_definition/form_ui_definition.dart';

export 'integer_field_ui_definition.dart';
export 'text_field_ui_definition.dart';
export 'location_field_ui_definition.dart';
export 'images_field_ui_definition.dart';
export 'multiple_choice_field_ui_definition.dart';
export 'single_choice_field_ui_definition.dart';
export 'table_field_ui_definition.dart';
export 'date_field_ui_definition.dart';

abstract class FieldUIDefinition {
  String id;
  String name;
  String? label;
  String? description;
  String? suffixLabel;
  bool? required;
  ConditionDefinition? enableCondition;

  FieldUIDefinition({
    required this.id,
    required this.name,
    this.label,
    this.description,
    this.suffixLabel,
    this.required = false,
    this.enableCondition,
  });

  factory FieldUIDefinition.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'integer':
        return IntegerFieldUIDefinition.fromJson(json);
      case 'location':
        return LocationFieldUIDefinition.fromJson(json);
      case 'images':
        return ImagesFieldUIDefinition.fromJson(json);
      case 'date':
        return DateFieldUIDefinition.fromJson(json);
      case 'singlechoices':
        return SingleChoicesFieldUIDefinition.fromJson(json);
      case "multiplechoices":
        return MultipleChoicesFieldUIDefinition.fromJson(json);
      case 'text':
      default:
        return TextFieldUIDefinition.fromJson(json);
    }
  }
}
