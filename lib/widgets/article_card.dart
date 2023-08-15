import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/firebase_methodes.dart';
import 'package:flutter_crud/screens/update_article.dart';
import 'package:flutter_crud/utils/article_model.dart';
import 'package:flutter_crud/utils/show_message.dart';

class ArticleCard extends StatefulWidget {
  Article article;
  ArticleCard({super.key, required this.article});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0,1)
            ),
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(0,-1)
            )
          ]
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            width : double.maxFinite,
            decoration:BoxDecoration(
              color: Colors.grey,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
                image: DecorationImage(
                  image:NetworkImage(widget.article.image!,),
                  fit: BoxFit.cover
                )
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                   Text(widget.article.title!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                     Text(widget.article.description!,
                      maxLines: 4,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Date de publication :",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text("${widget.article.createdAt!.day}/${widget.article.createdAt!.month}/${widget.article.createdAt!.year} ${widget.article.createdAt!.hour}:${widget.article.createdAt!.minute}")
                      ],
                    ),
                    Visibility(
                      visible: widget.article.userId == FirebaseAuth.instance.currentUser!.uid,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return UpdateArticle(article: widget.article);
                                }));
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.edit),
                                  Text('Editer',style: TextStyle(color: Colors.white),)
                                ],
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red
                              ),
                              onPressed: (){
                                showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    title: const Text("Suppression d'article"),
                                    content: const Text("Voulez-vous vraimer supprimer cet article?"),
                                    actions: [
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text("Annuler")
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green
                                        ),
                                          onPressed: ()async{
                                          Navigator.pop(context);
                                          String res = await FirebaseMethods().deleteArticle(widget.article);
                                          if(res == 'success'){
                                            ShowMessage.showSnacbar(context, "Article supprimé avec succès");
                                          }else{
                                            ShowMessage.showAlertDialog(context, "Suppression échouée", res);
                                          }
                                          },
                                          child: Text("Valier",style: TextStyle(color: Colors.white))
                                      )
                                    ],
                                  );
                                });
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(Icons.delete),
                                  Text('Supprimer',style: TextStyle(color: Colors.white),)
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
