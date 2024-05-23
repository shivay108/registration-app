import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _searchResultsStream;

  void _startSearch(String query) {
    setState(() {
      _searchResultsStream = FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: query)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by username',
          ),
          onChanged: (value) {
            _startSearch(value);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _searchResultsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              if (user != null) {
                return ListTile(
                  title: Text(user['username'] ?? ''),
                  subtitle: Text(user['email'] ?? ''),
                  // Add more details or actions if needed
                );
              } else {
                return SizedBox(); // Placeholder widget if user is null
              }
            },
          );


        },
      ),
    );
  }
}
