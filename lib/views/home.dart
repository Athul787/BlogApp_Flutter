import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proj/screens/signin.dart';
import 'package:flutter_proj/services/crud.dart';
import 'package:flutter_proj/views/create_blog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_proj/views/myblogs.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  CrudMethods crudMethods = new CrudMethods();
String? userName;
//String? username;

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

                      return BlogsTile(imgUrl: snapshot.data.docs[index]["imgUrl"], title: snapshot.data.docs[index]["title"], description: snapshot.data.docs[index]["desc"], authorName: snapshot.data.docs[index]["authorName"]);
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
    // TODO: implement initState
    // crudMethods.getUserData().then((value){
    //   setState((){
    //     username=value[1];
    //     print(value[0]);
    //   });
    //
    // });
    crudMethods.getData().then((result){
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
          Text("Blog",style: TextStyle(
            fontSize: 22
          ),),
          Text("App",style: TextStyle(fontSize: 22,color: Colors.tealAccent[700]),)
        ],),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),

      body: BlogsList(),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          FloatingActionButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateBlog()));
          },
          child: Icon(Icons.add))
        ],),
      ),
      drawer: Drawer(

        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [

            DrawerHeader(

              decoration: BoxDecoration(
                color: Colors.tealAccent[700],

              ),
                child:
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(50.0),


                  child: FutureBuilder(

                    future: _fetch(),
                    builder: (context,snapshot){
                      if(snapshot.connectionState!=ConnectionState.done)
                        return Text("loading.");
                      return Text(userName!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                      ),);



                    },

                  ),

                ),



            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('My Blogs'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyBlogPage()));
               // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
              ),
              title: const Text('Logout'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));

              },
            ),
          ],
        ),
      ),

    );
  }
  _fetch() async{
    final firebaseUser=await FirebaseAuth.instance.currentUser;
    if(firebaseUser!=null)
      await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get().then((ds){
        userName=ds.data()!['userId'];
        print(userName);
      }).catchError((e){
        print(e);
      });
  }
}


class BlogsTile extends StatelessWidget {
  //const BlogsTile({Key? key}) : super(key: key);

  String? imgUrl,title,description,authorName;
  BlogsTile({
    @required this.imgUrl,@required this.title,@required this.description,@required this.authorName
});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 150,
      child: Stack(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(imageUrl: imgUrl!,fit: BoxFit.fill,width: MediaQuery.of(context).size.width,)),
        Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.black45.withOpacity(0.2),
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

        ],),)
      ],),
    );


  }
}
