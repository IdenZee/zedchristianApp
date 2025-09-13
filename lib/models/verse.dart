class Verse {
  final String id;
  final String text;
  final String reference;

  Verse({required this.id, required this.text, required this.reference});

  factory Verse.fromJson(Map<String, dynamic> j) => Verse(
    id: j['id'],
    text: j['text'],
    reference: j['reference'],
  );

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'reference': reference};
}
