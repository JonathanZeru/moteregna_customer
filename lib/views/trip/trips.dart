import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TripStatisticsPage extends StatelessWidget {
  final double distance;
  final double earnings;
  final Duration duration;
  final int tripIndex;

  const TripStatisticsPage({
    required this.distance,
    required this.earnings,
    required this.duration,
    required this.tripIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip Statistics"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "trip-icon-$tripIndex",
              child: Center(
                child: FaIcon(FontAwesomeIcons.taxi, size: 60, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 20),
            _buildStatisticRow("Distance Traveled", "${distance.toStringAsFixed(2)} km", Icons.directions_walk, Colors.green),
            _buildStatisticRow("Earnings", "ETB ${earnings.toStringAsFixed(2)}", Icons.attach_money, Colors.orange),
            _buildStatisticRow("Trip Duration", _formatDuration(duration), Icons.timer, Colors.blue),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Back to History"),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticRow(String title, String value, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
