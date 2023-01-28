import '../notesdb.dart';

class Note {
  final int? id;
  final bool pinned;
  final String title;
  final String? des;

  Note({this.id, required this.pinned, required this.title, this.des});

  Map<String, Object?> toJson() => {
        NoteTableName.id: id,
        NoteTableName.pinned: pinned ? 1 : 0,
        NoteTableName.title: title,
        NoteTableName.des: des
      };

  static Note toNote(Map<String, Object?> map) => Note(
      id: map[NoteTableName.id] as int?,
      pinned: map[NoteTableName.pinned] == 1,
      title: map[NoteTableName.title] as String,
      des: map[NoteTableName.des] as String?);

  Note copy({int? id, bool? pinned, String? title, String? des}) => (Note(
      id: id ?? this.id,
      pinned: pinned ?? this.pinned,
      title: title ?? this.title,
      des: des ?? this.des));
}