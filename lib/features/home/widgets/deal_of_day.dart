import 'package:amazon_clone/constants/commons/loader.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  HomeServices homeServices = HomeServices();
  Product? product;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDealOfDay();
  }

  void navigateToProductDetailsScreen() {
    Navigator.pushNamed(context, ProductDetailsScreen.routeName,
        arguments: product);
  }

  fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
    print("Product=${product!.name}");
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? Loader()
        : product!.name.isEmpty
            ? SizedBox()
            : GestureDetector(
                onTap: navigateToProductDetailsScreen,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(top: 15, left: 10),
                      child: Text(
                        "Deal of The day",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Image.network(
                      product!.images[0],
                      height: 235,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "\$${product!.price}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 15, top: 5, right: 40),
                      child: Text(
                        product!.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: product!.images
                              .map((e) => Image.network(
                                    e,
                                    fit: BoxFit.fitWidth,
                                    width: 100,
                                    height: 100,
                                  ))
                              .toList()),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, bottom: 15, top: 15),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "See All Deals",
                        style: TextStyle(color: Colors.cyan),
                      ),
                    )
                  ],
                ),
              );
  }
}
