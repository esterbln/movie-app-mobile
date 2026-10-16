import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_apps/admin/model/genre_modal.dart';
import 'package:movie_apps/admin/movie/movie.dart';
import 'package:movie_apps/api_service/api.dart';
import 'package:toastification/toastification.dart';

class InputMovie extends StatefulWidget {
  const InputMovie({super.key});
  static const routeName = '/input-movie';

  @override
  State<InputMovie> createState() => _InputMovieState();
}

class _InputMovieState extends State<InputMovie> {
  final dio = Dio();

  bool isLoading = false;

  int? idGenre;

  TextEditingController titlecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController ratingcontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  GenreModel? _selectedGenre;

  Future<List<GenreModel>> getData() async {
    try {
      var response = await Dio().get(getAllGenre);
      final data = response.data["data"];
      if (data != null) {
        return GenreModel.fromJsonList(data);
      }
    } catch (e) {
      throw Exception('Terjadi Kesalahan: $e');
    }
    return [];
  }

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });
      }
    } catch (e) {
      throw Exception("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Form Input Movie !",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: titlecontroller,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: pricecontroller,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: descriptioncontroller,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: ratingcontroller,
                decoration: const InputDecoration(
                  labelText: "Rating",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              DropdownSearch<GenreModel>(
                popupProps: PopupProps.dialog(
                  itemBuilder:
                      (BuildContext context, GenreModel item, bool isDisabled) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        title: Text(item.name),
                        leading: CircleAvatar(child: Text(item.name[0])),
                      ),
                    );
                  },
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Search Genre...",
                    ),
                  ),
                ),
                asyncItems: (String? filter) => getData(),
                itemAsString: (GenreModel? item) => item?.userAsString() ?? "",
                onChanged: (GenreModel? data) {
                  setState(() {
                    _selectedGenre = data;
                    idGenre = data?.idGenre;
                  });
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Select Genre",
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
                selectedItem: _selectedGenre,
                dropdownBuilder:
                    (BuildContext context, GenreModel? selectedItem) {
                  return Text(
                    selectedItem?.name ?? "Select Genre",
                    style: const TextStyle(
                      color: Colors.black, // Warna teks yang dipilih
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(50)),
                child: const Text(
                  "Pilih Gambar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _imageBytes != null
                  ? Image.memory(
                      _imageBytes!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : const Text(
                      "Tidak ada gambar yang dipilih",
                      style: TextStyle(color: Colors.black),
                    ),
              const SizedBox(
                height: 32,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        inputMovieResponse();
                        // if (genrecontroller.text.isEmpty && genrecontroller.text == '') {
                        //   toastification.show(
                        //       context: context,
                        //       title: const Text("Username Tidak Boleh Kosong!"),
                        //       type: ToastificationType.error,
                        //       autoCloseDuration: const Duration(seconds: 3),
                        //       style: ToastificationStyle.fillColored);
                        // } else {
                        //   inputResponse();
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          minimumSize: const Size.fromHeight(50)),
                      child: const Text(
                        "Input Movie",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      )),
    );
  }

  void inputMovieResponse() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 2));
      FormData formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(_imageBytes!, filename: 'test.jpg'),
        "title": titlecontroller.text,
        "price": pricecontroller.text,
        "genre": idGenre.toString(),
        "rating": ratingcontroller.text,
        "description": descriptioncontroller.text
      });
      Response response;
      response = await dio.post(inputMovie, data: formData);
      if (response.data['status'] == true) {
        toastification.show(
            context: context,
            title: Text(response.data['msg']),
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            style: ToastificationStyle.fillColored);
        Navigator.pushNamed(context, MoviePage.routeName);
      }
    } catch (e) {
      toastification.show(
          context: context,
          title: const Text("Terjadi kesalahan pada server"),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
          style: ToastificationStyle.fillColored);
    } finally {
      setState(() {
        (() {
          isLoading = false;
        });
      });
    }
  }
}
