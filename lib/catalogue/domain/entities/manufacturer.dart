class Manufacturer {
  final int id;
  final String name;
  final String? website;
  final String? supportEmail;

  Manufacturer({
    required this.id,
    required this.name,
    this.website,
    this.supportEmail,
  });
}