import 'package:app_web/controllers/category_controller.dart';
import 'package:app_web/controllers/subcategory_controller.dart';
import 'package:app_web/models/category.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = 'subcategory-screen';
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final SubcategoryController subcategoryController = SubcategoryController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Category>> futureCategories;
  late String name;
  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subcategory Screen',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Divider(color: Colors.grey),
            SizedBox(height: 10),
            FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text("No categories found");
                }

                final categories = snapshot.data!;

                return Container(
                  width: 300,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButton<Category>(
                    value: selectedCategory,
                    hint: Text("Select Category"),
                    isExpanded: true,
                    underline: SizedBox(),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                );
              },
            ),

            SizedBox(height: 20),
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
                                child: Image.memory(_image, fit: BoxFit.cover),
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
                            child: Icon(Icons.camera_alt, color: Colors.white),
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
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await subcategoryController.uploadSubcategory(
                                  categoryId: selectedCategory!.id,
                                  categoryName: selectedCategory!.name,
                                  pickedImage: _image,
                                  subCategoryName: name,
                                  context: context,
                                );

                                setState(() {
                                  _formKey.currentState!.reset();
                                  _image = null;
                                  selectedCategory = null;
                                });
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
          ],
        ),
      ),
    );
  }
}
