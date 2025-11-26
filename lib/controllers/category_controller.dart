import 'dart:convert';

import 'package:app_web/global_variable.dart';
import 'package:app_web/models/category.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;

class CategoryController {
  uploadCategory({
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required String name,
    required context,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dgbyvtftl", 'qhxsafcv');
      //upload image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedImage',
          folder: 'categoryImages',
        ),
      );
      String image = imageResponse.secureUrl;

      //upload banner
      CloudinaryResponse bannerResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: 'pickedBanner',
          folder: 'categoryBanners',
        ),
      );
      String banner = bannerResponse.secureUrl;

      Category category = Category(
        id: '',
        name: name,
        image: image,
        banner: banner,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/category'),
        body: category.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Category uploaded successfully');
        },
      );
    } catch (e) {
      throw Exception('Error uploading to Cloudinary: $e');
    }
  }

  //load uploaded categories
  Future<List<Category>> loadCategories() async {
    try {
      //send http request
      http.Response response = await http.get(
        Uri.parse('$uri/api/category'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Category> categories = data
            .map((category) => Category.fromJson(category))
            .toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
