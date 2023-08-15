

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_crud/screens/firebase_methodes.dart';
import 'package:flutter_crud/screens/home_screen.dart';
import 'package:flutter_crud/utils/show_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

import '../utils/article_model.dart';

class UpdateArticle extends StatefulWidget {
  final Article article;
   UpdateArticle({super.key, required this.article});

  @override
  State<UpdateArticle> createState() => _UpdateArticleState();
}

class _UpdateArticleState extends State<UpdateArticle> {

  bool _isLoading = false;
  bool _pikingImg = false;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Uint8List? image_data;


  @override
  void initState() {
   _titleController.text= widget.article.title!;
   _descriptionController.text = widget.article.description!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mise à jour "),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Title field
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        hintText: "Entrer le titre de l'article",
                        filled: true
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      return value == null || value ==""?"veuillez entrer le titre":null;
                    },
                  ),
                  const SizedBox(height: 20,),

                  // Description field
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        hintText: "Entrer la descitpion de l'article",
                        filled: true
                    ),
                    validator: (value){
                      return value == null || value ==""?"veuillez entrer le description ":null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Selectionnez une image")),
                  const SizedBox(height: 10,),

                  image_data!= null ? Image.memory(image_data!):Image.network(widget.article.image!,fit: BoxFit.cover,width: double.maxFinite,height: 200,),

                  TextButton(onPressed: ()async{
                    await pickImage();
                    try {
                      var ref = FirebaseStorage.instance.refFromURL(widget.article.image!);
                      print(ref);
                    await ref.putData(image_data!);
                    }  catch (e) {
                      print(e);
                    }


                  }, child: Text("Changer l'image",style: TextStyle(color: Colors.deepOrange),)),
                  const SizedBox(height: 5,),
                  _pikingImg ? const LinearProgressIndicator():Container(),
                  const SizedBox(height: 30,),
                  InkWell(
                    onTap: ()async{
                      if(_key.currentState!.validate()){
                        setState(() {
                          _isLoading = true;
                        });
                        print(image_data);
                        Article art = Article(id: widget.article.id,title: _titleController.text, description: _descriptionController.text, image: widget.article.image, createdAt: widget.article.createdAt, updateAt: widget.article.updateAt, userId: widget.article.userId);
                        String res = await FirebaseMethods().updateArticle(art, image_data);

                        print(res);

                        if(res == "success"){
                          ShowMessage.showSnacbar(context, "Article mis à jour avec succès");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        }

                        setState(() {
                          _isLoading = false;
                        });
                        }else{
                          // ignore: use_build_context_synchronously
                          ShowMessage.showAlertDialog(context, "Erreur de validation", "Veuillez choisir une image");
                        }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child:_isLoading? const CircularProgressIndicator(color: Colors.white,): const Text(
                        "Mettre à jour",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  pickImage()async{
    try {
      setState(() {
        _pikingImg = true;
      });
      ImagePicker _picker = ImagePicker();

      XFile? _file = await _picker.pickImage(source: ImageSource.gallery);

      if(_file != null ){
        var data = await _file.readAsBytes();

        setState((){
          image_data = data;
        });
        print(image_data);
      }
      setState(() {
        _pikingImg = false;
      });
    } catch (e) {
      print(e);
    }
  }
}

