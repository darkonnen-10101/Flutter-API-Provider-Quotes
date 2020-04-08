class DataQuote {
  String content;
  Originator originator;

  DataQuote({
    this.content,
    this.originator,
  });

  factory DataQuote.fromJson(Map<String, dynamic> parsedJson) {
    return DataQuote(
      content: parsedJson['content'],
      originator: Originator.fromJson(parsedJson['originator']),
    );
  }
}

class Originator {
  String name;

  Originator({this.name});

  factory Originator.fromJson(Map<String, dynamic> json) {
    return Originator(
      name: json['name'],
    );
  }
}
