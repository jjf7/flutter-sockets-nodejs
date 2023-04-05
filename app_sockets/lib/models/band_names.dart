class Band {
  String id;
  String name;
  String votes;

  Band({required this.id, required this.name, required this.votes});

  factory Band.fromMap(Map<String, dynamic> mapa) =>
      Band(id: mapa['id'], name: mapa['name'], votes: mapa['votes'].toString());
}
