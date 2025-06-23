import 'package:html/dom.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/parser.dart' as html_parser;

class HtmlConversion{

  static String parseHtmlString(String htmlString) {
    final document = htmlParser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString;
  }

  static String extractReadableText(String htmlString) {
    Document doc = html_parser.parse(htmlString);
    doc.querySelectorAll('script, style, ins, .adsbygoogle, div[id^="SC_TBlock"], div[id^="oneindia_widget_container"]')
        .forEach((e) => e.remove());
    String rawText = doc.body?.text ?? '';
    String cleanedText = rawText
        .replaceAll(RegExp(r'=>'), '')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .replaceAll(RegExp(r'\n\s*\n'), '\n')
        .replaceAll('\u00a0', ' ')
        .trim();
    return cleanedText;
  }


}