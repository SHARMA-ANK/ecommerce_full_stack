import 'dart:io';

import 'package:amazon_clone/constants/commons/custom_button.dart';
import 'package:amazon_clone/constants/commons/custom_textField.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static const String routeName = '/add-product';
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final _addProductFormKey = GlobalKey<FormState>();
  String category = "Mobiles";
  List<String> productCategories = [
    'Books',
    'Appliances',
    'Essentials',
    'Mobiles',
    'Fashion',
  ];
  @override
  void dispose() {
    // TODO: implement dispose
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  List<File> images = [];
  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  final AdminServices adminServices = AdminServices();
  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      adminServices.sellProduct(
          context: context,
          name: productNameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          quantity: double.parse(quantityController.text),
          category: category,
          images: images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
            flexibleSpace: Container(
              decoration:
                  BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: const Text("Add Products",
                style: TextStyle(
                  color: Colors.black,
                ))),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _addProductFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  images.isEmpty
                      ? GestureDetector(
                          onTap: selectImages,
                          child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              dashPattern: [10, 4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Select Product Images",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400),
                                    )
                                  ],
                                ),
                              )),
                        )
                      : CarouselSlider(
                          items: images.map((i) {
                            return Builder(
                                builder: (BuildContext context) => Image.file(
                                      i,
                                      fit: BoxFit.cover,
                                      height: 200,
                                    ));
                          }).toList(),
                          options: CarouselOptions(
                              viewportFraction: 1, height: 200)),
                  SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                      hintText: "Product Name",
                      controller: productNameController),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintText: "Description",
                    controller: descriptionController,
                    maxLines: 7,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintText: "Price",
                    controller: priceController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    hintText: "Quantity",
                    controller: quantityController,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: category,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: productCategories.map((String item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (String? newVal) {
                        setState(() {
                          category = newVal!;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(onTap: sellProduct, text: "Sell")
                ],
              ),
            )),
      ),
    );
  }
}
