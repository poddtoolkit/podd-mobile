part of opensurveillance_form;

class DateField extends Field {
  final Observable<int?> _day = Observable(null);
  final Observable<int?> _month = Observable(null);
  final Observable<int?> _year = Observable(null);
  final Observable<int?> _hour = Observable(null);
  final Observable<int?> _minute = Observable(null);

  bool withTime = false;

  DateField(
    String id,
    String name, {
    String? label,
    String? description,
    String? suffixLabel,
    bool? required,
    String? requiredMessage,
    this.withTime = false,
    Condition? condition,
  }) : super(id, name,
            label: label,
            description: description,
            suffixLabel: suffixLabel,
            required: required,
            requiredMessage: requiredMessage,
            condition: condition);

  factory DateField.fromJson(Map<String, dynamic> json) {
    var condition = parseConditionFromJson(json);

    return DateField(
      json["id"],
      json["name"],
      label: json["label"],
      description: json["description"],
      suffixLabel: json["suffixLabel"],
      required: json["required"],
      requiredMessage: json["requiredMessage"],
      withTime: json["withTime"] ?? false,
      condition: condition,
    );
  }

  @override
  DateTime? get value {
    if (_year.value == null ||
        _month.value == null ||
        _day.value == null ||
        (withTime && _hour.value == null && _minute.value == null)) {
      return null;
    }

    if (withTime) {
      return DateTime(_year.value!, _month.value!, _day.value!, _hour.value!,
          _minute.value!);
    } else {
      return DateTime(_year.value!, _month.value!, _day.value!);
    }
  }

  set value(DateTime? v) {
    if (v != null) {
      runInAction(() {
        _day.value = v.day;
        _month.value = v.month;
        _year.value = v.year;
        if (withTime) {
          _hour.value = v.hour;
          _minute.value = v.minute;
        }
      });
    }
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
        return value?.toIso8601String() == targetValue;
      case ConditionOperator.contain:
        return value?.toIso8601String().contains(targetValue) ?? false;
      default:
        return false;
    }
  }

  @override
  void loadJsonValue(Map<String, dynamic> json) {
    if (json[name] != null) {
      var givenDate = DateTime.parse(json[name]);
      value = givenDate;
    }
  }

  @override
  void toJsonValue(Map<String, dynamic> aggregateResult) {
    aggregateResult[name] = value?.toIso8601String();
  }
}
