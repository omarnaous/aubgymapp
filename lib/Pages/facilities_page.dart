import 'package:aub_gymsystem/Pages/facilities_reservations_page.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:flutter/material.dart';

class FacilitiesPage extends StatefulWidget {
  const FacilitiesPage({super.key});

  @override
  State<FacilitiesPage> createState() => _FacilitiesPageState();
}

class _FacilitiesPageState extends State<FacilitiesPage> {
  List images = [
    'Assets/Pool.png',
    'Assets/Squash.png',
    'Assets/Tennis.png',
  ];

  List text = ["Pool", "Squash Court", "Tennis Court"];

  List numberofLanes = [4, 2, 4];
  List numberofSpots = [2, 1, 1];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Facilities Page"),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Facilities Available",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        text[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        const Spacer(),
                        FloatingActionButton(
                          backgroundColor: ConstantsClass.secondaryColor,
                          child: Image.asset(
                            ConstantsClass.reserve,
                            fit: BoxFit.cover,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return FacilitiesReservationPage(
                                    facilityName: text[index],
                                    lanesNumber: numberofLanes[index],
                                    numberofSpots: numberofSpots[index],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
            ),
          )
        ],
      ),
    );
  }
}
