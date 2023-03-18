import 'dart:convert';

import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'razor_credentials.dart' as razorCredentials;

class PaymentPage extends StatefulWidget {

  const PaymentPage({ Key?key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _MyPaymentPage();
}
final _razorPay = Razorpay();
class _MyPaymentPage extends State<PaymentPage> {

  @override
  void initState()
  {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);
      _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentError);
      _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSuccess);
    });
    super.initState();
  }
  @override
  void dispose() {
    _razorPay.clear();
    super.dispose();
  }
  //create order
  void createOrder() async {
    String username = razorCredentials.keyId;
    String password = razorCredentials.keySecret;
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    Map<String, dynamic> body = {
      "amount":100,
      "currency":"INR",
      "receipt":"rcptid_11"
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com","v1/orders"),
      headers:<String,String>{
        "Content-type":"application/json",
        "authorization":basicAuth,
      },
      body:jsonEncode(body),
    );
    if(res.statusCode ==200){
      openGateway(jsonDecode(res.body)['id']);
    }

  }
  void openGateway(String orderId) {

    var Options = {
      "key":razorCredentials.keyId,
      'amount':100,
      "name":"AfterSchool",
      "order_id":orderId,
      "description":"Fine T-shirt",
      "timeout":60*5,

      "prefill":{
        "contact":"6387919701",
        "email":"afterschoolpvtltd@gmail.com",
      }
    };
    _razorPay.open(Options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff6633ff),
        title: const Text(
            "Payment"
        ),
        centerTitle: true,
      ),
      body: ListView(
          children: [

            Builder(
              builder: (context) =>
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: InkWell(
                        onTap: () =>createOrder(),
                        child: Card(
                          color: Colors.white,
                          elevation: 15,
                          child: Container(
                            height: 250,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Payment",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.payment,
                                    color: Colors.green,
                                    size: 30,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ]
      ),
    );
  }

  _pay(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(" Transaction successful "),
    ));
  }
  void _launchURL() async {
    final _razorPay = Razorpay();
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {

    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response){


    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }
  var options = {
    'key': '<YOUR_KEY_HERE>',
    'amount': 100,
    'name': 'Acme Corp.',
    'description': 'Fine T-Shirt',
    'prefill': {
      'contact': '8888888888',
      'email': 'test@razorpay.com'
    }
  };
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!, toastLength: Toast.LENGTH_SHORT);
  }
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 2000,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm', 'phonepe', 'tez']
      },
    };
  }
///calling the above method on button click.


}