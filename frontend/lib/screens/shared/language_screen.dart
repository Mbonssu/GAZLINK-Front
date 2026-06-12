import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'fr';

  final List<Map<String, String>> _languages = [
    {'code': 'fr', 'name': 'Français', 'nativeName': 'Français'},
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Langue'),
      ),
      body: ListView(
        padding: GlassConstants.pagePadding,
        children: _languages.map((language) {
          final isSelected = _selectedLanguage == language['code'];
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            onTap: () {
              setState(() => _selectedLanguage = language['code']!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Langue changée en ${language['name']}'),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? GlassConstants.accent.withValues(alpha: 0.2)
                        : GlassConstants.mutedColor(brightness)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      language['code']!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? GlassConstants.accent
                            : GlassConstants.mutedColor(brightness),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language['name']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      Text(
                        language['nativeName']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: GlassConstants.mutedColor(brightness),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: GlassConstants.accent,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
