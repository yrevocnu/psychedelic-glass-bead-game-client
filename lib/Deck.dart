class Deck {
  final String name;
  final String description;

  Deck({this.name, this.description});

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(name: json['name'], description: json['description']);
  }
}
