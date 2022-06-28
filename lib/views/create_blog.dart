

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage ;
import 'package:flutter/material.dart';
import 'package:flutter_proj/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:path/path.dart' as Path;



class CreateBlog extends StatefulWidget {
  const CreateBlog({Key? key}) : super(key: key);

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  late String authorName, title,desc;

  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;

 CrudMethods crudMethods = new CrudMethods();



  // File? selectedImage;
  // Future getImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //    setState((){
  //     File selectedImage=File(image!.path);
  //   });
  // }
  bool _isLoading=false;

  File? selectedImage;

  Future getImage() async {

    final ImagePicker _picker = ImagePicker();
    final XFile? Img = await _picker.pickImage(source: ImageSource.gallery);
    if (Img== null) {
      return;
    }
    final imageTemp= File(Img.path);
    setState(()=>selectedImage=imageTemp);
  }


  // File? _photo;
  // final ImagePicker _picker = ImagePicker();
  //
  // Future getImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _photo = File(pickedFile.path);
  //       uploadBlog();
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }


  // uploadBlog() async{
  //   if(selectedImage!=null){
  //     setState((){
  //       _isLoading=true;
  //     });
  //     Reference firebaseStorageRef= FirebaseStorage.instance.ref().child("blogImages").child("${randomAlphaNumeric(9)}.jpg");
  //
  //     final UploadTask task=firebaseStorageRef.putFile(selectedImage!);
  //     var downloadUrl=await(await task).ref.getDownloadURL();
  //     print("This is url $downloadUrl");
  //     Navigator.pop(context);
  //   }else{
  //
  //   }
  // }

  Future uploadBlog() async {
    if (selectedImage == null) return;
    setState((){
             _isLoading=true;
    });
    final fileName = Path.basename(selectedImage!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child("blogImages").child("${randomAlphaNumeric(9)}.jpg");

      //await ref.putFile(selectedImage!);
      final task=ref.putFile(selectedImage!);
      var downloadUrl=await(await task).ref.getDownloadURL();
      print("This is url $downloadUrl");

      Map<String,String> blogMap={
        "imgUrl": downloadUrl,
        "authorName":authorName,
        "title":title,
        "desc":desc,
      };
      crudMethods.addData(blogMap).then((result){
        Navigator.pop(context);
      });

    } catch (e) {
      print('error occured');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text("Flutter",style: TextStyle(
                fontSize: 22
            ),),
            Text("Blog",style: TextStyle(fontSize: 22,color: Colors.blue),)
          ],),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: (){
              uploadBlog();
    },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.file_upload)),
          ),
        ],
      ),
      body:_isLoading?Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
          : Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
        SizedBox(height:10),
        GestureDetector(
          onTap: (){
            getImage();
            },
          child: selectedImage!=null?
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 170,
            width: MediaQuery.of(context).size.width,

            child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(selectedImage!,fit: BoxFit.fill,)),
          )
              : Container(
            margin: EdgeInsets.symmetric(horizontal:16),
            height: 150,
            decoration:BoxDecoration(
              color: Colors.white, borderRadius:  BorderRadius.circular(6),
            ),
              width: MediaQuery.of(context).size.width,
          child: Icon(Icons.add_a_photo,color: Colors.black45,),),
        ),
        SizedBox(height: 8,),
       Container(
           padding: EdgeInsets.symmetric(horizontal: 16),
         child: Column(


         children: [
           TextField(decoration: InputDecoration(hintText: "Author Name"),
             onChanged: (val){
               authorName=val;
             },

           ),
           TextField(decoration: InputDecoration(hintText: "Title"),
             onChanged: (val){
               title=val;
             },

           ),
           TextField(decoration: InputDecoration(hintText: "Description"),
             onChanged: (val){
               desc=val;
             },

           ),
         ],
       ),)
      ],)),
    );
  }}


