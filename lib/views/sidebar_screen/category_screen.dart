import 'package:app_web/views/sidebar_screen/widgets/category_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../controllers/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category-screen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryController _categoryController = CategoryController();
  late String name;
  dynamic _bannerImage;
  dynamic _image;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              Text(
                'Category Screen',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Divider(),

              const SizedBox(height: 10),
              Text("Image Preview", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),

              // MAIN WRAP (Image + Form)
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  // -------- Category Image --------
                  Card(
                    elevation: 2,
                    child: Stack(
                      children: [
                        Container(
                          width: 300,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.memory(
                                    _image,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(child: Text("Category Image")),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: pickImage,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // -------- FORM --------
                  SizedBox(
                    width: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          onChanged: (value) => name = value,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter category name'
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Enter Category Name',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        SizedBox(height: 15),

                        Row(
                          children: [
                            TextButton(onPressed: () {}, child: Text("Cancel")),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await _categoryController.uploadCategory(
                                    pickedImage: _image,
                                    pickedBanner: _bannerImage,
                                    name: name,
                                    context: context,
                                  );
                                }
                              },
                              child: Text("Save"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),

              // -------- Banner Image --------
              Text("Banner Preview", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),

              Card(
                elevation: 2,
                child: Stack(
                  children: [
                    Container(
                      width: 300,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: _bannerImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.memory(
                                _bannerImage,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(child: Text("Category Banner")),
                    ),

                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: pickBannerImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Divider(),
              const SizedBox(height: 20),

              // -------- Category LIST WIDGET --------
              CategoryWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
