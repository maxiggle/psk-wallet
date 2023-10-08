import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(),
              IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset('assets/images/settings.svg')),
            ],
          )
        ],
      ),
    );
  }
}
