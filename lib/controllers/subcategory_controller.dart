import 'package:app_web/global_variable.dart';
import 'package:app_web/services/manage_http_response.dart';
import 'package:cloudinary_public/cloudinary_public.dart';

import '../models/subcategory.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  uploadSubcategory({
    required String categoryId,
    required String categoryName,
    required dynamic pickedImage,
    required String subCategoryName,
    required context,
  }) async {
    // Upload subcategory logic here
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
      Subcategory subcategory = Subcategory(
        id: '',
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
        subCategoryName: subCategoryName,
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/subcategories'),
        body: subcategory.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Subcategory uploaded successfully');
        },
      );
    } catch (e) {
      throw Exception('Failed to upload subcategory: $e');
    }
  }
}
