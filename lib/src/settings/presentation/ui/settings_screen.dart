import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  final String name = 'Laila';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Image.asset(
            'assets/avatar.png',
            height: 170,
            width: 170,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            name,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
              color: CustomColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Divider(
            color: CustomColors.primary,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          SizedBox(height: 40),
          _SettingsTile(
            title: 'Profile',
            icon: Icons.person_3_outlined,
          ),
          _SettingsTile(
            title: 'Logout',
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingsTile({
    required this.icon,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: ListTile(
        leading: Icon(
          icon,
          color: CustomColors.background,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: CustomColors.background,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        tileColor: CustomColors.primary,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: CustomColors.background,
          size: 17,
        ),
        onTap: () {},
      ),
    );
  }
}
