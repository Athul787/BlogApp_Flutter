import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/services/crud.dart';



class MyBlogPage extends StatefulWidget {
  const MyBlogPage({Key? key}) : super(key: key);

  @override
  State<MyBlogPage> createState() => _MyBlogPageState();

}

class _MyBlogPageState extends State<MyBlogPage> {

  CrudMethods crudMethods = new CrudMethods();



  //QuerySnapshot? blogsSnapshot;
  Stream? blogsStream;
  Widget BlogsList(){
    return Container(
      child: blogsStream!=null?

      ListView(
        children: [

          StreamBuilder(
              stream: blogsStream,
              builder: (context,AsyncSnapshot snapshot){



                return snapshot.data!=null? ListView.builder(

                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: snapshot.data.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){

                      return BlogsTile(imgUrl: snapshot.data.docs[index]["imgUrl"], title: snapshot.data.docs[index]["title"], description: snapshot.data.docs[index]["desc"], authorName: snapshot.data.docs[index]["authorName"],uniqueId: snapshot.data.docs[index]["uniqueId"]);
                    }
                ):Container(
                  child: Text("NULL"),
                );
              })

        ],)
          :Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {

    // crudMethods.getUserData().then((value){
    //   setState((){
    //     username=value[1];
    //     print(value[0]);
    //   });
    //
    // });
    crudMethods.getmyData().then((result){
      setState((){
        blogsStream=result;
      });

    });
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text("My ",style: TextStyle(
                fontSize: 22
            ),),
            Text("Blogs",style: TextStyle(fontSize: 22,color: Colors.white),)
          ],),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),

      body: BlogsList(),



    );
  }

}


class BlogsTile extends StatelessWidget {
  //const BlogsTile({Key? key}) : super(key: key);

  String? imgUrl,title,description,authorName,uniqueId;
  BlogsTile({
    @required this.imgUrl,@required this.title,@required this.description,@required this.authorName,@required this.uniqueId,
  });
  @override
  Widget build(BuildContext context) {
    return Container(

        margin: EdgeInsets.only(bottom: 16),
        height: 150,
        child: Stack(children: [

          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(imageUrl: imgUrl!,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,)),
          Container(
            height: 170,
            decoration: BoxDecoration(
              color: Colors.black45.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,


              children: [

                Text(title!,textAlign:TextAlign.center, style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500),),

                Text(description!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w300),),
                Text(authorName!,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),),

                FloatingActionButton(onPressed: ()async{
                  await deleteBlog(uniqueId!);
                }, child: Icon(Icons.delete),
                  backgroundColor: Colors.grey,
                mini: true,
                ),



              ],

            ),)
        ],),
      );



  }
}
// Future<void> deleteBlog(String id) async {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   try {
//     await _firebaseFirestore
//         .collection('users')
//         .where('imgUrl',isEqualTo: id).
//         .delete();
//   } catch (e) {
//     print("$e");
//   }
// }
Future<void> deleteBlog(String id) async {
  print("delete");

    //await _firebaseFirestore.collection("blogs").where("imgUrl",isEqualTo: id).delete();
  FirebaseFirestore.instance.collection("blogs").doc(id).delete();

}