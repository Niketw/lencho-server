import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Dummy data for farm fields.
  final List<Map<String, String>> farmFields = const [
    {"name": "Field A", "crop": "Wheat", "moisture": "45%"},
    {"name": "Field B", "crop": "Corn", "moisture": "55%"},
    {"name": "Field C", "crop": "Rice", "moisture": "65%"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farm Dashboard"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView.builder(
        itemCount: farmFields.length,
        itemBuilder: (context, index) {
          final field = farmFields[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.agriculture,
                  size: 40, color: Colors.green),
              title: Text(
                field["name"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Crop: ${field["crop"]!}\nSoil Moisture: ${field["moisture"]!}",
                style: const TextStyle(height: 1.5),
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // Navigate to field details (to be implemented)
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for adding new field data (to be implemented)
        },
        tooltip: 'Add Field',
        child: const Icon(Icons.add),
      ),
    );
  }
}






