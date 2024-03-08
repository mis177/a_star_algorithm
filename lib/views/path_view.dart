import 'package:a_star_algorithm/utils/a_star.dart';
import 'package:flutter/material.dart';

class PathView extends StatefulWidget {
  const PathView({super.key});

  @override
  State<PathView> createState() => _PathViewState();
}

class _PathViewState extends State<PathView> {
  late Map<int, Node> nodes;
  int? startTap;
  int? endTap;
  List<int> pathIndexes = [];
  List<int> obstacleBlocksIds = [];

  // define grid size
  final int _horizontalNodes = 8;
  final int _verticalNodes = 6;

  @override
  void initState() {
    generateObstacles();
    super.initState();
  }

  void generateObstacles() {
    nodes = getNodes(
        horizontalNodes: _horizontalNodes, verticalNodes: _verticalNodes);
    // generate random obstacle tiles, 1/4 of whole tiles
    List<int> randomList = List<int>.generate(
        _horizontalNodes * _verticalNodes, (int index) => index);
    randomList.shuffle();

    obstacleBlocksIds = randomList
        .take((_horizontalNodes * _verticalNodes / 4).round())
        .toList();

    for (var element in obstacleBlocksIds) {
      nodes[element]!.setNeighbors = [];
    }
  }

  final snackBar = const SnackBar(
    duration: Durations.long4,
    backgroundColor: Colors.red,
    content: Text('Path cannot be found!'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'A* algorithm',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 36, color: Colors.white),
        )),
        backgroundColor: Colors.grey[800],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _verticalNodes,
              ),
              itemCount: _verticalNodes * _horizontalNodes,
              itemBuilder: (BuildContext context, int index) {
                Color? cardColor;
                if (obstacleBlocksIds.contains(index)) {
                  cardColor = Colors.grey;
                } else if (index == startTap) {
                  cardColor = Colors.green;
                } else if (index == endTap) {
                  cardColor = Colors.red;
                } else if (pathIndexes.contains(index)) {
                  cardColor = Colors.yellow;
                }

                return GestureDetector(
                  child: Card(
                    color: cardColor,
                    child: Center(
                      child: Text((index + 1).toString()),
                    ),
                  ),
                  onTap: () {
                    if (startTap == null) {
                      setState(() {
                        startTap = index;
                      });
                    } else if (endTap == null) {
                      setState(() {
                        endTap = index;

                        pathIndexes = aStar(
                          start: nodes[startTap]!,
                          goal: nodes[endTap]!,
                          nodes: nodes,
                        );

                        if (pathIndexes.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    } else {
                      setState(() {
                        startTap = null;
                        endTap = null;
                        pathIndexes = [];
                      });
                    }
                  },
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    startTap = null;
                    endTap = null;
                    pathIndexes = [];
                    generateObstacles();
                  });
                },
                child: const Text('Generate new obstacles'))
          ],
        ),
      ),
    );
  }
}
