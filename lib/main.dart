import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: GameScreen(),
  ));
}

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<List<int>> _gameMatrix = [
    [1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 1, 1, 2, 1, 3, 1, 4, 1],
    [5, 1, 6, 1, 7, 1, 8, 1, 9],
  ];

  NumObj _select;

  void removeVoidRows() {
    for (int row = 0; row < _gameMatrix.length; row++) {
      bool hasNum = false;
      for (int num in _gameMatrix[row]) {
        if (num != null) {
          hasNum = true;
          break;
        }
      }
      if (!hasNum) {
        setState(() {
          _gameMatrix.removeAt(row);
        });
      }
    }
  }

  void addLines() {
    List<int> tempList = [];
    for (int row = 0; row < _gameMatrix.length; row++) {
      for (int col = 0; col < _gameMatrix[row].length; col++) {
        if (_gameMatrix[row][col] != null) {
          tempList.add(_gameMatrix[row][col]);
        }
      }
    }
    while (
        _gameMatrix[_gameMatrix.length - 1].length < 9 && tempList.length > 0) {
      setState(() {
        _gameMatrix[_gameMatrix.length - 1].add(tempList[0]);
      });
      tempList.removeAt(0);
    }
    while (tempList.length > 0) {
      List<int> newRow = [];
      while (newRow.length < 9 && tempList.length > 0) {
        newRow.add(tempList[0]);
        tempList.removeAt(0);
      }
      setState(() {
        _gameMatrix.add(newRow);
      });
    }
  }

  void select(int row, int col) {
    if (_gameMatrix[row][col] != null) {
      if (_select == null) {
        setState(() {
          _select = NumObj(col, row, _gameMatrix[row][col]);
        });
      } else if (_select.col == col && _select.row == row) {
        setState(() {
          _select = null;
        });
      } else {
        if (_gameMatrix[row][col] == _select.val ||
            _gameMatrix[row][col] + _select.val == 10) {
          if (_select.col == col) {
            bool isInOneColumn = true;
            int minRow = _select.row < row ? _select.row : row;
            int maxRow = _select.row > row ? _select.row : row;
            for (int i = minRow + 1; i < maxRow; i++) {
              if (_gameMatrix[i][col] != null) {
                isInOneColumn = false;
                break;
              }
            }
            if (isInOneColumn) {
              setState(() {
                _gameMatrix[row][col] = null;
                _gameMatrix[_select.row][_select.col] = null;
                removeVoidRows();
              });
            }
          }

          if (_select.row == row) {
            bool isInOneRow = true;
            int minCol = _select.col < col ? _select.col : col;
            int maxCol = _select.col > col ? _select.col : col;
            for (int i = minCol + 1; i < maxCol; i++) {
              if (_gameMatrix[row][i] != null) {
                isInOneRow = false;
                break;
              }
            }
            if (isInOneRow) {
              setState(() {
                _gameMatrix[row][col] = null;
                _gameMatrix[_select.row][_select.col] = null;
                removeVoidRows();
              });
            }
          }

          if (_select.row == row + 1 || _select.row == row - 1) {
            int firstRow, firstCol, lastCol;
            if (_select.row < row) {
              firstRow = _select.row;
              firstCol = _select.col;
              lastCol = col;
            } else {
              firstRow = row;
              firstCol = col;
              lastCol = _select.col;
            }

            bool isInOneRow = true;

            for (int i = firstCol + 1; i < _gameMatrix[firstRow].length; i++) {
              if (_gameMatrix[firstRow][i] != null) {
                isInOneRow = false;
                break;
              }
            }
            for (int i = 0; i < lastCol; i++) {
              if (_gameMatrix[firstRow + 1][i] != null) {
                isInOneRow = false;
                break;
              }
            }
            if (isInOneRow) {
              setState(() {
                _gameMatrix[row][col] = null;
                _gameMatrix[_select.row][_select.col] = null;
                removeVoidRows();
              });
            }
          }

          if (_select.row == _gameMatrix.length - 1 && row == 0) {
            bool isInOneRow = true;
            for (int i = 0; i < col; i++) {
              if (_gameMatrix[row][i] != null) {
                isInOneRow = false;
                break;
              }
            }
            for (int i = _select.col + 1;
                i < _gameMatrix[_select.row].length;
                i++) {
              if (_gameMatrix[_select.row][i] != null) {
                isInOneRow = false;
                break;
              }
            }
            if (isInOneRow) {
              setState(() {
                _gameMatrix[row][col] = null;
                _gameMatrix[_select.row][_select.col] = null;
                removeVoidRows();
              });
            }
          }

          if (row == _gameMatrix.length - 1 && _select.row == 0) {
            bool isInOneRow = true;
            for (int i = 0; i < _select.col; i++) {
              if (_gameMatrix[_select.row][i] != null) {
                isInOneRow = false;
                break;
              }
            }
            for (int i = col + 1; i < _gameMatrix[row].length; i++) {
              if (_gameMatrix[row][i] != null) {
                isInOneRow = false;
                break;
              }
            }
            if (isInOneRow) {
              setState(() {
                _gameMatrix[row][col] = null;
                _gameMatrix[_select.row][_select.col] = null;
                removeVoidRows();
              });
            }
          }
        }
        setState(() {
          _select = null;
        });
      }
    }
  }

  List<Widget> generateRow(int rowIndex) {
    int rowLength = _gameMatrix[rowIndex].length;
    int gapsCount = 9 - rowLength;

    return [
      ...List.generate(
          rowLength,
          (col) => Ink(
              decoration: ShapeDecoration(
                color: _select != null
                    ? _select.col == col && _select.row == rowIndex
                        ? Colors.blueAccent
                        : Colors.transparent
                    : Colors.transparent,
                shape: CircleBorder(),
              ),
              child: IconButton(
                  onPressed: () {
                    select(rowIndex, col);
                  },
                  // icon: Icon(Icons.ac_unit),
                  icon: Text(
                    _gameMatrix[rowIndex][col] == null
                        ? ""
                        : _gameMatrix[rowIndex][col].toString(),
                    style: TextStyle(color: Colors.white),
                  )))).toList(),
      ...List.generate(gapsCount, (_) => Container()).toList()
    ];
  }

  List<TableRow> generateTable() {
    return List.generate(
            _gameMatrix.length, (row) => TableRow(children: generateRow(row)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("semki"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _gameMatrix = [
                    [1, 2, 3, 4, 5, 6, 7, 8, 9],
                    [1, 1, 1, 2, 1, 3, 1, 4, 1],
                    [5, 1, 6, 1, 7, 1, 8, 1, 9],
                  ];
                });
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addLines();
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Color(0xff373535),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [Table(children: generateTable())],
      ),
    );
  }
}

class NumObj {
  final int col;
  final int row;
  final int val;
  const NumObj(this.col, this.row, this.val);
}
