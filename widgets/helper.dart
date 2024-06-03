/// Returns a new list excluding some elements of the original list.
List<T> listByExcludingIndexes<T>(
    List<T> originalList, List<int> excludeIndices) {
  final newList = <T>[];

  for (int i = 0; i < originalList.length; i++) {
    if (!excludeIndices.contains(i)) {
      newList.add(originalList[i]);
    }
  }

  return newList;
}

/// Returns a list sanitized from unwanted characters from given list.
/// * Non-Digit characters
/// * Commas except one
List<String> cleanedListFromIncorrects(List<String> strList) {
  List<int> indexesToBeDeleted = [];
  int commaCount = 0;

  for (int i = 0; i < strList.length; i++) {
    // If it's not a digit it'll be removed except one comma
    if (int.tryParse(strList[i]) == null) {
      // If there are commas more than one then it'll be removed.
      if (strList[i] == ',') {
        commaCount++;
        if (commaCount > 1) {
          indexesToBeDeleted.add(i);
        }
      } else {
        indexesToBeDeleted.add(i);
      }
    }
  }

  return listByExcludingIndexes(strList, indexesToBeDeleted);
}

/// Clear points inside the given list.
/// Return a new list that contains points in the right places.
List<String> pointsCorrectedList(List<String> strList) {
  // Clear all points
  strList.removeWhere((s) => s == '.');

  // There must be at least 4 digits in order to be found a dot.
  if (strList.length < 4) {
    return strList;
  }

  List<int> pointPositions = [];

  // Determine point places and write inside the pointPositions list.
  for (int i = strList.length; i > 0; i--) {
    if (i % 3 == 0) {
      pointPositions.add(strList.length - i);
    } else if (i % 3 == 2 && i < 2) {
      pointPositions.add(strList.length + 2 - i);
    } else if (i % 3 == 1 && i < 1) {
      pointPositions.add(strList.length + 3 - i);
    }
  }

  // There shouldn't be a point in the first place.
  pointPositions.removeWhere((p) => p == 0);

  // Insert points inside the given list.
  for (int i = 0; i < pointPositions.length; i++) {
    strList.insert(pointPositions[i] + (i > 0 ? i : 0), '.');
  }

  // Return not a reference but a new list from strList.
  return List.from(strList);
}

/// Returns a list sanitized from adjacent zeros located foremost.
List<String> cleanedListFromAdjacentZeros(List<String> strList) {
  List<int> positions = [];

  if (strList.length > 1) {
    for (int i = 0; i < strList.length; i++) {
      if (strList[i] == '0') {
        positions.add(i);
      } else if (strList[i] != '0') {
        break;
      }
    }
  }

  if (positions.isEmpty) {
    return strList;
  }

  final result = listByExcludingIndexes(strList, positions);

  if (result.isEmpty) {
    return ['0'];
  }

  return result;
}

/// Returns currency formatted text.
String currencyFormattedText(String str) {
  // Array of the given string
  var strList = str.split('');

  // 1.) Clean string list from inccorrect characters and adjacent zeros.
  final cleanList =
      cleanedListFromAdjacentZeros(cleanedListFromIncorrects(strList));
  // 2.) Determine comma position in the string list.
  final commaIndex = cleanList.indexOf(',');

  // 3.) Correct point positions before comma
  if (commaIndex > -1) {
    final cleanListBeforeComma = cleanList.getRange(0, commaIndex).toList();
    final cleanListAfterComma =
        cleanList.getRange(commaIndex + 1, cleanList.length).toList();
    final pointsCorrectedListBeforeComma =
        pointsCorrectedList(cleanListBeforeComma);
    strList = [...pointsCorrectedListBeforeComma, ',', ...cleanListAfterComma];
  } else {
    final pcl = pointsCorrectedList(cleanList);
    if (pcl.isEmpty) {
      strList = ['0', ',', '0', '0'];
    } else {
      strList = [...pcl, ',', '0', '0'];
    }
  }

  if (strList.length == 1 && strList[0] == ',') {
    strList = ['0', ',', '0', '0'];
  }
  if (strList[0] == ',') {
    strList.insert(0, '0');
  }

  return strList.join();
}

/// Currency formatted string to double
double currencyToDouble(String cur) {
  var str = cur.replaceAll('.', '');
  str = str.replaceFirst(',', '.');
  var strToDouble = double.tryParse(str);
  if (strToDouble != null) {
    return strToDouble;
  }
  return 0;
}
