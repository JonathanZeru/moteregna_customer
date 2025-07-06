import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gibe_market/views/trip/trips.dart';

class TripHistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> tripHistory;

  const TripHistoryPage({required this.tripHistory, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trip History"),
        centerTitle: true,
      ),
      body: tripHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    "No trips recorded yet.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: tripHistory.length,
              itemBuilder: (context, index) {
                final trip = tripHistory[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Hero(
                        tag: "trip-icon-$index",
                        child: FaIcon(FontAwesomeIcons.route, color: Colors.blueAccent),
                      ),
                      title: Text("Trip ${index + 1}", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Distance: ${trip['distance'].toStringAsFixed(2)} km"),
                          Text("Earnings: ETB ${trip['earnings'].toStringAsFixed(2)}"),
                          Text("Duration: ${trip['duration']}"),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripStatisticsPage(
                              distance: trip['distance'] as double,
                              earnings: trip['earnings'] as double,
                              duration: trip['duration'] as Duration,
                              tripIndex: index,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
