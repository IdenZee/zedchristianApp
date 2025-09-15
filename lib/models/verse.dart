class Verse {
  final String id;
  final String text;
  final String reference;

  Verse({
    required this.id,
    required this.text,
    required this.reference,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: (json['id'] ?? '').toString(),
      text: (json['verse_text'] ?? json['text'] ?? '').toString(),
      reference: (json['reference'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'verse_text': text,   // use verse_text for DB
    'reference': reference,
  };
}
