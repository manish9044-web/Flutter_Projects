import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do_app/models/todo_model.dart';

class DatabaseService {
  final CollectionReference todoCollection =
      FirebaseFirestore.instance.collection('todos');

  User? user = FirebaseAuth.instance.currentUser;

  //Add todo task
  Future<DocumentReference> addTodoTask(
      String title, String description) async {
    return await todoCollection.add({
      'userId': user!.uid,
      'title': title,
      'description': description,
      'completed': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  //Update todo task
  Future<void> updateTodo(String id, String description, String title) async {
    final updatetodoCollection =
        FirebaseFirestore.instance.collection("todos").doc(id);
    return await updatetodoCollection.update({
      'title': title,
      'description': description,
    });
  }

  //update todo status
  Future<void> updateTodoStatus(String id, bool completed) async {
    return await todoCollection.doc(id).update({
      'completed': completed,
    });
  }

  //Delete todo task
  Future<void> deletetodoTask(String id) async {
    return await todoCollection.doc(id).delete();
  }

  //get pending tasks
  Stream<List<Todo>> get todos {
    return todoCollection
        .where('userId', isEqualTo: user!.uid)
        .where('completed', isEqualTo: false)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  //get completed tasks
  Stream<List<Todo>> get completedtodos {
    return todoCollection
        .where('userId', isEqualTo: user!.uid)
        .where('completed', isEqualTo: true)
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Todo(
        id: doc.id,
        title: doc['title'] ?? '',
        description: doc['description'] ?? '',
        completed: doc['completed'] ?? false,
        timeStamp: doc['createdAt'] ?? '',
      );
    }).toList();
    } 
}
