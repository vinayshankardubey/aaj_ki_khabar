import 'package:html/parser.dart' as htmlParser;

class HtmlConversion{

  static String parseHtmlString(String htmlString) {
    final document = htmlParser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString;
  }
}