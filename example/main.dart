import 'package:typed_json_getters/typed_json_getters.dart';

void main() {
  // Sample JSON data
  Map<String, dynamic> jsonData = {
    'user': {
      'id': 'u123',
      'name': 'Alice',
      'isActive': 'true',
      // String that can be converted to bool
      'details': {
        'age': '30', // String that can be converted to int
        'height': 5.6, // Double value
        'weight': 'not available', // Invalid double
      },
      'preferences': {
        'notifications': 'false', // String that can be converted to bool
        'theme': 'dark',
      },
      'scores': ['100', '95', '80'],
      // List of strings that can be converted to int
      'invalidScores': ['100', 'ninety-five', 80],
      // Mixed list with invalid int
      'address': null,
      // Null value
    },
    'meta': {
      'lastLogin': '2023-10-01T12:34:56Z',
      'signupCount': 'invalid', // Invalid int
    },
  };

  // Using get<T> with default values
  String userId = jsonData.get<String>('user.id', defaultValue: '');
  String userName = jsonData.get<String>('user.name', defaultValue: 'Unknown');
  bool isActive = jsonData.get<bool>('user.isActive', defaultValue: false);
  int age = jsonData.get<int>('user.details.age', defaultValue: 0);
  double height =
      jsonData.get<double>('user.details.height', defaultValue: 0.0);
  double weight = jsonData.get<double>('user.details.weight',
      defaultValue: 0.0); // Conversion fails
  bool notifications =
      jsonData.get<bool>('user.preferences.notifications', defaultValue: true);
  String theme =
      jsonData.get<String>('user.preferences.theme', defaultValue: 'light');
  List<int> scores = jsonData.getList<int>('user.scores', defaultValue: []);
  List<int> invalidScores =
      jsonData.getList<int>('user.invalidScores', defaultValue: []);
  Map<String, String> address = jsonData
      .getMap<String, String>('user.address', defaultValue: {}); // Null value
  int signupCount = jsonData.get<int>('meta.signupCount',
      defaultValue: 0); // Conversion fails

  // Using getNullable<T>
  String? nickname =
      jsonData.getNullable<String>('user.nickname'); // Key not found
  int? nullableAge = jsonData.getNullable<int>('user.details.age');
  double? nullableWeight =
      jsonData.getNullable<double>('user.details.weight'); // Conversion fails
  bool? nullableNotifications =
      jsonData.getNullable<bool>('user.preferences.notifications');
  String? nullableTheme =
      jsonData.getNullable<String>('user.preferences.theme');
  List<int>? nullableScores = jsonData.getNullableList<int>('user.scores');
  List<int>? nullableInvalidScores =
      jsonData.getNullableList<int>('user.invalidScores'); // Conversion fails
  Map<String, String>? nullableAddress =
      jsonData.getNullableMap<String, String>('user.address'); // Null value
  int? nullableSignupCount =
      jsonData.getNullable<int>('meta.signupCount'); // Conversion fails

  // Accessing nested keys using dot notation
  String lastLogin =
      jsonData.get<String>('meta.lastLogin', defaultValue: 'Never');
  String innerValue1 = jsonData.get<String>('user.details.innerKey',
      defaultValue: 'No Value'); // Invalid path

  // Printing the results
  print('--- Using get<T> ---');
  print('User ID: $userId'); // Output: User ID: u123
  print('User Name: $userName'); // Output: User Name: Alice
  print('Is Active: $isActive'); // Output: Is Active: true
  print('Age: $age'); // Output: Age: 30
  print('Height: $height'); // Output: Height: 5.6
  print(
      'Weight: $weight'); // Output: Weight: 0.0 (default value due to conversion failure)
  print(
      'Notifications Enabled: $notifications'); // Output: Notifications Enabled: false
  print('Theme: $theme'); // Output: Theme: dark
  print('Scores: $scores'); // Output: Scores: [100, 95, 80]
  print('Invalid Scores: $invalidScores'); // Output: Invalid Scores: []
  print('Address: $address'); // Output: Address: {}
  print(
      'Signup Count: $signupCount'); // Output: Signup Count: 0 (default value due to conversion failure)

  print('\n--- Using getNullable<T> ---');
  print('Nickname: $nickname'); // Output: Nickname: null
  print('Nullable Age: $nullableAge'); // Output: Nullable Age: 30
  print('Nullable Weight: $nullableWeight'); // Output: Nullable Weight: null
  print(
      'Nullable Notifications Enabled: $nullableNotifications'); // Output: Nullable Notifications Enabled: false
  print('Nullable Theme: $nullableTheme'); // Output: Nullable Theme: dark
  print(
      'Nullable Scores: $nullableScores'); // Output: Nullable Scores: [100, 95, 80]
  print(
      'Nullable Invalid Scores: $nullableInvalidScores'); // Output: Nullable Invalid Scores: null
  print('Nullable Address: $nullableAddress'); // Output: Nullable Address: null
  print(
      'Nullable Signup Count: $nullableSignupCount'); // Output: Nullable Signup Count: null

  print('\n--- Nested Keys ---');
  print('Last Login: $lastLogin'); // Output: Last Login: 2023-10-01T12:34:56Z
  print('Inner Value1: $innerValue1'); // Output: Inner Value1: No Value
}
