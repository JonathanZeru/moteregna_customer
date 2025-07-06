class Package {
  final String? id;
  final String? description;
  final String? categoryId;
  final double? weight;
  final int? quantity;
  final String? specialInstructions;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? customerId;
  final String? motoristId;
  final String? deliveryId;
  final String? pickupLocationId;
  final String? dropoffLocationId;
  final Customer? customer;
  final Motorist? motorist;
  final Category? category;
  final dynamic delivery; // You might want to create a Delivery model
  final Location? pickupLocation;
  final Location? dropoffLocation;

  Package({
    this.id,
    this.description,
    this.categoryId,
    this.weight,
    this.quantity,
    this.specialInstructions,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.motoristId,
    this.deliveryId,
    this.pickupLocationId,
    this.dropoffLocationId,
    this.customer,
    this.motorist,
    this.category,
    this.delivery,
    this.pickupLocation,
    this.dropoffLocation,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      description: json['description'],
      categoryId: json['categoryId'],
      weight: json['weight']?.toDouble(),
      quantity: json['quantity'],
      specialInstructions: json['specialInstructions'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      customerId: json['customerId'],
      motoristId: json['motoristId'],
      deliveryId: json['deliveryId'],
      pickupLocationId: json['pickupLocationId'],
      dropoffLocationId: json['dropoffLocationId'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      motorist: json['motorist'] != null ? Motorist.fromJson(json['motorist']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      pickupLocation: json['pickupLocation'] != null ? Location.fromJson(json['pickupLocation']) : null,
      dropoffLocation: json['dropoffLocation'] != null ? Location.fromJson(json['dropoffLocation']) : null,
    );
  }
}

class Customer {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  // Add other fields as needed

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
    );
  }
}
class Motorist {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? licenseNumber;
  final String? vehiclePlateNumber;
  final String? profile;
  // Add other fields as needed

  Motorist({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.profile,
    this.licenseNumber,
    this.vehiclePlateNumber
  });

  factory Motorist.fromJson(Map<String, dynamic> json) {
    return Motorist(
      id: json['id'],
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      phone: json['user']['phone'],
      profile: json['user']['profile'],
      licenseNumber: json['licenseNumber'],
      vehiclePlateNumber: json['vehiclePlateNumber']
    );
  }
}

class Category {
  final String? id;
  final String? name;
  final String? description;
  // Add other fields as needed

  Category({
    this.id,
    this.name,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class Location {
  final String? id;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;

  Location({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}