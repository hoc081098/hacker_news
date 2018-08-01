import 'package:meta/meta.dart';

@immutable
class Item {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final DateTime time;
  final String text;
  final bool dead;
  final int parent;
  final String poll;
  final List<int> kids;
  final String url;
  final int score;
  final String title;
  final List<dynamic> parts;
  final int descendants;

  Item({
    this.id,
    this.deleted,
    this.type,
    this.by,
    this.time,
    this.text,
    this.dead,
    this.parent,
    this.poll,
    this.kids,
    this.url,
    this.score,
    this.title,
    this.parts,
    this.descendants,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return new Item(
      id: json['id'],
      deleted: json['deleted'] ?? false,
      type: json['type'],
      by: json['by'] ?? '',
      time: new DateTime.fromMillisecondsSinceEpoch((json['time'] ?? 0) * 1000),
      text: json['text'],
      dead: json['dead'] ?? false,
      parent: json['parent'],
      poll: json['poll'],
      kids: ((json['kids'] ?? []) as Iterable).cast<int>(),
      url: json['url'] ?? '',
      score: json['score'] ?? 0,
      title: json['title'] ?? '',
      parts: json['parts'] ?? [],
      descendants: json['descendants'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Item{id: $id, parent: $parent, kids: $kids, title: $title, descendants: $descendants}';
  }
}
