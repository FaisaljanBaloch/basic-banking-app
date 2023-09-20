class Validator {
  String? amountField(String? value) {
    if (value == null || value.isEmpty) {
      return "* amount field is required";
    } else if (int.parse(value) <= 0) {
      return "* amount must be minimum \$1";
    } else {
      return null;
    }
  }
}
