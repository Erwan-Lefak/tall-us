import 'package:equatable/equatable.dart';

/// Entity representing a user's answer to a prompt
class UserPrompt extends Equatable {
  final String promptId;
  final String promptText;
  final String answer;
  final int displayOrder; // Order to display on profile

  const UserPrompt({
    required this.promptId,
    required this.promptText,
    required this.answer,
    this.displayOrder = 0,
  });

  UserPrompt copyWith({
    String? promptId,
    String? promptText,
    String? answer,
    int? displayOrder,
  }) {
    return UserPrompt(
      promptId: promptId ?? this.promptId,
      promptText: promptText ?? this.promptText,
      answer: answer ?? this.answer,
      displayOrder: displayOrder ?? this.displayOrder,
    );
  }

  @override
  List<Object?> get props => [promptId, promptText, answer, displayOrder];
}

/// Entity representing a tall-specific conversation prompt
class PromptEntity extends Equatable {
  final String id;
  final String text;
  final String category;
  final int popularity;

  const PromptEntity({
    required this.id,
    required this.text,
    required this.category,
    this.popularity = 0,
  });

  @override
  List<Object?> get props => [id, text, category, popularity];
}

/// Predefined tall-specific prompts for Tall Us
class TallPrompts {
  static const List<PromptEntity> allPrompts = [
    // Height Experience Prompts
    PromptEntity(
      id: 'height_stories_high',
      text: 'Ma meilleure histoire de grande personne :',
      category: 'height_experience',
      popularity: 95,
    ),
    PromptEntity(
      id: 'height_stories_funny',
      text: 'Un moment drôle lié à ma taille :',
      category: 'height_experience',
      popularity: 92,
    ),
    PromptEntity(
      id: 'height_advantage',
      text: 'Ce que j\'aime le plus d\'être grand(e) :',
      category: 'height_experience',
      popularity: 88,
    ),
    PromptEntity(
      id: 'height_challenge',
      text: 'Le plus grand défi d\'être grand(e) au quotidien :',
      category: 'height_experience',
      popularity: 85,
    ),

    // Dating & Relationships
    PromptEntity(
      id: 'dating_preference',
      text: 'Je cherche quelqu\'un qui me voit...',
      category: 'dating',
      popularity: 97,
    ),
    PromptEntity(
      id: 'dating_height_matter',
      text: 'Est-ce que la taille compte vraiment ?',
      category: 'dating',
      popularity: 90,
    ),
    PromptEntity(
      id: 'dating_perfect_match',
      text: 'Mon/ma partenaire idéal(e) mesure...',
      category: 'dating',
      popularity: 93,
    ),
    PromptEntity(
      id: 'dating_heels',
      text: 'Talons hauts ou baskets ?',
      category: 'dating',
      popularity: 87,
    ),

    // Lifestyle & Interests
    PromptEntity(
      id: 'lifestyle_sports',
      text: 'Mon sport préféré (avantage de la taille !) :',
      category: 'lifestyle',
      popularity: 82,
    ),
    PromptEntity(
      id: 'lifestyle_clothing',
      text: 'Où j\'achète mes vêtements :',
      category: 'lifestyle',
      popularity: 78,
    ),
    PromptEntity(
      id: 'lifestyle_travel',
      text: 'Les avantages/inconvénients d\'être grand(e) en avion :',
      category: 'lifestyle',
      popularity: 75,
    ),

    // Personality & Fun
    PromptEntity(
      id: 'personality_perk',
      text: 'Un avantage inattendu d\'être grand(e) :',
      category: 'personality',
      popularity: 91,
    ),
    PromptEntity(
      id: 'personality_compliment',
      text: 'Le meilleur compliment sur ma taille :',
      category: 'personality',
      popularity: 86,
    ),
    PromptEntity(
      id: 'personality_confidence',
      text: 'Ce qui me donne confiance :',
      category: 'personality',
      popularity: 89,
    ),
  ];

  /// Get prompts by category
  static List<PromptEntity> getByCategory(String category) {
    return allPrompts.where((p) => p.category == category).toList();
  }

  /// Get most popular prompts
  static List<PromptEntity> getPopular({int limit = 6}) {
    final sorted = List<PromptEntity>.from(allPrompts);
    sorted.sort((a, b) => b.popularity.compareTo(a.popularity));
    return sorted.take(limit).toList();
  }

  /// Get random prompts
  static List<PromptEntity> getRandom({int count = 3}) {
    final shuffled = List<PromptEntity>.from(allPrompts)..shuffle();
    return shuffled.take(count).toList();
  }
}
