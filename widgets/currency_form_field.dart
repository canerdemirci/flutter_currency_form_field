import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:./widgets/currency_form_field/helper.dart';

class CurrencyFormField extends TextFormField {
  final double? initialAmount;
  final Function(double) onChangedAmount;
  final String? Function(double?)? validateAmount;

  CurrencyFormField({
    super.key,
    required this.onChangedAmount,
    this.validateAmount,
    this.initialAmount = 0,
    super.autofocus,
    super.style,
  }) : super(
            decoration: const InputDecoration(
              suffix: Text('₺'),
            ),
            initialValue: currencyFormattedText('$initialAmount'),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            inputFormatters: [CurrencyInputFormatter()],
            onChanged: (value) {
              onChangedAmount(currencyToDouble(value));
            },
            validator: validateAmount == null
                ? null
                : (value) {
                    return value == null
                        ? validateAmount(null)
                        : validateAmount(currencyToDouble(value));
                  });
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var selection = newValue.selection;

    if (newValue.text.isNotEmpty) {
      var formattedText = currencyFormattedText(newValue.text);
      // Move cursor right when the point is made.
      var pointCount = formattedText.split('').where((e) => e == '.').length;
      var oldPointCount = oldValue.text.split('').where((e) => e == '.').length;
      if (pointCount > oldPointCount) {
        selection = TextSelection.collapsed(offset: selection.end + 1);
      }
      // Select zero if there's only zero left of the comma
      if ((selection.end == 0 || selection.end == 1) &&
          formattedText[0] == '0') {
        selection = const TextSelection(baseOffset: 0, extentOffset: 1);
      }
      return TextEditingValue(
        text: formattedText,
        selection: selection,
      );
    }

    return newValue;
  }
}
