class LateralPhotos {
  final List<String> photosUrls;
  final String? createdDataContainerLat;
  final String? createdDataContainerLatRespoonse;

  LateralPhotos({required this.photosUrls, required this.createdDataContainerLat, required this.createdDataContainerLatRespoonse});

  factory LateralPhotos.fromJson(Map<String, dynamic> json) {
    return LateralPhotos(
      photosUrls: List<String>.from(json['photosUrls'] ?? []),
      createdDataContainerLat: json['createdDataContainerLat'],
      createdDataContainerLatRespoonse: json['createdDataContainerLatRespoonse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photosUrls': photosUrls,
      'createdDataContainerLat': createdDataContainerLat,
      'createdDataContainerLatRespoonse': createdDataContainerLatRespoonse, 
    };
  }
}

