import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/firebase_methodes.dart';
import 'package:flutter_crud/screens/home_screen.dart';
import 'package:flutter_crud/screens/login_page.dart';



class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isObscure = true;
  bool _isLoading = false;

  void registerUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await FirebaseMethods().register(_emailController.text, _passwordController.text);

    print(res);
    if(res =='invalid-email'){
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showDialog(context: context,
          builder: (BuildContext context)=> AlertDialog(
          title: const Text('Erreur de validation'),
          content: const Text('Veuillez rentrer un email valide'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('OK')
            )
          ],
        ));
    } else if(res == 'weak-password'){
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showDialog(context: context,
          builder: (BuildContext context)=> AlertDialog(
            title: const Text('Erreur de validation'),
            content: const Text('Mot de passe trop faible'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('OK')
              )
            ],
          ));
    }else if(res == "success"){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compte créé avec succès'))
      );
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
    }else if(res == "email-already-in-use"){
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      showDialog(context: context,
          builder: (BuildContext context)=> AlertDialog(
            title: Text('Erreur d\'inscription'),
            content: Text('Un compte est déja relié à ce gmail'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Annuler')
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
              }, child: const Text('Se Connecter')
              ),
            ],
          ));
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("images/firebase.png",height: 250,width: 250,fit: BoxFit.cover,),
              const SizedBox(height: 20,),
              const Text(
                'FIREBASE CRUD !',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600

                ),),
              const SizedBox(height: 20,),
              const Text(
                'Veuillez renseigner les informations afin de vous inscrire !',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600

                ),),
              const SizedBox(height: 20,),

              // Email field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    hintText: "Entrer votre email"
                ),
              ),
              const SizedBox(height: 10,),

              // password field

              TextField(
                obscureText: isObscure,
                controller: _passwordController,
                decoration: InputDecoration(
                    hintText: "Entrer votre mot de passe",
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          isObscure =!isObscure;
                        });
                      },
                      icon:  Icon(isObscure?Icons.visibility:Icons.visibility_off_outlined),
                    )
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap:registerUser,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: _isLoading? const CircularProgressIndicator(color: Colors.white,):const Text(
                    "S'inscrire",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Avez-vous déja un compte?",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),),
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context)=>const LoginPage()),
                      );
                    }, child:const Text(
                    "Se connecter",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 15
                    ),),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
