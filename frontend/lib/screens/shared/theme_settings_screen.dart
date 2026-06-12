import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  String _selectedTheme = 'system';

  final List<Map<String, dynamic>> _themes = [
    {
      'id': 'light',
      'name': 'Clair',
      'description': 'Thème clair pour une meilleure visibilité',
      'icon': Icons.light_mode,
    },
    {
      'id': 'dark',
      'name': 'Sombre',
      'description': 'Thème sombre pour réduire la fatigue oculaire',
      'icon': Icons.dark_mode,
    },
    {
      'id': 'system',
      'name': 'Système',
      'description': 'Suivre les paramètres de votre appareil',
      'icon': Icons.settings_suggest,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Thème'),
      ),
      body: ListView(
        padding: GlassConstants.pagePadding,
        children: _themes.map((theme) {
          final isSelected = _selectedTheme == theme['id'];
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            onTap: () {
              setState(() => _selectedTheme = theme['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thème changé en ${theme['name']}'),
                ),
              );
            },
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? GlassConstants.accent.withValues(alpha: 0.2)
                        : GlassConstants.mutedColor(brightness)
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    theme['icon'],
                    color: isSelected
                        ? GlassConstants.accent
                        : GlassConstants.mutedColor(brightness),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theme['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        theme['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: GlassConstants.mutedColor(brightness),
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: theme['id'],
                  groupValue: _selectedTheme,
                  onChanged: (value) {
                    setState(() => _selectedTheme = value!);
                  },
                  activeColor: GlassConstants.accent,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
