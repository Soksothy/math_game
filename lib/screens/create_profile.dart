import 'package:flutter/material.dart';
import 'package:math_game/models/user_model.dart'; 

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});
  
  @override
  State<CreateProfileScreen> createState() => CreateProfileScreenState();
}

class CreateProfileScreenState extends State<CreateProfileScreen> {
  bool? isBoySelected; 
  String name = '';
  String? nameError;  
  int selectedAvatarIndex = 0; 

  void validateName(String value) {
    setState(() {
      name = value;
      if (value.isEmpty) {
        nameError = 'Name is required';
      } else if (value.length < 3) {
        nameError = 'Name must be at least 3 characters';
      } else if (value.length > 6) {
        nameError = 'Name must be at most 6 characters';
      } else {
        nameError = null;
      }
    });
  }

  void showValidationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF74CF48),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1800),
        animation: CurvedAnimation(
          parent: const AlwaysStoppedAnimation(1),
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).size.height - 150,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: const Text('Create Profile',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
      leading: IconButton(
        icon: Image.asset('lib/asset/back_icon.png', width: 200, height: 200),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/');
        },
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
        const SizedBox(height: 44),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
          onTap: () {
            setState(() {
              isBoySelected = isBoySelected == true ? null : true;
            });
          },
                child: Row(
                children: [
              Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF74CF48),
                border: Border.all(
                  color: isBoySelected == true ? Colors.black : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                const Text(
                'Boy',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color.fromARGB(255, 255, 255, 255),
                ),
                ),
                const SizedBox(width: 8),
                Image.asset('lib/asset/boy.png', width: 40, height: 40),
                ],
              ),
              ),
                ],
                ),
              ),
              GestureDetector(
              onTap: () {
              setState(() {
                isBoySelected = isBoySelected == false ? null : false;
              });
              },
              child: Row(
              children: [
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                color: const Color(0xFFFF69B4),
                border: Border.all(
                  color: isBoySelected == false ? Colors.black : Colors.transparent,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
              children: [
              const Text(
                'Girl',
                style: TextStyle(
                 fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              const SizedBox(width: 8),
              Image.asset('lib/asset/girl.png', width: 40, height: 40),
              ],
                ),
                ),
              ], 
              ),
          ),
          ],
            ),
        const SizedBox(height: 50),
        SizedBox(
          height: 400,
          child: PageView.builder(
          itemCount: 13,
          onPageChanged: (index) {
            setState(() {
              selectedAvatarIndex = index;
            });
          },
          itemBuilder: (context, index) {
          return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
          'lib/asset/avatar/${index + 1}.png',
          width: 1200,
          height: 1200,
          fit: BoxFit.contain,
          ),
          );
          },
          ),
        ),
        const SizedBox(height: 35),
        const Text("Your Name",
          style: TextStyle(
          fontSize: 28,
            color: Color(0xFF525252)
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: validateName,
                maxLength: 6,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color(0xFFE5E5E5),
                  filled: true,
                  counterText: '',
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: nameError != null ? 25 : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: nameError != null ? 1.0 : 0.0,
                  child: nameError != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 5, left: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 16, color: Colors.red),
                              const SizedBox(width: 4),
                              Text(
                                nameError!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: 380,
          child: ElevatedButton(
            onPressed: () {
              if (isBoySelected == null) {
                showValidationSnackBar('Please select boy or girl');
              } else if (name.isEmpty || nameError != null) {
                showValidationSnackBar(nameError ?? 'Please enter a valid name');
              } else {
                final userModel = UserModel(
                  name: name,
                  age: 5,
                  isBoy: isBoySelected!,
                  avatarIndex: selectedAvatarIndex,
                );
                
                Navigator.of(context).pushReplacementNamed('/createAge', 
                  arguments: {
                    'userModel': userModel,
                  }
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF74CF48),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(
          fontSize: 24,
          color: Colors.white,
              ),
            ),
          ),
        ),
          ],
        ),
      ),
        );
  }
}