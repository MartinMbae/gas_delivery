
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFragment extends StatefulWidget {
  @override
  _ContactFragmentState createState() => _ContactFragmentState();
}

class _ContactFragmentState extends State<ContactFragment> {


  void _launchURL(String _url) async {
    return await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      child: SafeArea(
        top: false,
        child: Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:16.0, horizontal: 20),
              child: ListView(
                padding: EdgeInsets.only(bottom: 30),
                children: [
                  ListTile(
                    leading: Icon(Icons.facebook, color: Color(0xFF3B5998),),
                    title: Text('Facebook'),
                    onTap: (){

                    },
                  ),
                  SizedBox(height: 4,),
                  ListTile(
                    leading: Icon(Icons.facebook, color: Color(0xFF00ACEE),),
                    title: Text('Twitter'),
                    onTap: (){

                    },
                  ),
                  SizedBox(height: 4,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
