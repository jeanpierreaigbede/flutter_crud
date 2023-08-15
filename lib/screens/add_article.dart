import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/firebase_methodes.dart';
import 'package:flutter_crud/utils/show_message.dart';
import 'package:image_picker/image_picker.dart';

class AddArticle extends StatefulWidget {
  const AddArticle({super.key});

  @override
  State<AddArticle> createState() => _AddArticleState();
}

class _AddArticleState extends State<AddArticle> {

  bool _isLoading = false;
  bool _pikingImg = false;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
   TextEditingController _descriptionController = TextEditingController();
  Uint8List? image_data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Un nouveau article"),
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

                Container(
                  height: 200,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepOrange,

                  ),
                  child: image_data!=null?Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                          width: double.maxFinite,
                          child: Image.memory(image_data!,fit: BoxFit.cover,)),
                      IconButton(
                        onPressed: (){
                          pickImage();
                        },
                        icon: const Icon(Icons.change_circle_outlined,color: Colors.white,size: 55,),
                      )
                    ],
                  ): IconButton(
                    onPressed: (){
                      pickImage();
                    },
                    icon: const Icon(Icons.upload,color: Colors.white,size: 55,),
                  )
                ),
                const SizedBox(height: 5,),
                _pikingImg ? const LinearProgressIndicator():Container(),
                const SizedBox(height: 30,),
                InkWell(
                  onTap: ()async{
                    if(_key.currentState!.validate()){

                      if(image_data!=null){
                        setState(() {
                          _isLoading = true;
                        });
                        String res = await FirebaseMethods().addArticleToFirestore(_titleController.text, _descriptionController.text, image_data!);

                        if(res == "success"){
                          _titleController.clear();
                          _descriptionController.clear();
                          image_data = null;
                          ShowMessage.showSnacbar(context, "Article ajouté avec succcès !");


                        }
                        setState(() {
                          _isLoading = false;
                        });
                      }else{
                        // ignore: use_build_context_synchronously
                        ShowMessage.showAlertDialog(context, "Erreur de validation", "Veuillez choisir une image");
                      }
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
                      "Ajouter",
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
