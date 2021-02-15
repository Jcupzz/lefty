import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lefty/Database_Services/Database_Services.dart';
import 'package:numberpicker/numberpicker.dart';
class Register_Institute extends StatefulWidget {
  @override
  _Register_InstituteState createState() => _Register_InstituteState();
}

class _Register_InstituteState extends State<Register_Institute> {
  final _formKey = GlobalKey<FormState>();
  String iName,iPhone1,iPhone2,iAddress,iType,iDesc;
  final iNameController = TextEditingController();
  final iPhone1Controller = TextEditingController();
  final iPhone2Controller = TextEditingController();
  final iAddressController = TextEditingController();
  final iDescController = TextEditingController();
  int selectedValue;
  int iHour = 1;
  File iPhoto;
  final picker = ImagePicker();
  Database_Services database_services = new Database_Services();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        iPhoto = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,10,20,10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Divider(
                    color: Colors.black,
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      "Institution Name",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      iName = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: iNameController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      "Institution Address",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      iAddress = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    minLines: 6,
                    maxLines: 6,
                    controller: iAddressController,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: "Institution Address",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      "Institution Type",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 1)),
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: DropdownButton(
                          hint: Text("Institution Type"),
                          underline: SizedBox(),
                          isExpanded: true,
                          value: selectedValue,
                          items: [
                            DropdownMenuItem(
                              child: Text("Orphanage"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Old Age Home"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Mental Institution"),
                              value: 3,
                            ),
                            DropdownMenuItem(
                              child: Text("Others"),
                              value: 4,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                          }),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      "Select Hours",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.of(context).size.width,
                    child: NumberPicker.horizontal(
                        listViewHeight: 50,
                        step: 1,
                        initialValue: iHour,
                        minValue: 1,
                        maxValue: 48,
                        onChanged: (value) {
                          setState(() {
                            iHour = value;
                            print(iHour);
                          });
                        }),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey)),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(Icons.info_outline_rounded, size: 18),
                            ),
                            TextSpan(
                              text: "  Select the hours to show the request.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Divider(
                    color: Colors.black,
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Text(
                      "Enter Description",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      iDesc = value;
                    },

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    minLines: 5,
                    maxLines: 5,
                    controller: iDescController,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: "Description",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      "Select image of the institute (optional)",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () => getImage(),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Center(
                          child: iPhoto == null
                              ? Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 80,
                          )
                              : Image.file(iPhoto)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      "Primary Contact Number",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      iPhone1 = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: iPhone1Controller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                    child: Text(
                      "Secondary Contact Number",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value){
                      iPhone2 = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    controller: iPhone2Controller,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                        BorderSide(width: 1, color: Colors.blueGrey[900]),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,20,0,30),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {

                          if (_formKey.currentState.validate()) {

                            switch(selectedValue)
                            {
                              case 1:
                                iType = "Orphanage";
                                break;

                              case 2:
                                iType = "Old Age Home";
                                break;

                              case 3:
                                iType = "Mental Institution";
                                break;

                              case 4:
                                iType = "Others";
                                break;
                            }


                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                            database_services.addCreateToFb(iName, iAddress, iType, iHour, iPhoto, iPhone1, iPhone2,iDesc);
                          }

                        },
                        child: Text("Done"),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(20),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey[900]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),


    );
  }
}
