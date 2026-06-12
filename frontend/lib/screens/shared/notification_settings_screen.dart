import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _orderUpdates = true;
  bool _deliveryUpdates = true;
  bool _promotions = false;
  bool _newDepots = true;
  bool _priceAlerts = false;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: GlassConstants.pagePadding,
        children: [
          Text(
            'Notifications de commande',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Mises à jour de commande',
            'Recevoir des notifications sur l\'état de vos commandes',
            _orderUpdates,
            (value) => setState(() => _orderUpdates = value),
            brightness,
          ),
          _buildSwitchTile(
            'Mises à jour de livraison',
            'Notifications en temps réel sur votre livraison',
            _deliveryUpdates,
            (value) => setState(() => _deliveryUpdates = value),
            brightness,
          ),
          const SizedBox(height: 24),
          Text(
            'Notifications marketing',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Promotions et offres',
            'Recevoir des offres spéciales et promotions',
            _promotions,
            (value) => setState(() => _promotions = value),
            brightness,
          ),
          _buildSwitchTile(
            'Nouveaux dépôts',
            'Être informé des nouveaux dépôts près de vous',
            _newDepots,
            (value) => setState(() => _newDepots = value),
            brightness,
          ),
          _buildSwitchTile(
            'Alertes de prix',
            'Notifications sur les changements de prix',
            _priceAlerts,
            (value) => setState(() => _priceAlerts = value),
            brightness,
          ),
          const SizedBox(height: 24),
          Text(
            'Canaux de notification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: GlassConstants.titleColor(brightness),
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchTile(
            'Notifications push',
            'Recevoir des notifications sur votre appareil',
            _pushNotifications,
            (value) => setState(() => _pushNotifications = value),
            brightness,
          ),
          _buildSwitchTile(
            'Notifications par email',
            'Recevoir des notifications par email',
            _emailNotifications,
            (value) => setState(() => _emailNotifications = value),
            brightness,
          ),
          _buildSwitchTile(
            'Notifications par SMS',
            'Recevoir des notifications par SMS',
            _smsNotifications,
            (value) => setState(() => _smsNotifications = value),
            brightness,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    Brightness brightness,
  ) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: GlassConstants.titleColor(brightness),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: GlassConstants.mutedColor(brightness),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: GlassConstants.accent,
          ),
        ],
      ),
    );
  }
}
