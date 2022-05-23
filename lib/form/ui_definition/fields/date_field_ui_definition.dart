import 'field_ui_definition.dart';

class DateFieldUIDefinition extends FieldUIDefinition {
  DateFieldUIDefinition({
    required id,
    required name,
    label,
    description,
    suffixLabel,
    required,
  }) : super(
          id: id,
          name: name,
          label: label,
          description: description,
          suffixLabel: suffixLabel,
          required: required,
        );
  factory DateFieldUIDefinition.fromJson(Map<String, dynamic> json) {
    return DateFieldUIDefinition(
      id: json['id'],
      name: json['name'],
      label: json['label'],
      description: json['description'],
      suffixLabel: json['suffixLabel'],
      required: json['required'],
    );
  }
}