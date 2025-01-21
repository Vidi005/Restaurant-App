// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  String name;

  Category({
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json['name'],
      );
}
