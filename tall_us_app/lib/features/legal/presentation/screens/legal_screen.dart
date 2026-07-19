import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tall_us/core/theme/app_theme.dart';

/// A single section in a legal document.
class LegalSection {
  final String heading;
  final String body;
  const LegalSection(this.heading, this.body);
}

/// Reusable legal page (CGU / Privacy). Takes a title and ordered sections.
class LegalScreen extends StatelessWidget {
  final String title;
  final String intro;
  final List<LegalSection> sections;
  final String footer;
  const LegalScreen({
    super.key,
    required this.title,
    required this.intro,
    required this.sections,
    required this.footer,
  });

  /// CGU — Conditions Générales d'Utilisation.
  factory LegalScreen.terms() => const LegalScreen(
        title: "Conditions Générales d'Utilisation",
        intro:
            "Les présentes conditions régissent l'utilisation de l'application Tall Us (la « plateforme »), éditée par Tall Us (Micro-Entreprise, Chilly-Mazarin, France). En créant un compte, vous acceptez les présentes conditions.",
        footer:
            "Tall Us se réserve le droit de modifier les présentes conditions. La version applicable est celle en ligne à la date d'utilisation.",
        sections: [
          LegalSection('1. Objet',
              "Tall Us est une plateforme de rencontres en ligne destinée aux personnes de grande taille, favorisant les relations sérieuses et bienveillantes."),
          LegalSection("2. Inscription et compte",
              "L'inscription est réservée aux personnes majeures. Vous vous engagez à fournir des informations exactes (identité, taille, âge, localisation). La vérification de la taille peut être demandée. Tout compte frauduleux, usurpé ou contraire aux présentes conditions peut être suspendu sans préavis."),
          LegalSection("3. Vérification de la taille",
              "Pour garantir la confiance, Tall Us propose une vérification de la taille. Les données transmises à cet effet (photo de vérification) sont examinées par notre équipe et ne sont pas rendues publiques."),
          LegalSection("4. Abonnements",
              "Tall Us propose des forfaits gratuits et payants (Freemium, Tall, Élite, Légende). Les tarifs et avantages sont affichés dans l'application. Les paiements, lorsqu'ils seront activés, seront traités par notre prestataire de paiement. Un forfait payant reste actif jusqu'à résiliation."),
          LegalSection("5. Contenu et comportement",
              "Vous vous engagez à publier un contenu respectueux, conforme au droit et ne portant pas atteinte à autrui. Tout harcèlement, discours haineux, falsification de la taille ou comportement abusif entraîne la suppression du compte."),
          LegalSection("6. Données personnelles",
              "Le traitement de vos données est décrit dans notre Politique de confidentialité (RGPD), partie intégrante des présentes conditions."),
          LegalSection("7. Responsabilité",
              "Tall Us met tout en œuvre pour assurer le bon fonctionnement de la plateforme mais ne garantit pas une rencontre ou un résultat. La responsabilité de Tall Us ne peut être engagée pour les interactions entre utilisateurs."),
          LegalSection("8. Suppression du compte",
              "Vous pouvez demander la suppression de votre compte et de vos données à tout moment depuis l'application ou par contact."),
        ],
      );

  /// Politique de confidentialité (RGPD).
  factory LegalScreen.privacy() => const LegalScreen(
        title: 'Politique de confidentialité (RGPD)',
        intro:
            "Tall Us s'engage à protéger vos données personnelles conformément au Règlement Général sur la Protection des Données (RGPD) et à la loi Informatique et Libertés.",
        footer:
            "Responsable du traitement : Tall Us — 12 Avenue Mazarin, 91380 Chilly-Mazarin. Contact : support@tallus.app",
        sections: [
          LegalSection("1. Données collectées",
              "Identifiants de compte (e-mail), informations de profil (prénom, taille, âge, genre, ville, photos, bio, loisirs, playlist musicale), données de géolocalisation approximative (ville), préférences de découverte, photos de vérification de la taille, et données d'usage (likes, matchs, messages)."),
          LegalSection("2. Finalités",
              "Création et gestion du compte, mise en relation (matching), vérification de la taille, sécurité et prévention des fraudes, envoi de notifications, facturation des abonnements, amélioration du service."),
          LegalSection("3. Base légale",
              "Exécution du contrat (inscription, matching), consentement (notifications, photos de vérification), intérêt légitime (sécurité, modération)."),
          LegalSection("4. Destinataires",
              "Vos données sont traitées par Tall Us et ses prestataires techniques (hébergement, base de données, paiement). Elles ne sont pas vendues à des tiers."),
          LegalSection("5. Durée de conservation",
              "Les données sont conservées tant que votre compte est actif, puis supprimées à votre demande ou après une période d'inactivité, sauf obligation légale."),
          LegalSection("6. Sécurité",
              "Tall Us met en œuvre des mesures techniques et organisationnelles pour protéger vos données (chiffrement, accès restreint)."),
          LegalSection("7. Vos droits",
              "Conformément au RGPD, vous disposez d'un droit d'accès, de rectification, d'effacement, d'opposition et de portabilité de vos données. Pour les exercer, contactez-nous : support@tallus.app."),
          LegalSection("8. Cookies",
              "L'application peut utiliser des stockages locaux nécessaires à son fonctionnement (session, préférences). Aucun cookie publicitaire tiers n'est utilisé."),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.navy),
          onPressed: () => context.pop(),
        ),
        title: Text(title,
            style: const TextStyle(
                color: AppTheme.navy,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.gavel, color: AppTheme.bordeaux, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(intro,
                    style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppTheme.navy.withValues(alpha: 0.8))),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          ...sections.map((s) => _Section(heading: s.heading, body: s.body)),
          const SizedBox(height: 16),
          Text(footer,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12, color: AppTheme.navy.withValues(alpha: 0.5))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String heading;
  final String body;
  const _Section({required this.heading, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.navy)),
          const SizedBox(height: 8),
          Text(body,
              style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: AppTheme.navy.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}
