// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, avoid_print, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where("product-name", isEqualTo: inputText)
                        .snapshots(),
                    builder: (BuildContext context,

                            // * Bagaimana caranya membuat ketika mengetikkan text yang tidak ada di data list maka
                            // * pesan "Not Found" ditampilkan jika tersedia di data list maka menampilkan list yang dicari

                            AsyncSnapshot<QuerySnapshot> snapshot) =>
                        inputText.isEmpty == inputText.isNotEmpty
                            ? Center(
                                child: Text('Not found'),
                              )
                            : ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;
                                return Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text(data['product-name']),
                                    leading:
                                        Image.network(data['product-img'][0]),
                                  ),
                                );
                              }).toList()),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// if (snapshot.connectionState == ConnectionState.waiting) {
//   return Center(
//     child: Text("Loading"),
//   );
// }
