class Field {
  final FieldType type;
  final String content;

  Field({required this.type, required this.content});
}

enum FieldType {
  Username,
  Password,
  Website,
  Email,
  Number,
  Pin,
  Date,
  Text,
  MultilineText
}
