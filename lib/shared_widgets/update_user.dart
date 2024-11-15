import 'package:flutter/material.dart';
import '../services/user_service.dart'; 

Future<void> showEditUsernameDialog(
    BuildContext context, String oldUsername) {
  TextEditingController controller = TextEditingController(text: oldUsername);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new username'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () async {
              final newUsername = controller.text;

              if (newUsername.isNotEmpty && newUsername != oldUsername) {
                final userService = UserService();

                await userService.updateUser(newUsername);
                
                Navigator.of(context).pop();  
              } else {
                print("No changes made or invalid username");
                Navigator.of(context).pop();  
              }
            },
          ),
        ],
      );
    },
  );
}
