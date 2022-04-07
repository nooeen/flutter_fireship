import 'package:flutter/material.dart';
import 'package:quizapp/shared/loader.dart';
import 'package:quizapp/shared/bottom_nav.dart';
import 'package:quizapp/shared/error.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/models.dart';
import 'package:quizapp/topics/drawer.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
        future: FirestoreServices().getTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Center(
                child: ErrorMessage(message: snapshot.error.toString()));
          } else if (snapshot.hasData) {
            var topics = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.deepPurple[200],
                title: const Text('Topics'),
              ),
              drawer: TopicDrawer(topics: topics),
              body: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20.0),
                crossAxisSpacing: 10.0,
                crossAxisCount: 2,
                children: topics.map((topic) => Text(topic.title)).toList(),
              ),
              bottomNavigationBar: const BottomNavBar(),
            );
          }
          return const Text('No topics found in Firestore. Check database');
        });
  }
}
