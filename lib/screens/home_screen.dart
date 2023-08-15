import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/firebase_methodes.dart';
import 'package:flutter_crud/screens/login_page.dart';
import 'package:flutter_crud/utils/show_message.dart';

import '../utils/article_model.dart';
import '../widgets/article_card.dart';
import 'add_article.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void logout()async{
    String res = await FirebaseMethods().logout();
    if(res == "success"){
      ShowMessage.showSnacbar(context, "Déconnecté avec succès");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }else{
      ShowMessage.showSnacbar(context, "Une erreur s'est produite");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Mes Articles'),
        actions: [
          IconButton(onPressed:logout, icon: const Icon(Icons.logout,color: Colors.white,))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Articles').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }

            if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return snapshot.data!.size> 0?
                ListView.builder(
                  itemCount: snapshot.data!.size,
                    itemBuilder: (context,index){
                    List<Article> articles = [];

                    for(var doc in snapshot.data!.docs){
                      print((doc.data()! as Map<String,dynamic>)['title']);
                      Map<String,dynamic> article = doc.data()! as Map<String,dynamic>;
                      articles.add(Article.formMap(map: article));
                      print(articles);
                    }
                  return  ArticleCard(article: articles[index],);
                })
                    : Center(child: Text("Aucun aticle disponible"));
              }
            }

            return const Center(child: CircularProgressIndicator());
          },
        )





      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddArticle()));
        },
        child: const Icon(Icons.add_circle_outline_sharp,color: Colors.white,),
      ),
    );
  }
}
