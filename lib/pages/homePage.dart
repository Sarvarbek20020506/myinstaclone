import 'package:clone_insta/pages/MypostCeare_page.dart';
import 'package:clone_insta/pages/feedpage.dart';
import 'package:clone_insta/pages/mylikes_page.dart';
import 'package:clone_insta/pages/profile_page.dart';
import 'package:clone_insta/pages/searchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  static final String id ="home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController? _pageController;
  int _currentTap = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              MyFeedPage(pageController: _pageController,),
              MySearchPage(),
              MyPostCreatePage(pageController:_pageController),
              MyLikesPage(),
              MyProfilePage(),
            ],

            onPageChanged: (int index){
              setState(() {
                _currentTap = index;
              });
            }
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTap,
        onTap: (int index){
          setState(() {
            _currentTap = index;
            _pageController!.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 32,
            ),
          )
        ],
      ),
    );
  }
}
