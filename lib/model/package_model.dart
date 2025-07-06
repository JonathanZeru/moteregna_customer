class PackageLocation {
  final double latitude;
  final double longitude;
  final String address;

  PackageLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}

class Package {
  final String description;
  final String categoryId;
  final double weight;
  final int quantity;
  final String specialInstructions;
  final PackageLocation pickupLocation;
  final PackageLocation dropoffLocation;

  Package({
    required this.description,
    required this.categoryId,
    required this.weight,
    required this.quantity,
    required this.specialInstructions,
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'categoryId': categoryId,
      'weight': weight,
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'pickupLocation': pickupLocation.toJson(),
      'dropoffLocation': dropoffLocation.toJson(),
    };
  }
}
