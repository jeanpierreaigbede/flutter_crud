

class Article{
  String? id,title,description,image,userId;
  DateTime? createdAt,updateAt;


  Article({required this.id, required this.title, required this.description, required this.image, required this.createdAt, required this.updateAt, required this.userId});


  toMap(Article article){
    return {
      "id":article.id,
      "title":article.title,
      "description":article.description,
      "image":article.image,
      "user_id":article.userId,
      "created_at":article.createdAt,
      "update_at":article.updateAt,

    };
  }


  Article.formMap({required Map<String,dynamic> map}){
    id = map['id'];
    title = map['title'];
    description = map['description'];
    image = map['image'];
    userId = map['user_id'];
    createdAt = map['created_at'].toDate();
    updateAt = map['update_at'].toDate();
  }
}