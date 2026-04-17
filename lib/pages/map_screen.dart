import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // Dummy stand locations around ULM Banjarmasin
  final List<Map<String, dynamic>> _stands = [
    {
      'name': 'Stand CoinTrash: Halaman Auditorium ULM',
      'address': 'Jl. Brigjen H. Hasan Basry, Banjarmasin',
      'lat': -3.4425,
      'lng': 114.8345,
      'distance': '0.5 km',
    },
    {
      'name': 'Stand CoinTrash: Fakultas Teknik ULM',
      'address': 'Jl. A. Yani KM 36, Banjarbaru',
      'lat': -3.4440,
      'lng': 114.8360,
      'distance': '1.2 km',
    },
    {
      'name': 'Stand CoinTrash: TPS Pasar Lama',
      'address': 'Jl. Pasar Lama, Banjarmasin',
      'lat': -3.3200,
      'lng': 114.5900,
      'distance': '3.7 km',
    },
    {
      'name': 'Stand CoinTrash: Duta Mall',
      'address': 'Jl. A. Yani KM 2, Banjarmasin',
      'lat': -3.3260,
      'lng': 114.5980,
      'distance': '4.1 km',
    },
  ];

  int _selectedStand = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(
                _stands[0]['lat'] as double,
                _stands[0]['lng'] as double,
              ),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.cointrash.app',
              ),
              MarkerLayer(
                markers: _stands.asMap().entries.map((entry) {
                  final i = entry.key;
                  final stand = entry.value;
                  return Marker(
                    point: LatLng(
                      stand['lat'] as double,
                      stand['lng'] as double,
                    ),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedStand = i);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: i == _selectedStand
                              ? AppColors.primaryGreen
                              : AppColors.accentOrange,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.recycling,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top info card
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: AppColors.primaryGreen,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _stands[_selectedStand]['name'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '📍 ${_stands[_selectedStand]['distance']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom stand list
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _stands.length,
              itemBuilder: (context, index) {
                final stand = _stands[index];
                final isSelected = index == _selectedStand;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedStand = index);
                    _mapController.move(
                      LatLng(stand['lat'] as double, stand['lng'] as double),
                      14,
                    );
                  },
                  child: Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : Colors.grey.shade200,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          stand['name'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textDark,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.directions_walk,
                              size: 14,
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.textGray,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              stand['distance'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
