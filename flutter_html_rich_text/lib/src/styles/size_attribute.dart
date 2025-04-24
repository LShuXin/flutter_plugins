const double em2pxFactor = 16.0;
const double defaultFontSize = 14.0;

class DeviceAttribute {
  static double screenWidth = 0.0;
  static double devicePixelRatio = 1.0;
}

class SizeAttribute {
  SizeAttribute(
    this._attribute,
  ) {
    if (_attribute.contains('%')) {
      _factor = (double.tryParse(_attribute.substring(0, _attribute.length-1)) ?? 0) / 100.0;
    } else if (_attribute.contains('em')) {
      _value = (double.tryParse(_attribute.substring(0, _attribute.length-2)) ?? 0) * em2pxFactor;
    } else if (_attribute.contains('px')) {
      _value = double.tryParse(_attribute.substring(0, _attribute.indexOf('px')))!;
    } else {
      _value = double.tryParse(_attribute)!;
    }
  }

  double get imgValue => _value;
  double get imgFactor => _factor;
  double get fontStyleValue => _value ?? (_factor * defaultFontSize);
  
  late double _value;
  double _factor = 1.0;
  final String _attribute;
}