import 'profile_icons.dart';
import 'package:flutter/material.dart';
import 'supplemental/cut_corners_border.dart';
import 'constants.dart';
import 'quick_role_actions.dart';
import 'color_override.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'progress_bar.dart';

class EditRolesPage extends StatefulWidget {
  @override
  EditRolesPageState createState() => EditRolesPageState();
}

class EditRolesPageState extends State<EditRolesPage> {
  final _roleNameController = TextEditingController();
  final _roleName = GlobalKey(debugLabel: 'Role Name');
  bool _createUserPermission = false;
  bool _createProjectPermission = false;
  bool _createRolePermission = false;
  bool _createTagPermission = false;
  bool _grantUserPermission = false;
  List devices = [
    "ipad",
    "Microphone",
    "Dictaphone",
    "Phone",
  ];
  int _colorIndex = 0;
  List<bool> changed = [false];
  String roleName = "";

  bool allFalse(List<bool> lst){
    for(bool l in lst){
      if (l == true) return false;
    }
    return true;

  }
  
    Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          new QuickRoleActions(),

          SizedBox(height: 20.0),
          Column(
            children: <Widget>[
              Image.asset('assets/diamond.png'),
              SizedBox(height: 16.0),
              Text(
                'Create A New Role',
                style: TodoColors.textStyle.apply(
                    color: TodoColors.baseColors[_colorIndex]),
              ),
            ],
          ),

          SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: TodoColors.baseColors[_colorIndex],
            child: TextField(
              key: _roleName,
              controller: _roleNameController,
              decoration: InputDecoration(
                labelText: 'Role Name',
                labelStyle: TodoColors.textStyle2,
                border: CutCornersBorder(),
              ),
              onChanged: (text) { changed[0] = true; roleName = text;},
            ),
          ),


          new CheckboxListTile(
            title: Text('Can Create User', style: TodoColors.textStyle2,),
            value: _createUserPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createUserPermission = permission;
              });
            },
            secondary: new Icon(
              LineAwesomeIcons.user, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Create Project', style: TodoColors.textStyle2,),
            value: _createProjectPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createProjectPermission = permission;
              });
            },
            secondary: new Icon(
              Icons.work, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Create Role', style: TodoColors.textStyle2,),
            value: _createRolePermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createRolePermission = permission;
              });
            },
            secondary: new Icon(
              Icons.library_add, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Create Tag', style: TodoColors.textStyle2,),
            value: _createTagPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _createTagPermission = permission;
              });
            },
            secondary: new Icon(
              Icons.title, color: TodoColors.baseColors[_colorIndex],
              size: 30.0,),
          ),
          new CheckboxListTile(
            title: Text('Can Grant Permission', style: TodoColors.textStyle2,),
            value: _grantUserPermission,
            activeColor: TodoColors.baseColors[_colorIndex],
            onChanged: (bool permission) {
              setState(() {
                _grantUserPermission = permission;
              });
            },
            secondary: new Icon(
              LineAwesomeIcons.thumbsUp,
              color: TodoColors.baseColors[_colorIndex], size: 30.0,),
          ),


          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                textColor: TodoColors.baseColors[_colorIndex],
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  _roleNameController.clear();
                  setState(() {
                    _createUserPermission = false;
                    _createProjectPermission = false;
                    _createRolePermission = false;
                    _createTagPermission = false;
                    _grantUserPermission = false;
                  });
                },
              ),
              RaisedButton(
                child: Text('CREATE'),
                textColor: TodoColors.baseColors[_colorIndex],
                elevation: 8.0,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                ),
                onPressed: () {
                  if (_roleNameController.value.text.trim() != "") {
      if(!allFalse(changed)) {
//      Firestore.instance.runTransaction((transaction) async {
//      DocumentSnapshot freshSnap =
//      await transaction.g(document.reference);
//      await transaction.set(document.reference, {
//              'roleName':roleName
//      });});


        Firestore.instance.collection('roles').document()
            .setData({ 'roleName': roleName, });
      }
      _roleNameController.clear();
      showInSnackBar(
      "Project Created Successfully", TodoColors.accent);
      
                  } else {
                    showInSnackBar(
                        "Please Specify A Value For Role Name",
                        Colors.redAccent);
                  }
                },
              ),
            ],
          ),
        ],
      );
    }
    
      @override
      Widget build(BuildContext context) {
        return new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('roles').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return new Center(
                  child: new CircularProgressIndicator()
              );
              final converter = _buildListItem(
                  context, snapshot.data.documents[0]);

              return OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
                  if (orientation == Orientation.portrait) {
                    return converter;
                  } else {
                    return Center(
                      child: Container(
                        width: 450.0,
                        child: converter,
                      ),
                    );
                  }
                },
              );
            });
  }

  void showInSnackBar(String value, Color c) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: c,
    ));
  }
}
