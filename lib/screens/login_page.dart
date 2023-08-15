import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/firebase_methodes.dart';
import 'package:flutter_crud/screens/home_screen.dart';
import 'package:flutter_crud/screens/signup_page.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  bool isObscure = true;
  bool _isLoading = false;

  void login()async{
    if(_emailController.text.isNotEmpty && _emailController.text!="" && _passwordController.text.isNotEmpty && _passwordController.text!=""){
      setState(() {
        _isLoading = true;
      });
      String res = await FirebaseMethods().login(_emailController.text, _passwordController.text);
      print(res);

      if(res == "network-request-failed"){
       setState(() {
         _isLoading = false;
       });
       // ignore: use_build_context_synchronously
       showDialog(context: context,
           builder: (context)=>AlertDialog(
             title: const Text("Erreur de validation"),
             content: const Text('Veuillez vérifier votre connexion internet'),
             actions: [
               TextButton(onPressed: (){
                 Navigator.pop(context);
               }, child:const Text('OK'))
             ],
           ));
     } else if(res == "invalid-email"){
       setState(() {
         _isLoading = false;
       });
       // ignore: use_build_context_synchronously
       showDialog(context: context,
           builder: (context)=>AlertDialog(
             title: const Text("Erreur de validation"),
             content: const Text('Veuillez rentrer un email valide'),
             actions: [
               TextButton(onPressed: (){
                 Navigator.pop(context);
               }, child:const Text('OK'))
             ],
           ));
     } else if(res == "user-not-found"){
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showDialog(context: context,
            builder: (context)=>AlertDialog(
              title: const Text("Erreur de validation"),
              content: const Text('Aucun utilisateur trouvé'),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child:const Text('OK'))
              ],
            ));
      }else if(res == "wrong-password"){
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showDialog(context: context,
            builder: (context)=>AlertDialog(
              title: const Text("Erreur de validation"),
              content: const Text('Mot de passe inconrect'),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child:const Text('OK'))
              ],
            ));
      } else if(res == "success"){
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Connecté(e) avec succcès')));
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
      }

      else{
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showDialog(context: context,
            builder: (context)=>AlertDialog(
              title: const Text("Erreur de validation"),
              content: Text(res),
              actions: [
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child:const Text('OK'))
              ],
            ));
      }

    }else{
      setState(() {
        _isLoading = false;
      });
      showDialog(context: context,
          builder: (context)=>AlertDialog(
            title: const Text("Erreur de validation"),
            content: const Text('Veuillez remplir tous les champs'),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child:const Text('OK'))
            ],
          ));

    }
    }



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 15),
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
                'Veuillez renseigner les informations afin de vous connecter !',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400

                ),),
              const SizedBox(height: 20,),

              // Password Field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Entrer votre email"
                ),
              ),
              const SizedBox(height: 10,),

              // Password
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
                onTap: login,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: MediaQuery.of(context).size.width*0.8,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child:_isLoading? const CircularProgressIndicator(color: Colors.white,): const Text(
                    "Se connecter",
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
                  "N'avez-vous pas un compte?",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));
                  },
                  child: const Text(
                  "S'inscrire",
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
