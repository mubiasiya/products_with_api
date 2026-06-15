class AddressModel {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String emirate;
  final String area;
  final String buildingName;
  final String flatNumber;
  final String? landmark;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.emirate,
    required this.area,
    required this.buildingName,
    required this.flatNumber,
    this.landmark,
    this.isDefault = false,
  });

  String get fullAddressLine {
    return [
      '$flatNumber, $buildingName',
      area,
      if (landmark?.trim().isNotEmpty ?? false) 'Landmark: $landmark',
      emirate.toUpperCase(),
    ].where((line) => line.trim().isNotEmpty).join('\n');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'emirate': emirate,
      'area': area,
      'buildingName': buildingName,
      'flatNumber': flatNumber,
      'landmark': landmark,
      'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      mobileNumber: map['mobileNumber'] as String? ?? '',
      emirate: map['emirate'] as String? ?? '',
      area: map['area'] as String? ?? '',
      buildingName: map['buildingName'] as String? ?? '',
      flatNumber: map['flatNumber'] as String? ?? '',
      landmark: map['landmark'] as String?,
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? mobileNumber,
    String? emirate,
    String? area,
    String? buildingName,
    String? flatNumber,
    String? landmark,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      emirate: emirate ?? this.emirate,
      area: area ?? this.area,
      buildingName: buildingName ?? this.buildingName,
      flatNumber: flatNumber ?? this.flatNumber,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
