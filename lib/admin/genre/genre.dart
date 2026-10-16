// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_apps/admin/genre/input_genre.dart';
import 'package:movie_apps/admin/genre/update_genre.dart';
import 'package:movie_apps/admin/home_admin.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';

class Genre extends StatefulWidget {
  const Genre({super.key});
  static const routeName = '/genre';
  @override
  State<Genre> createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  final dio = Dio();
  bool isLoading = false;
  var dataGenre = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pink,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, HomeAdmin.routeName);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const Text('Genre', style: TextStyle(color: Colors.white))
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, InputGenre.routeName);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: const Color(0xFF232429),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                var genre = dataGenre[index];
                return ListTile(
                    title: Text(genre['name'],
                        style: const TextStyle(color: Colors.white)),
                    leading: const Icon(
                      Icons.movie,
                      color: Colors.white,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context,UpdateGenrePage.routeName, arguments: genre);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.yellowAccent,
                            size: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                title: 'Hapus Genre',
                                text:
                                    'Yakin ingin menghapus genre ${genre['name']}?',
                                confirmBtnText: 'Ya',
                                cancelBtnText: 'Tidak',
                                confirmBtnColor: Colors.red,
                                onConfirmBtnTap: () {
                                  deleteGenreResponse(genre['idGenre']);
                                });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ));
              },
              itemCount: dataGenre.length,
            ),
    );
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      Response response;
      response = await dio.get(getAllGenre);
      if (response.data['status'] == true) {
        dataGenre = response.data['data'];
      } else {
        dataGenre = [];
      }
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Server tidak meresponse'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void deleteGenreResponse(int id) async {
    try {
      Response response;

      response = await dio.delete(hapusGenre + id.toString());
      if (response.data['status'] == true) {
        toastification.show(
          context: context,
          title: Text(response.data['msg']),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored,
        );
        Navigator.pushNamed(context, Genre.routeName);
      }
    } catch (e) {
      print(e);
      toastification.show(
        context: context,
        title: Text('Terjadi kesalahan pada server'),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 3),
        style: ToastificationStyle.fillColored,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
