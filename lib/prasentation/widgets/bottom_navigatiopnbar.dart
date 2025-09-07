import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/bottom_bar/bottom_bloc.dart';
import 'package:movie_app/bloc/bottom_bar/bottom_event.dart';
import 'package:movie_app/bloc/bottom_bar/bottom_state.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/prasentation/bookmark/bookmarks_screen.dart';
import 'package:movie_app/prasentation/home_page/home_page.dart';
import 'package:movie_app/prasentation/search_page/search_screen.dart';

class Base extends StatelessWidget {
  final MovieRepository movieRepository;
  Base({required this.movieRepository});

  List<Widget> get _pages => [
    HomeScreen(movieRepository: movieRepository),
    SearchScreen(),
    BookmarkScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            body: _pages[state.selectedIndex],
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BottomNavigationBar(
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: state.selectedIndex,
                  onTap: (index) {
                    context.read<BottomNavBloc>().add(
                      BottomNavItemSelected(index),
                    );
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled, size: 22),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search_rounded, size: 22),
                      label: "Search",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_border, size: 22),
                      label: "Bookmark",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
