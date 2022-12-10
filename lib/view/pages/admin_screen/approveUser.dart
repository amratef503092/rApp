import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p3/view/components/custom_data_empty.dart';

class ApproveUser extends StatefulWidget {
  const ApproveUser({Key? key}) : super(key: key);

  @override
  State<ApproveUser> createState() => _ApproveUserState();
}

class _ApproveUserState extends State<ApproveUser> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .where('approveUser', isEqualTo: false)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Approve User'),
            ),
            body: SizedBox(
              child: (snapshot.data!.docs.isEmpty)
                  ? const DataEmptyWidget()
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index].data()['photo']),
                            ),
                            title:
                                Text(snapshot.data!.docs[index].data()['name']),
                            subtitle: Text(
                              snapshot.data!.docs[index].data()['email'],
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data!.docs[index].id)
                                      .update({'approveUser': true});
                                  setState(() {
                                    snapshot.data!.docs.removeAt(index);
                                  });
                                },
                                child: const Text('Approve')),
                          ),
                        );
                      },
                    ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
