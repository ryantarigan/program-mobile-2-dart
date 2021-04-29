SqfliteActivity.dart
import 'package:explore_data/useCase/sqflite/AtletVollyModel.dart';
import 'package:explore_data/useCase/sqflite/MySqlflite.dart';
import 'package:flutter/material.dart';

class SqfliteActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SqfliteActivityState();
}

class SqfliteActivityState extends State<SqfliteActivity> {
  final keyFormAtletVolly = GlobalKey<FormState>();

  TextEditingController controllerNo = TextEditingController();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerPosition = TextEditingController();
  TextEditingController controllerPower = TextEditingController();

  String no = "";
  String name = "";
  String position = "";
  int power = 0;

  List<AtletVollyModel> AtletVolly = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AtletVolly = await MySqflite.instance.getAtletVolly();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.only(top: 36, left: 24, bottom: 4),
          child: Text("Input AtletVolly",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Form(
          key: keyFormAtletVolly,
          child: Container(
            margin: EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: controllerNo,
                  decoration: InputDecoration(hintText: "NO"),
                  validator: (value) => _onValidateText(value),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => no = value,
                ),
                TextFormField(
                  controller: controllerName,
                  decoration: InputDecoration(hintText: "Nama"),
                  validator: (value) => _onValidateText(value),
                  onSaved: (value) => name = value,
                ),
                TextFormField(
                  controller: controllerposition,
                  decoration: InputDecoration(hintText: "Posisi"),
                  validator: (value) => _onValidateText(value),
                  onSaved: (value) => department = value,
                ),
                TextFormField(
                  controller: controllerPower,
                  decoration: InputDecoration(hintText: "POWER"),
                  validator: (value) => _onValidateText(value),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => sks = int.parse(value),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 24, right: 24),
          child: RaisedButton(
            onPressed: () {
              _onSaveAtletVolly();
            },
            child: Text("Simpan"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 24, left: 24, bottom: 4),
          child: Text("Data AtletVolly",
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: AtletVolly.length,
                padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
                itemBuilder: (BuildContext context, int index) {
                  var value = AtletVolly[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("No: ${value.no}"),
                        Text("Name: ${value.name}"),
                        Text("Posisi: ${value.posisi}"),
                        Text("Power: ${value.Power}"),
                      ],
                    ),
                  );
                }))
      ],
    ));
  }

  String _onValidateText(String value) {
    if (value.isEmpty) return 'Tidak boleh kosong';
    return null;
  }

  _onSaveAtletVolly() async {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (keyFormAtletVolly.currentState.validate()) {
      keyFormAtletVolly.currentState.save();
      controllerNo.text = "";
      controllerName.text = "";
      controllerPosisi.text = "";
      controllerPower.text = "";

      await MySqflite.instance.insertAtletVolly(AtletVollyModel(
          no: no, name: name, posisi: posisi, power: power));

      AtletVolly = await MySqflite.instance.getAtletVolly();
      setState(() {});
    }
  }
}
