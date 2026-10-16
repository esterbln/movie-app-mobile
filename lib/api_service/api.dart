// Alamat API (movie-rest-api).
// Chrome atau Windows: http://localhost:3000
// Emulator Android: http://10.0.2.2:3000
// HP asli: ganti dengan IP laptop di jaringan Wi-Fi yang sama
String baseUrl = "http://localhost:3000";

//image
String imageUrl = '$baseUrl/img/movie/';

//auth
String register = "$baseUrl/users/register";
String login = "$baseUrl/users/login";

//genre
String getAllGenre = "$baseUrl/genre/get";
String insertGenre = "$baseUrl/genre/insert";
String hapusGenre = "$baseUrl/genre/delete/";
String editGenre = "$baseUrl/genre/edit/";

//movie
String getAllMovie = "$baseUrl/movie/get-all";
String hapusMovie = "$baseUrl/movie/delete/";
String inputMovie = "$baseUrl/movie/insert";
String editMovie = "$baseUrl/movie/edit/";

//transaksi
String insertTransaksi = "$baseUrl/transaction/insert";
String getTransaksi = "$baseUrl/transaction/get-all";
String getTransaksiId = "$baseUrl/transaction/get/";
String confirmTranskasi = "$baseUrl/transaction/confirm-transaction/";
