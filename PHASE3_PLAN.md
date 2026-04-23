# 🧪 Phase 3 - Repository & Provider Tests - Plan Détaillé

## 📋 Vue d'Ensemble

Phase 3 vise à tester la couche données (repositories) et la couche présentation (providers) pour assurer une intégration parfaite avec Appwrite et une gestion d'état robuste.

---

## 🎯 Objectifs de Phase 3

1. **Repository Tests** - Tester l'intégration avec Appwrite
2. **Provider Tests** - Tester la gestion d'état Riverpod
3. **Widget Tests** - Tester les composants UI
4. **Qualité** - Mocking, error handling, edge cases

---

## ✅ Tâches Planifiées

### 3.1 Repository Tests (Priorité: HAUTE)

#### Social Repository Tests
- [ ] `test/features/social/data/repositories/social_repository_test.dart`
  - Test création événement social
  - Test jointure événement
  - Test création groupe social
  - Test jointure groupe
  - Test récupération amis d'amis
  - Test permissions et erreurs Appwrite
  - Test retry logic

#### Discovery Extended Repository Tests
- [ ] `test/features/discovery/data/repositories/discovery_extended_repository_test.dart`
  - Test enregistrement like
  - Test enregistrement super like
  - Test récupération "who liked me"
  - Test calcul algorithme Top Picks
  - Test mise à jour metadata photo
  - Test cache et optimisations

#### Message Repository Tests
- [ ] `test/features/message/data/repositories/rich_message_repository_test.dart`
  - Test envoi messages (text, image, GIF, audio, vidéo, location)
  - Test réactions emoji
  - Test marquer comme vu
  - Test abonnements realtime
  - Test pagination messages

---

### 3.2 Provider Tests (Priorité: HAUTE)

#### Social Providers Tests
- [ ] `test/features/social/presentation/providers/social_providers_test.dart`
  - Test EventsNotifier states (initial, loading, loaded, error)
  - Test GroupsNotifier states
  - Test FriendsOfFriendsNotifier states
  - Test DoubleDateNotifier states
  - Test refresh logic
  - Test error recovery

#### Discovery Extended Providers Tests
- [ ] `test/features/discovery/presentation/providers/discovery_extended_providers_test.dart`
  - Test WhoLikesYouNotifier states
  - Test TopPicksNotifier (algorithme de scoring)
  - Test PremiumStatusNotifier
  - Test feature gates

#### Message Providers Tests
- [ ] `test/features/message/presentation/providers/message_providers_test.dart`
  - Test MessagesNotifier states
  - Test ConversationMetadataNotifier
  - Test RealtimeSubscriptionNotifier

---

### 3.3 Widget Tests (Priorité: MOYENNE)

#### Discovery Widgets Tests
- [ ] `test/features/discovery/presentation/widgets/top_picks_widget_test.dart`
  - Test affichage top picks
  - Test interactions (like, super like)
  - Test états vide/erreur
  - Test pagination

#### Social Widgets Tests
- [ ] `test/features/social/presentation/widgets/social_features_widget_test.dart`
  - Test affichage events
  - Test affichage groups
  - Test affichage friends of friends

#### Verification Widgets Tests
- [ ] `test/features/verification/presentation/widgets/height_verification_widget_test.dart`
  - Test upload photo
  - Test validation
  - Test états

---

### 3.4 Mocking & Fixtures (Priorité: HAUTE)

#### Appwrite Mocks
- [ ] `test/mocks/appwrite_mocks.dart`
  - Mock Databases
  - Mock Realtime
  - Mock Storage
  - Mock Functions

#### Test Fixtures
- [ ] `test/fixtures/profile_fixtures.dart`
  - Profils de test
  - Données variées
  - Edge cases

---

## 🔧 Outils de Testing

### Dépendances Ajoutées
```yaml
dev_dependencies:
  mockito: ^5.4.0
  mocktail: ^1.0.0
  build_runner: ^2.4.0
```

### Structure de Test
```
test/
├── mocks/
│   ├── appwrite_mocks.dart
│   └── repository_mocks.dart
├── fixtures/
│   ├── profile_fixtures.dart
│   └── message_fixtures.dart
├── features/
│   ├── social/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── social_repository_test.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── social_providers_test.dart
│   ├── discovery/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── discovery_extended_repository_test.dart
│   │   └── presentation/
│   │       └── providers/
│   │           └── discovery_extended_providers_test.dart
│   └── message/
│       ├── data/
│       │   └── repositories/
│       │       └── rich_message_repository_test.dart
│       └── presentation/
│           └── providers/
│               └── message_providers_test.dart
└── integration/
    ├── auth_flow_test.dart
    ├── swipe_flow_test.dart
    └── messaging_flow_test.dart
```

---

## 📊 Métriques de Succès

- ✅ 80%+ couverture repositories
- ✅ 70%+ couverture providers
- ✅ 50%+ couverture widgets
- ✅ Tous les flux critiques testés
- ✅ Error handling testé

---

## 🎯 Ordre de Priorité

1. **Mocking & Fixtures** - Fondation nécessaire
2. **Repository Tests** - Couche données critique
3. **Provider Tests** - Gestion d'état
4. **Widget Tests** - UI testing
5. **Integration Tests** - Flux complets
