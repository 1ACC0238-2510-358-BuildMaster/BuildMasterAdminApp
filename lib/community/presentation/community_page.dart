import 'package:flutter/material.dart';
import 'pages/moderation_screen.dart';
import 'pages/post_management_screen.dart';
import 'pages/settings_screen.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.report), text: 'Moderación'),
            Tab(icon: Icon(Icons.forum), text: 'Posts'),
            Tab(icon: Icon(Icons.settings), text: 'Ajustes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ModerationScreen(),
          PostManagementScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
