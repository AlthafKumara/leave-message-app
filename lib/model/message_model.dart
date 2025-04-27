class MessageModel {
  int? id;
  String? author;
  String? message;

  MessageModel({
    required this.id,
    required this.author,
    required this.message,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        id: json["id"], author: json["author"], message: json["message"]);
  }
}
