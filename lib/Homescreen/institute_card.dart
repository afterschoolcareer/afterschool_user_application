import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstituteCard extends StatefulWidget {
  const InstituteCard({Key? key}) : super(key: key);

  @override
  State<InstituteCard> createState() => _InstituteCardState();
}

class _InstituteCardState extends State<InstituteCard> {

  void onViewDetailsTapped() {
    print("view details tapped");
  }

  void onShortlistButtonTapped() {
    print("shortlist button tapped");
  }

  void onSendButtonTapped() {
    print("Send button tapped");
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *0.90,
      height: 270,
      child: Container(
        padding: const EdgeInsets.only(top:30, left:10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
            color: Color(0xff9999ff),
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(0, 0)
          )
          ]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                /* logo container */
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("images/smicon22.png"))),
                ),

                /* Institute name and Location and Fees */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ABC Institute",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                              text: "New Delhi",
                            style: TextStyle(
                              color: Colors.black
                            )
                          ),
                          TextSpan(
                              text: " • ",
                            style: TextStyle(
                              color: Colors.black
                            )
                          ),
                          TextSpan(
                            text: "₹ 1.7 Lakhs",
                            style: TextStyle(
                              color: Colors.black
                            )
                          )
                        ],
                      ),
                    )
                  ],
                ),

                /* rating Star */
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),

                /* Rating Value */
                const Text(
                  "4.7",
                )
              ],
            ),

            const SizedBox(height: 20),
            /* data metrics */
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff9999ff),
                        ),
                        child: const Text(
                          "97%",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Selection",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Rate",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff9999ff),
                        ),
                        child: const Text(
                          "AIR 5",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Top",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "Rank",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff9999ff),
                        ),
                        child: const Text(
                          "33",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "In Top",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        "100",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: onViewDetailsTapped,
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      width: MediaQuery.of(context).size.width / 2,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xff9999ff),
                      ),
                      child: const Text(
                        "View Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: onShortlistButtonTapped,
                      icon: const Icon(
                        Icons.bookmark_border_outlined,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: onSendButtonTapped,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.black,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
