// lib/models/policy_terms_model.dart
class PolicyTerms {
  final String id;
  final String title;
  final String content;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  PolicyTerms({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PolicyTerms.fromJson(Map<String, dynamic> json) {
    return PolicyTerms(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}