enum AnimalCategory { farm, forest, pet }

class Animal {
  const Animal({
    required this.id,
    required this.name,
    required this.category,
    required this.imageAsset,
    required this.nameAsset,
    required this.soundAudioAsset,
    required this.nameAudioAsset,
  });

  final String id;
  final String name;
  final AnimalCategory category;
  final String imageAsset;
  final String nameAsset;
  final String soundAudioAsset;
  final String nameAudioAsset;
}
