import 'package:aub_gymsystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({Key? key}) : super(key: key);

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutorials"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "“Train smart, lift right – let tutorials be your guide to a stronger you.”",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPage == 0
                              ? ConstantsClass.themeColor
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Beginner",
                            style: TextStyle(
                              fontSize: 18,
                              color: selectedPage == 0
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: selectedPage == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPage == 1
                              ? ConstantsClass.themeColor
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Advanced",
                            style: TextStyle(
                              fontSize: 18,
                              color: selectedPage == 1
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: selectedPage == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedPage = 2;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPage == 2
                              ? ConstantsClass.themeColor
                              : Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Gym Machines",
                            style: TextStyle(
                              fontSize: 18,
                              color: selectedPage == 2
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: selectedPage == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(
                height: 8,
              ),
            ),
            // Conditionally render the SliverGrid based on the selected page
            if (selectedPage == 0)
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Future<void> launchUrl(String url) async {
                          if (!await launch(url)) {
                            throw Exception('Could not launch $url');
                          }
                        }

                        launchUrl(ConstantsClass().linksList1[index]);
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Card(
                            elevation: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                ConstantsClass().imagesList1[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              ConstantsClass().textList1[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  childCount:
                      ConstantsClass().imagesList1.length, // Number of cards
                ),
              )
            else if (selectedPage == 1)
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Future<void> launchUrl(String url) async {
                          if (!await launch(url)) {
                            throw Exception('Could not launch $url');
                          }
                        }

                        launchUrl(ConstantsClass().linksList2[index]);
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Card(
                            elevation: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                ConstantsClass().imagesList2[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              ConstantsClass().textList1[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  childCount:
                      ConstantsClass().textList1.length, // Number of cards
                ),
              )
            else
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset("Assets/machines.png")),
                        ),
                      ],
                    ),
                  ),
                ), // Display empty container
              ),
          ],
        ),
      ),
    );
  }
}
