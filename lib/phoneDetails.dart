class PhoneDetails{
  int? id;
  String name;
  String number;
  String cover;
  PhoneDetails({
    this.id,
    required this.name,
    required this.number,
    required this.cover,
});
  factory PhoneDetails.fromMap(Map<String, dynamic> map) {
    return PhoneDetails(
      id: map['id'], // Include the id if necessary
      name: map['name'] ?? 'Unknown Name', // Use 'title' instead of 'name'
     number: map['number'] ?? 'Unknown Number',
      cover: map['cover'] ?? 'https://example.com/default_cover.jpg',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include the id if necessary
      'name': name, // Use 'title' instead of 'name'
      'number':number,
      'cover': cover,
    };
  }
}