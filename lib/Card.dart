class Card {
  final String name;
  final String description;
  final String image;
  final String suit;

  Card({this.name, this.description, this.image, this.suit});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
        name: json['name'],
        description: json['description'],
        image: json['image'],
        suit: json['suit']);
  }
}
