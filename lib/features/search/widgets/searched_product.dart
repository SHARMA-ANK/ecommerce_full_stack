import 'package:amazon_clone/constants/commons/stars.dart';
import 'package:amazon_clone/models/product.dart';

import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  const SearchedProduct({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    double averageRating = 0;

    print(product.rating!.length);
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }
    averageRating = totalRating / product.rating!.length;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.fitHeight,
                height: 135,
                width: 135,
              ),
              Column(
                children: [
                  Container(
                    width: 235,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      product.name,
                      style: TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                      width: 235,
                      padding: EdgeInsets.only(left: 10, top: 5),
                      child: Stars(rating: averageRating)),
                  Container(
                    width: 235,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '\$${product.price}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    width: 235,
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text("Eligible for Free Shipping"),
                  ),
                  Container(
                    width: 235,
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    child: Text(
                      "In Stock",
                      style: TextStyle(color: Colors.teal),
                      maxLines: 2,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
