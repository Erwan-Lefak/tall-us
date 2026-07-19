import 'package:equatable/equatable.dart';

/// Email template entity for admin management
class EmailTemplateEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String subject;
  final String bodyHtml;
  final String? bodyText;
  final List<String> variables;
  final bool isSystem;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const EmailTemplateEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.subject,
    required this.bodyHtml,
    this.bodyText,
    this.variables = const [],
    this.isSystem = false,
    required this.createdAt,
    this.updatedAt,
  });

  EmailTemplateEntity copyWith({
    String? name,
    String? subject,
    String? bodyHtml,
    String? bodyText,
    List<String>? variables,
  }) {
    return EmailTemplateEntity(
      id: id,
      name: name ?? this.name,
      slug: slug,
      subject: subject ?? this.subject,
      bodyHtml: bodyHtml ?? this.bodyHtml,
      bodyText: bodyText ?? this.bodyText,
      variables: variables ?? this.variables,
      isSystem: isSystem,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id, name, slug, subject, bodyHtml, bodyText, variables,
        isSystem, createdAt, updatedAt,
      ];
}
