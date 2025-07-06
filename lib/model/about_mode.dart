// lib/models/policy_terms_model.dart
class About {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  About({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class AboutResponse {
  final bool success;
  final List<About> data;

  AboutResponse({
    required this.success,
    required this.data,
  });

  factory AboutResponse.fromJson(Map<String, dynamic> json) {
    return AboutResponse(
      success: json['success'] as bool,
      data: (json['data'] as List)
          .map((item) => About.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}