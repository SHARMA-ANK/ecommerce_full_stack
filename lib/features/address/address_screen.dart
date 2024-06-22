import 'package:amazon_clone/constants/commons/custom_textField.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pay/pay.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});
  static const String routeName = '/address-screen';
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flatBuildingController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    areaController.dispose();
  }

  List<PaymentItem> paymentItems = [];
  void onApplePayResult() {}
  final _addressFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              address.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              address,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'OR',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 10,
                    ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                        controller: flatBuildingController,
                        hintText: "Flat, House no, Building"),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                        controller: areaController, hintText: "Area , Street"),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: "Pincode",
                      controller: pincodeController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      hintText: "Town/City",
                      controller: cityController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              GooglePayButton(
                width: double.infinity,
                type: GooglePayButtonType.pay,
                theme: GooglePayButtonTheme.dark,
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString('googlePay.json'),
                paymentItems: paymentItems,
                onPaymentResult: (result) => {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
