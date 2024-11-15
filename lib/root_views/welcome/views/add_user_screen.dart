import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/user_model.dart';
import 'package:movie_watchlist/services/user_service.dart';

class CreateUser extends StatelessWidget {
  CreateUser({super.key});

  final UserService userService = UserService();

  void createNewUser({required String username}) async {
    User newUser = User(username: username);
    await userService.addUser(newUser);
  }

  @override
  Widget build(BuildContext context) {
    final username = TextEditingController();

    return Scaffold(
      body: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            height: 200,
            width: 350,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'What should we call you?',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 30),
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          controller: username,
                          decoration: const InputDecoration(
                            hintText: 'Username',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 100, right: 100),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(197, 20, 20, 20),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)))),
                          onPressed: () async {
                            String usernameFinal = username.text;

                            if (usernameFinal.isNotEmpty) {
                              createNewUser(username: usernameFinal);

                              Navigator.pushReplacementNamed(context, '/main');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Please enter a username')));
                            }
                          },
                          child: const Text('Continue')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
