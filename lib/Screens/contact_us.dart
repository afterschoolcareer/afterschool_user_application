import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  void sendEmail() {
    Uri emailData = Uri.parse('mailto:contact@afterschoolcareer.com?subject=Issue');
    launchUrl(emailData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Contact Us"),
        centerTitle: true,
        backgroundColor: const Color(0xff6633ff),
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Image.asset('images/contact_us.jpg'),
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xff6633ff),
                  child: Column(
                    children: const [
                      Text(
                        "Queries?",
                        style: TextStyle(
                            fontSize: 20,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Technical Issues?",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Booking Issues?",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Feedback?",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Need Admission Counselling?",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                    "We'd love to hear it all !",
                  style: TextStyle(
                      fontSize: 25,
                    color: Color(0xffff9900)
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffff9900)
                    ),
                      onPressed: sendEmail,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text("Contact Us",style: TextStyle(color: Colors.white),),
                          Icon(
                            Icons.email,
                            color: Colors.white,
                          )
                        ],
                      )
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
