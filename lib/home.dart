import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model_class.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Widget setValues(String fieldName, String content) {
  return Padding(
    padding: const EdgeInsets.all(4),
    child: Row(
      children: [
        Text(
          fieldName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

class _HomeState extends State<Home> {
  List<AlbumDetails> albumDetails = [];
  int page = 1;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          fetchData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Album Details",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        itemCount: albumDetails.length + 1,
        itemBuilder: (context, index) {
          if (index < albumDetails.length) {
            return Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.circular(11),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  setValues("ID: ", albumDetails[index].id.toString()),
                  setValues("UserId: ", albumDetails[index].userId.toString()),
                  setValues("Title: ", albumDetails[index].title.toString()),
                ],
              ),
            );
          } else {
            return isLoading?const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ):const Center(child: Text("No More Data",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red),));
          }
        },
      ),
    );
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final dataResponse = await http.get(Uri.parse(
        "https://jsonplaceholder.typicode.com/albums?_limit=25&_page=$page"));
    if (dataResponse.statusCode == 200) {
      var data = jsonDecode(dataResponse.body.toString());
      setState(() {
        albumDetails.addAll(data.map<AlbumDetails>((json) => AlbumDetails.fromJson(json)).toList());
        page++;
        isLoading = false;
      });
    }
    else {
      setState(() {
        isLoading = false;
      });
      throw Exception("Failed to load data");
    }
  }
}
