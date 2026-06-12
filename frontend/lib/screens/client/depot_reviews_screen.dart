import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class DepotReviewsScreen extends StatefulWidget {
  final Depot depot;

  const DepotReviewsScreen({
    super.key,
    required this.depot,
  });

  @override
  State<DepotReviewsScreen> createState() => _DepotReviewsScreenState();
}

class _DepotReviewsScreenState extends State<DepotReviewsScreen> {
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', '5 étoiles', '4 étoiles', '3 étoiles', '2 étoiles', '1 étoile'];

  // Mock reviews data
  final List<Map<String, dynamic>> _mockReviews = [
    {
      'clientName': 'Marie KOUASSI',
      'rating': 5.0,
      'comment': 'Excellent service ! Livraison rapide et livreur très professionnel.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'helpful': 12,
    },
    {
      'clientName': 'Jean MBARGA',
      'rating': 4.0,
      'comment': 'Bon dépôt, stock toujours disponible. Petit bémol sur les horaires d\'ouverture.',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'helpful': 8,
    },
    {
      'clientName': 'Fatou DIALLO',
      'rating': 5.0,
      'comment': 'Je recommande vivement ! Personnel accueillant et prix compétitifs.',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'helpful': 15,
    },
    {
      'clientName': 'Paul NKOMO',
      'rating': 3.0,
      'comment': 'Service correct mais j\'ai dû attendre un peu longtemps.',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'helpful': 3,
    },
    {
      'clientName': 'Aminata TOURÉ',
      'rating': 5.0,
      'comment': 'Parfait ! C\'est mon dépôt préféré depuis 2 ans.',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'helpful': 20,
    },
  ];

  List<Map<String, dynamic>> get _filteredReviews {
    if (_selectedFilter == 'Tous') return _mockReviews;
    
    final rating = int.parse(_selectedFilter.split(' ')[0]);
    return _mockReviews.where((review) => review['rating'].floor() == rating).toList();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Avis clients'),
      ),
      body: Column(
        children: [
          // Rating Summary
          GlassCard(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  widget.depot.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: GlassConstants.titleColor(brightness),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.depot.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: GlassConstants.titleColor(brightness),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < widget.depot.rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.depot.reviewCount} avis',
                          style: TextStyle(
                            fontSize: 14,
                            color: GlassConstants.mutedColor(brightness),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Rating Distribution
                _buildRatingBar(5, 85, brightness),
                _buildRatingBar(4, 10, brightness),
                _buildRatingBar(3, 3, brightness),
                _buildRatingBar(2, 1, brightness),
                _buildRatingBar(1, 1, brightness),
              ],
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _selectedFilter;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                    backgroundColor: GlassConstants.adaptiveSurfaceColor(brightness),
                    selectedColor: GlassConstants.accent.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? GlassConstants.accent
                          : GlassConstants.bodyColor(brightness),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),

          // Reviews List
          Expanded(
            child: _filteredReviews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 64,
                          color: GlassConstants.mutedColor(brightness),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun avis pour ce filtre',
                          style: TextStyle(
                            fontSize: 16,
                            color: GlassConstants.mutedColor(brightness),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = _filteredReviews[index];
                      return _buildReviewCard(review, brightness);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int percentage, Brightness brightness) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: TextStyle(
              fontSize: 12,
              color: GlassConstants.bodyColor(brightness),
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: GlassConstants.mutedColor(brightness).withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 12,
              color: GlassConstants.mutedColor(brightness),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, Brightness brightness) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: GlassConstants.accent.withValues(alpha: 0.2),
                child: Text(
                  review['clientName'].toString().substring(0, 1),
                  style: TextStyle(
                    color: GlassConstants.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['clientName'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: GlassConstants.titleColor(brightness),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < review['rating'].floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(review['date']),
                          style: TextStyle(
                            fontSize: 12,
                            color: GlassConstants.mutedColor(brightness),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: TextStyle(
              fontSize: 14,
              color: GlassConstants.bodyColor(brightness),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO: Mark as helpful
                },
                icon: Icon(Icons.thumb_up_outlined, size: 16),
                label: Text('Utile (${review['helpful']})'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Aujourd\'hui';
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      return 'Il y a ${(difference.inDays / 7).floor()} semaines';
    } else {
      return 'Il y a ${(difference.inDays / 30).floor()} mois';
    }
  }
}
