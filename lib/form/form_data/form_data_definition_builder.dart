import '../ui_definition/form_ui_definition.dart';
import 'form_data_definition.dart';
import 'form_data_validation.dart';

class FormDataDefinitionBuilder {
  final List<FormDataDefinition> stack = [];

  FormDataDefinitionBuilder() {
    stack.add(FormDataDefinition("root", {}));
  }

  define(String name, BaseDataDefinition definition) {
    stack.last.properties[name] = definition;
  }

  push(String name) {
    stack.add(FormDataDefinition(name, {}));
  }

  FormDataDefinition pop() {
    return stack.removeLast();
  }

  build() {
    return stack.first;
  }
}

parseFormUIDefinition(FormUIDefinition definition) {
  var builder = FormDataDefinitionBuilder();

  _buildField(FieldUIDefinition field) {
    List<ValidationDataDefinition> validations = [];
    if (field.required == true) {
      validations.add(RequiredValidationDefinition());
    }

    if (field is TextFieldUIDefinition) {
      if (field.minLength != null || field.maxLength != null) {
        validations.add(MinMaxLengthValidationDefinition(
            minLength: field.minLength, maxLength: field.maxLength));
      }
      builder.define(
        field.name,
        StringDataDefinition(field.name, validations),
      );
    } else if (field is IntegerFieldUIDefinition) {
      if (field.min != null || field.max != null) {
        validations
            .add(MinMaxValidationDefinition(min: field.min, max: field.max));
      }
      builder.define(
        field.name,
        IntegerDataDefinition(field.name, validations),
      );
    } else if (field is DateFieldUIDefinition) {
      builder.define(
        field.name,
        DateDataDefinition(field.name, validations),
      );
    } else if (field is SingleChoicesFieldUIDefinition) {
      builder.define(
        field.name,
        StringDataDefinition(field.name, validations),
      );
      for (var option in field.options) {
        if (option.input) {
          var name = '${field.name}Text';
          builder.define(
            name,
            StringDataDefinition(name, emptyValidations),
          );
        }
      }
    } else if (field is MultipleChoicesFieldUIDefinition) {
      builder.push(field.name);
      for (var option in field.options) {
        var name = option.value;
        builder.define(name, BooleanDataDefinition(name, validations));
        if (option.input) {
          var nameInput = '${name}Text';
          builder.define(
            nameInput,
            StringDataDefinition(nameInput, emptyValidations),
          );
        }
      }
      var data = builder.pop();
      builder.define(
        field.name,
        FormDataDefinition(field.name, data.properties),
      );
    } else if (field is TableFieldUIDefinition) {
      builder.push(field.name);
      for (var field in field.cols) {
        _buildField(field);
      }
      var data = builder.pop();
      builder.define(
        field.name,
        ArrayDataDefinition(field.name, data),
      );
    } else if (field is LocationFieldUIDefinition) {
      builder.define(
        field.name,
        StringDataDefinition(field.name, validations),
      );
    } else if (field is ImagesFieldUIDefinition) {
      builder.define(
        field.name,
        ImagesDataDefinition(field.name, validations),
      );
    }
  }

  for (var section in definition.sections) {
    for (var question in section.questions) {
      if (question.objectName != null) {
        builder.push(question.objectName!);
      }
      for (var field in question.fields) {
        _buildField(field);
      }
      if (question.objectName != null) {
        var formDataDefinition = builder.pop();
        builder.define(question.objectName!, formDataDefinition);
      }
    }
  }

  return builder.build().properties;
}