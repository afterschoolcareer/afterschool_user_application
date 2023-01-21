import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InstituteCard extends StatefulWidget {
  final String logo_url;
  final String name;
  final String location;
  final String fees;
  final String selection_rate;
  final String top_rank;
  final String in_top_100;
  final String rating;
  const InstituteCard(this.logo_url, this.name, this.location, this.fees,
      this.selection_rate, this.top_rank, this.in_top_100, this.rating, {Key? key}
      ) : super(key: key);

  @override
  State<InstituteCard> createState() => _InstituteCardState(logo_url, name, location,
  fees, selection_rate, top_rank, in_top_100, rating);
}

class _InstituteCardState extends State<InstituteCard> {
  final String logo_url;
  final String name;
  final String location;
  final String fees;
  final String selection_rate;
  final String top_rank;
  final String in_top_100;
  final String rating;
  _InstituteCardState(
      this.logo_url, this.name, this.location, this.fees,
      this.selection_rate, this.top_rank, this.in_top_100, this.rating
      );

  void onViewDetailsTapped() {
    print("view details tapped :$name");
  }

  void onShortlistButtonTapped() {
    setState(() {
      isShortlisted = !isShortlisted;
    });
    print("shortlist button tapped");
  }

  bool isShortlisted = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *0.90,
      height: 260,
      child: Container(
        padding: const EdgeInsets.only(top:20, left:10, right: 10),
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
                      image:  DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(logo_url))),
                ),

                /* Institute name and Location and Fees */
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: location,
                            style: const TextStyle(
                              color: Colors.black
                            )
                          ),
                          const TextSpan(
                              text: " • ",
                            style: TextStyle(
                              color: Colors.black
                            )
                          ),
                          TextSpan(
                            text: fees,
                            style: const TextStyle(
                              color: Colors.black
                            )
                          )
                        ],
                      ),
                    )
                  ],
                ),

                /* rating Star */
               Row(
                 children: [
                   const Icon(
                     Icons.star,
                     color: Colors.amber,
                   ),
                   const SizedBox(width: 6),
                   /* Rating Value */
                   Text(
                     rating,
                   )
                 ],
               )
              ],
            ),

            const SizedBox(height: 20),
            /* data metrics */
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff6633ff),
                        ),
                        child: Text(
                          selection_rate,
                          style: const TextStyle(
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
                          color: Color(0xff6633ff),
                        ),
                        child: Text(
                          top_rank,
                          style: const TextStyle(
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
                  const SizedBox(width: 18),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff6633ff),
                        ),
                        child: Text(
                          in_top_100,
                          style: const TextStyle(
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
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: onViewDetailsTapped,
                    child: Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width / 1.6,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff6633ff),
                      ),
                      child: const Text(
                        "View Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Transform.scale(
                    scale: 1.5,
                    child: IconButton(
                        onPressed: onShortlistButtonTapped,
                        icon: Icon(
                          isShortlisted?
                          FluentSystemIcons.ic_fluent_bookmark_filled :
                          FluentSystemIcons.ic_fluent_bookmark_regular,
                          // Icons.bookmark_add_outlined,
                          color: isShortlisted?
                          const Color(0xff6633ff) : Colors.black,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
