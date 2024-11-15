import 'package:flutter/material.dart';
import 'package:movie_watchlist/services/user_service.dart';
import 'package:movie_watchlist/shared_widgets/update_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService(); // Singleton instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(139, 54, 54, 54),
              foregroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 80),
                // Listen for username updates
                ValueListenableBuilder<String?>(
                  valueListenable: userService.usernameNotifier,
                  builder: (context, username, child) {
                    return Text(
                      username ?? 'Guest',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                      ),
                    );
                  },
                ),
                const SizedBox(width: 30),
                IconButton(
                  onPressed: () {
                    showEditUsernameDialog(
                            context, userService.usernameNotifier.value)
                        .then((_) {
                      userService.initializeUsername();
                    });
                  },
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/favourites'),
                    child: const ListTile(
                      leading: Icon(
                        Icons.favorite_outline,
                        size: 30,
                      ),
                      title: Text(
                        'Favourites',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 20,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_rounded,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                 ListTile(
                    onTap: (){
                      Navigator.pushNamed(context, '/recents');
                    },
                    leading: const Icon(
                      Icons.auto_graph,
                      size: 30,
                    ),
                    title: const Text(
                      'Recently Viewed',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 20,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                _showDeleteConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                side: const BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
              ),  
                
              ),
              child: const Text(
                'Clear Data',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteUser() async {
    await userService.deleteUser();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDeleteConfirmationDialog(context);
      },
    );
  }

  Widget _buildDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 25, left: 20, bottom: 10),
      actionsPadding: const EdgeInsets.only(top: 30, right: 20, bottom: 15),
      contentPadding: const EdgeInsets.only(top: 10, left: 20),
      title: const Text('Delete User',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
      content: Text(
          'Are you sure you want to delete "${userService.usernameNotifier.value}"?\n\nNote: This will delete everything, this action is not reversible',
          style: const TextStyle(fontFamily: 'Poppins')),
      actions: _buildDeleteConfirmationActions(),
    );
  }

  List<Widget> _buildDeleteConfirmationActions() {
    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('No, Keep', style: TextStyle(fontFamily: 'Poppins')),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          Navigator.of(context).pop();
          await _deleteUser();
        },
        child:
            const Text('Yes, Delete', style: TextStyle(fontFamily: 'Poppins')),
      ),
    ];
  }
}
