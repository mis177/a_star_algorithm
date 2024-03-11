import 'package:a_star_algorithm/utils/a_star.dart';
import 'package:flutter/material.dart';

class PathModel extends ChangeNotifier {
  Map<int, Node> _nodes = {};
  List<int> _shortestPath = [-1];
  int? _startTap;
  int? _endTap;
  List<int> _obstacleBlocksIds = [];

  List<int> get obstacleBlocksIds => _obstacleBlocksIds;
  List<int> get shortestPath => _shortestPath;

  void generateNodes(int horizontalNodes, int verticalNodes) {
    _nodes = getNodes(
        horizontalNodes: horizontalNodes, verticalNodes: verticalNodes);

    // generate random obstacle tiles, 1/4 of whole tiles
    List<int> randomList = List<int>.generate(
        horizontalNodes * verticalNodes, (int index) => index);
    randomList.shuffle();

    _obstacleBlocksIds =
        randomList.take((horizontalNodes * verticalNodes / 4).round()).toList();

    for (var element in _obstacleBlocksIds) {
      _nodes[element]!.setNeighbors = [];
    }
  }

  void gridClicked(int index) {
    if (_startTap == null) {
      _startTap = index;
    } else if (_endTap == null) {
      _endTap = index;

      _shortestPath = aStar(
        start: _nodes[_startTap]!,
        goal: _nodes[_endTap]!,
        nodes: _nodes,
      );
    } else {
      _startTap = null;
      _endTap = null;
      _shortestPath = [-1];
    }

    notifyListeners();
  }

  Color? getCardColor(int index) {
    Color? cardColor;

    if (_obstacleBlocksIds.contains(index)) {
      cardColor = Colors.grey;
    } else if (index == _startTap) {
      cardColor = Colors.green;
    } else if (index == _endTap) {
      cardColor = Colors.red;
    } else if (_shortestPath.contains(index)) {
      cardColor = Colors.yellow;
    }
    return cardColor;
  }

  void restartClicked(int horizontalNodes, int verticalNodes) {
    _startTap = null;
    _endTap = null;
    _shortestPath = [-1];
    generateNodes(horizontalNodes, verticalNodes);
    notifyListeners();
  }
}
