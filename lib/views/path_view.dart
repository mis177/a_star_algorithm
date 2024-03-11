import 'package:a_star_algorithm/models/path_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PathView extends StatelessWidget {
  const PathView({super.key});

  // defines size of the grid
  final int _horizontalNodes = 8;
  final int _verticalNodes = 6;

  final snackBar = const SnackBar(
    duration: Durations.long4,
    backgroundColor: Colors.red,
    content: Text('Path cannot be found!'),
  );

  @override
  Widget build(BuildContext context) {
    context.read<PathModel>().generateNodes(_horizontalNodes, _verticalNodes);
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
            Consumer<PathModel>(
              builder: (context, pathModel, child) {
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _verticalNodes,
                  ),
                  itemCount: _verticalNodes * _horizontalNodes,
                  itemBuilder: (BuildContext context, int index) {
                    Color? cardColor = pathModel.getCardColor(index);

                    return GestureDetector(
                      child: Card(
                        color: cardColor,
                        child: Center(
                          child: Text((index + 1).toString()),
                        ),
                      ),
                      onTap: () {
                        pathModel.gridClicked(index);

                        if (pathModel.shortestPath.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    );
                  },
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  context
                      .read<PathModel>()
                      .restartClicked(_horizontalNodes, _verticalNodes);
                },
                child: const Text('Generate new obstacles'))
          ],
        ),
      ),
    );
  }
}
