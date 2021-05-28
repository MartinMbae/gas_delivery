
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactFragment extends StatefulWidget {
  @override
  _ContactFragmentState createState() => _ContactFragmentState();
}

class _ContactFragmentState extends State<ContactFragment> {


  void _launchURL(String _url) async {
    bool canOpen = await canLaunch(_url);
    if (canOpen){
      await launch(_url);
    }else{
      Fluttertoast.showToast(
          msg: "Failed to open $_url.",
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          fontSize: 16.0);
    }
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
            child: ListView(
              padding: EdgeInsets.only(bottom: 30),
              children: [
                ListTile(
                  leading: Icon(Icons.facebook, color: Color(0xFF3B5998),),
                  title: Text('Facebook'),
                  onTap: (){
                    _launchURL("https://facebook.com/asaph.energies");
                  },
                ),
                Divider(height: 1,),
                SizedBox(height: 4,),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.twitter,  color: Color(0xFF00ACEE)),
                  title: Text('Twitter'),
                  onTap: (){
                    _launchURL("https://twitter.com/asapenergies");
                  },
                ),
                Divider(height: 1,),
                SizedBox(height: 4,),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.instagram, ),
                  title: Text('Instagram'),
                  onTap: (){
                    _launchURL("https://instagram.com/asap_energies");
                  },
                ),
                Divider(height: 1,),
                SizedBox(height: 4,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
