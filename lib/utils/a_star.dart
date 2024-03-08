import 'dart:math';

import 'package:flutter/material.dart';

class Node {
  final int id;
  List<int> neighborsId;
  final Offset position;

  List<int> get neighbors => neighborsId;

  set setNeighbors(List<int> neighbors) => {neighborsId = neighbors};

  Node({required this.id, required this.neighborsId, required this.position});
}

Map<int, Node> getNodes(
    {required int horizontalNodes, required int verticalNodes}) {
  double currentHorizontalNode = 1;
  double currentVerticalNode = 1;

  // populate nodes based on their position in grid
  Map<int, Node> nodes = {};
  for (int i = 0; i < (horizontalNodes * verticalNodes); i++) {
    List<int> neighbors = [];
    if (currentHorizontalNode == 1) {
      if (currentVerticalNode == 1) {
        neighbors = [i + 1, i + verticalNodes];
      } else if (currentVerticalNode == verticalNodes) {
        neighbors = [i - 1, i + verticalNodes];
      } else {
        neighbors = [i - 1, i + 1, i + verticalNodes];
      }
    } else if (currentHorizontalNode == horizontalNodes) {
      if (currentVerticalNode == 1) {
        neighbors = [i + 1, i - verticalNodes];
      } else if (currentVerticalNode == verticalNodes) {
        neighbors = [i - 1, i - verticalNodes];
      } else {
        neighbors = [i - 1, i + 1, i - verticalNodes];
      }
    } else if (currentVerticalNode == 1) {
      neighbors = [i - verticalNodes, i + verticalNodes, i + 1];
    } else if (currentVerticalNode == verticalNodes) {
      neighbors = [i - verticalNodes, i + verticalNodes, i - 1];
    } else {
      if (currentVerticalNode == 1) {
        neighbors = [i + 1, i - verticalNodes, i + verticalNodes];
      } else if (currentVerticalNode == verticalNodes) {
        neighbors = [i - 1, i - verticalNodes, i + verticalNodes];
      } else {
        neighbors = [i - 1, i + 1, i - verticalNodes, i + verticalNodes];
      }
    }
    nodes[i] = Node(
        id: i,
        neighborsId: neighbors,
        position: Offset(currentHorizontalNode, currentVerticalNode));

    currentVerticalNode = currentVerticalNode + 1;

    if (currentVerticalNode > verticalNodes) {
      currentVerticalNode = 1;
      currentHorizontalNode = currentHorizontalNode + 1;
    }
  }

  return nodes;
}

double distance(Node start, Node end) {
  return sqrt(pow(start.position.dx - end.position.dx, 2) +
      pow(start.position.dy - end.position.dy, 2));
}

List<int> reconstructPath(
    {required Map<int, int> cameFrom, required Node current}) {
  int currentId = current.id;
  List<int> path = [currentId];
  while (cameFrom.keys.contains(currentId)) {
    currentId = cameFrom[currentId]!;
    path.add(currentId);
  }

  return path.reversed.toList();
}

List<int> aStar(
    {required Node start, required Node goal, required Map<int, Node> nodes}) {
  Set<Node> openSet = {start};
  Map<int, int> cameFrom = {};

  Map<int, double> gScore = {};
  gScore[start.id] = 0;

  Map<int, double> fScore = {};
  fScore[start.id] = distance(start, goal);

  while (openSet.isNotEmpty) {
    double lowestFScore = double.infinity;
    Node current = openSet.first;
    for (var element in openSet) {
      if (fScore[element.id]! < lowestFScore) {
        lowestFScore = fScore[element.id]!;
        current = element;
      }
    }
    if (current.id == goal.id) {
      return reconstructPath(cameFrom: cameFrom, current: current);
    }
    openSet.remove(current);

    for (var neighbor in current.neighbors) {
      double tentativeGScore =
          gScore[current.id]! + distance(current, nodes[neighbor]!);
      if (gScore[neighbor] == null) {
        gScore[neighbor] = double.infinity;
      }
      if (tentativeGScore < gScore[neighbor]!) {
        cameFrom[neighbor] = current.id;
        gScore[neighbor] = tentativeGScore;
        fScore[neighbor] = tentativeGScore + distance(nodes[neighbor]!, goal);
        if (!openSet.contains(nodes[neighbor])) {
          openSet.add(nodes[neighbor]!);
        }
      }
    }
  }
  return [];
}

 // return aStar(nodes[1]!, nodes[6]!);

