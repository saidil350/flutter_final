import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 311,
      height: 324,
      child: Stack(
        children: [
          // Shapes Background
          Positioned(
            left: 0,
            top: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1
                Column(
                  children: [
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFE0533D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF377CC8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFE78C9D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Column 2
                Column(
                  children: [
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF9DA7D0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(121),
                        ),
                      ),
                    ),
                    Container(
                      width: 103.67,
                      height: 103.67,
                      color: const Color(0xFFEED868),
                    ),
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF469B88),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Column 3
                Column(
                  children: [
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: const ShapeDecoration(
                        color: Color(0xFF469B88),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFEED868),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 103.67,
                      height: 103.67,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF377CC8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(121),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Image Overlay - Centered
          Center(
            child: Container(
              width: 249,
              height: 313,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://placehold.co/249x313"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
