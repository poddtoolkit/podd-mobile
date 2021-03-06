part of opensurveillance_form;

class DecimalField extends PrimitiveField<Decimal> {
  DecimalField(
    String id,
    String name, {
    String? label,
    String? description,
    String? suffixLabel,
    bool? required,
    String? requiredMessage,
    Condition? condition,
  }) : super(id, name,
            label: label,
            description: description,
            suffixLabel: suffixLabel,
            required: required,
            requiredMessage: requiredMessage,
            condition: condition);

  factory DecimalField.fromJson(Map<String, dynamic> json) {
    var condition = parseConditionFromJson(json);

    return DecimalField(
      json["id"],
      json["name"],
      label: json["label"],
      description: json["description"],
      suffixLabel: json["suffixLabel"],
      required: json["required"],
      requiredMessage: json["requiredMessage"],
      condition: condition,
    );
  }

  @override
  bool _validate() {
    return runInAction(() {
      clearError();
      var validateFns = ilist([_validateRequired]);
      return validateFns.all((fn) => fn());
    });
  }

  @override
  bool evaluate(ConditionOperator operator, String targetValue) {
    switch (operator) {
      case ConditionOperator.equal:
        return value == Decimal.parse(targetValue);
      case ConditionOperator.contain:
        return value?.toString().contains(targetValue) ?? false;
      default:
        return false;
    }
  }

  @override
  void loadJsonValue(Map<String, dynamic> json) {
    if (json[name] != null) {
      value = Decimal.parse(json[name]);
    }
  }

  @override
  void toJsonValue(Map<String, dynamic> aggregateResult) {
    aggregateResult[name] = value?.toStringAsFixed(2);
  }
}
