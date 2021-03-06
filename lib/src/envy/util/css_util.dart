part of envy;

final Map<String, num> convert = {};
bool computedValueBug = false;
final List<num> conversions = [1 / 25.4, 1 / 2.54, 1 / 72, 1 / 6];
String runit = r"/^(-?[\d+\.\-]+)([a-z]+|%)$/i";
Element docElement = document.documentElement;

class CssUtil {
  static void _initAbsoluteUnitConversions() {
    List<String> units = ['mm', 'cm', 'pt', 'pc', 'in', 'mozmm'];

    // create a test element and add to DOM
    Element testElem = document.createElement('test');
    docElement.append(testElem);

    // test for the WebKit getComputedStyle bug
    // @see http://bugs.jquery.com/ticket/10639
    testElem.style.marginTop = '1%';
    computedValueBug = testElem.getComputedStyle().marginTop == '1%';

    // pre-calculate absolute unit conversions
    for (int i = units.length - 1; i >= 0; i--) {
      convert["${units[i]}toPx"] = i < 4 ? conversions[i] * convert["inToPx"] : toPixels(testElem, '1' + units[i]);
    }

    // remove the test element from the DOM and delete it
    testElem.remove();
    testElem = null;
  }

  /// Convert a [value] to pixels.
  ///
  /// Uses width as the property when checking computed style by default.
  ///
  static num toPixels(Element element, String value, [String prop = 'width', bool force = false]) {
    var style, pixels;

    // Init conversion values if first time
    if (convert.isEmpty) CssUtil._initAbsoluteUnitConversions();

    // If no element is provided, create a test element and add to DOM
    Element elem = element;
    bool dummyElement = false;
    if (elem == null) {
      elem = document.createElement('test');
      docElement.append(elem);
      dummyElement = true;
    }

    List<Match> matches = new List.from(runit.allMatches(value));
    String unit = matches.isNotEmpty ? matches.first.group(0)[2] : "";
    //String unit = (value.match(runit)||[])[2],
    num conversion = (unit == 'px') ? 1 : convert['${unit}toPx'];

    if (conversion != null) {
      // multiply the value by the conversion
      pixels = _parsePixels(value) * conversion;
    } else if ((unit == "em" || unit == "rem") && !force) {
      // use the correct element for rem or fontSize + em or em
      elem = (unit == 'rem') ? docElement : (prop == 'font-size') ? (elem.parent != null ? elem.parent : elem) : elem;

      // use fontSize of the element for rem and em
      conversion = _parsePixels(CssUtil.curCSS(elem, 'font-size'));

      // multiply the value by the conversion
      pixels = num.parse(value) * conversion;
    } else {
      // remember the current style
      style = elem.style;
      String inlineValue = style.getPropertyValue(prop);

      // set the style on the target element
      try {
        style.setProperty(prop, value);
      } catch (e) {
        // IE 8 and below throw an exception when setting unsupported units
        return 0;
      }

      // read the computed value
      // if style is nothing we probably set an unsupported unit
      String computedValue = style.getPropertyValue(prop);
      pixels = (computedValue == null || computedValue.isEmpty) ? 0 : _parsePixels(curCSS(elem, prop));

      // reset the style back to what it was or blank it out
      style.setProperty(prop, inlineValue);
    }

    // Remove dummy elememt
    if (dummyElement) {
      elem.remove();
      elem = null;
    }

    // return a number
    return pixels;
  }

  static num _parsePixels(String pxCss) {
    try {
      if (pxCss.endsWith("px")) {
        return num.parse(pxCss.substring(0, pxCss.length - 2));
      } else {
        return num.parse(pxCss);
      }
    } catch (e, s) {
      _LOG.severe("Unable to parse pixel value: ${pxCss}", e, s);
      return 0;
    }
  }

  /// Return the computed value of a CSS [prop]erty.
  ///
  static String curCSS(Element elem, String prop) {
    var unit;
    String rvpos = r"/^top|bottom/";
    List<String> outerProp = ["paddingTop", "paddingBottom", "borderTop", "borderBottom"];
    var innerHeight;
    //int i = 4; // outerProp.length

    // Init computedValuesBug flag if first time
    if (convert.isEmpty) CssUtil._initAbsoluteUnitConversions();

    // FireFox, Chrome/Safari, Opera and IE9+
    String value = elem.getComputedStyle().getPropertyValue(prop);

    // check the unit
    List<Match> matches = new List.from(runit.allMatches(value));
    unit = matches.isNotEmpty ? matches.first.group(0) : "";
    if (unit == '%' && computedValueBug) {
      // WebKit won't convert percentages for top, bottom, left, right, margin and text-indent
      if (prop.contains(rvpos)) {
        // Top and bottom require measuring the innerHeight of the parent.
        Element parent = elem.parentNode ?? elem;
        innerHeight = parent.offsetHeight;
        //while (i--) {
        for (int i = outerProp.length - 1; i >= 0; i--) {
          innerHeight -= _parsePixels(curCSS(parent, outerProp[i]));
        }
        value = "${_parsePixels(value) / 100 * innerHeight}px";
      } else {
        // This fixes margin, left, right and text-indent
        // @see https://bugs.webkit.org/show_bug.cgi?id=29084
        // @see http://bugs.jquery.com/ticket/10639
        value = "${toPixels(elem, value)}px";
      }
    } else if ((value == 'auto' || (unit != null && unit != 'px'))) {
      // WebKit and Opera will return auto in some cases
      // Firefox will pass back an unaltered value when it can't be set, like top on a static element
      value = "0";
    }
    return value;
  }
}
