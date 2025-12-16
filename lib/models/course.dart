class CourseModel {
  final String id;
  final String name;
  final String? imagePath;
  final String? imageBase64;
  final String? description;

  CourseModel({
    required this.id,
    required this.name,
    this.imagePath,
    this.imageBase64,
    this.description,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json,
      {required String id}) {
    return CourseModel(
      id: id,
      name: json['name'] as String? ?? '',
      imagePath: json['imagePath'] as String?,
      imageBase64: json['imageBase64'] as String?,
      description: json['description'] as String?,
    );
  }
}
