import 'package:flutter/material.dart';
import 'package:movie_apps/admin/genre/genre.dart';
import 'package:movie_apps/admin/genre/input_genre.dart';
import 'package:movie_apps/admin/genre/update_genre.dart';
import 'package:movie_apps/admin/home_admin.dart';
import 'package:movie_apps/admin/movie/input_movie.dart';
import 'package:movie_apps/admin/movie/movie.dart';
import 'package:movie_apps/admin/movie/update_movie.dart';
import 'package:movie_apps/admin/transaksi/transaksi.dart';
import 'package:movie_apps/auth/login_page.dart';
import 'package:movie_apps/auth/register_page.dart';
import 'package:movie_apps/users/beli_movie.dart';
import 'package:movie_apps/users/home_users.dart';
import 'package:movie_apps/users/transaksi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Apps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        RegisterPage.routeName: (context) => const RegisterPage(),
        HomeAdmin.routeName: (context) => const HomeAdmin(),
        HomeUsers.routeName: (context) => const HomeUsers(),
        Genre.routeName: (context) => const Genre(),
        InputGenre.routeName: (context) => const InputGenre(),
        UpdateGenrePage.routeName : (context) => const UpdateGenrePage(),
        MoviePage.routeName : (context) => const MoviePage(),
        InputMovie.routeName: (context) => const InputMovie(),
        UpdateMoviePage.routeName: (context) => const UpdateMoviePage(),
        BeliMovie.routeName : (context) => const BeliMovie(),
        TransaksiUser.routeName: (context) => const TransaksiUser(),
        TransaksiAdmin.routeName: (context) => const TransaksiAdmin(),
      },
    );
  }
}