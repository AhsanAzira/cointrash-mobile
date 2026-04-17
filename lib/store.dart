import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

class UserStore extends ChangeNotifier {
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;
  UserStore._internal();

  SharedPreferences? _prefs;
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  int _userId = 0;
  int _coinBalance = 0;
  int _totalTrashKg = 0;
  int _totalTransactions = 0;
  int _trashCount = 0;
  int _level = 1;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _wasteTypes = [];

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  int get userId => _userId;
  int get coinBalance => _coinBalance;
  int get totalTrashKg => _totalTrashKg;
  int get totalTransactions => _totalTransactions;
  int get trashCount => _trashCount;
  int get level => _level;
  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get wasteTypes => _wasteTypes;

  // Base URL for API
  String get baseUrl {
    if (kIsWeb) return 'http://localhost/cointrash-admin/api.php';
    if (Platform.isAndroid) return 'http://10.0.2.2/cointrash-admin/api.php';
    return 'http://localhost/cointrash-admin/api.php';
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs?.getBool('isLoggedIn') ?? false;
    _userId = _prefs?.getInt('userId') ?? 0;
    _userName = _prefs?.getString('userName') ?? '';
    _userEmail = _prefs?.getString('userEmail') ?? '';

    _coinBalance = _prefs?.getInt('coinBalance') ?? 0;
    _totalTrashKg = _prefs?.getInt('totalTrashKg') ?? 0;
    _totalTransactions = _prefs?.getInt('totalTransactions') ?? 0;
    _trashCount = _prefs?.getInt('trashCount') ?? 0;
    _level = _prefs?.getInt('level') ?? 1;

    if (_isLoggedIn) {
      await fetchUserData();
    }
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    if (_userId == 0) return;
    try {
      final resHistory = await http.get(
        Uri.parse('$baseUrl?action=get_history&user_id=$_userId'),
      );
      if (resHistory.statusCode == 200) {
        final List<dynamic> data = jsonDecode(resHistory.body);
        _transactions = data
            .map(
              (e) => {
                'title': 'Setoran Sampah',
                'subtitle': e['waste_name'],
                'amount': int.parse(e['coins'].toString()),
                'date': e['created_at'].toString().split(' ')[0],
                'type': 'credit',
                'weight': double.parse(e['weight'].toString()),
              },
            )
            .toList();

        _totalTransactions = _transactions.length;
        double totalKg = 0;
        int totalCoins = 0;
        for (var tx in _transactions) {
          totalKg += tx['weight'] as double;
          totalCoins += tx['amount'] as int;
        }
        _totalTrashKg = totalKg.toInt();
        _coinBalance = totalCoins;
        _trashCount = _transactions.length;
        _level = (_trashCount ~/ 100) + 1;

        await _save();
      }

      final resWaste = await http.get(Uri.parse('$baseUrl?action=get_prices'));
      if (resWaste.statusCode == 200) {
        final List<dynamic> data = jsonDecode(resWaste.body);
        _wasteTypes = data.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl?action=login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data != null && data['status'] == 'success') {
          _isLoggedIn = true;
          _userId = int.parse(data['user']['id'].toString());
          _userEmail = data['user']['email'];
          _userName = data['user']['NAME'] ?? '';
          await _prefs?.setBool('isLoggedIn', true);
          await _prefs?.setInt('userId', _userId);
          await _prefs?.setString('userEmail', _userEmail);
          await _prefs?.setString('userName', _userName);
          await fetchUserData();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl?action=register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 'success') {
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Register error: $e");
      return false;
    }
  }

  Future<bool> addTransaction(int wasteTypeId, double weight, int coins) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl?action=save_transaction'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": _userId,
          "waste_type_id": wasteTypeId,
          "weight": weight,
          "coins": coins,
        }),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 'success') {
          await fetchUserData();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Add transaction error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = 0;
    _userName = '';
    _userEmail = '';
    _transactions = [];
    _coinBalance = 0;
    _totalTrashKg = 0;
    _totalTransactions = 0;
    _trashCount = 0;
    _level = 1;
    await _prefs?.clear();
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setInt('coinBalance', _coinBalance);
    await _prefs?.setInt('totalTrashKg', _totalTrashKg);
    await _prefs?.setInt('totalTransactions', _totalTransactions);
    await _prefs?.setInt('trashCount', _trashCount);
    await _prefs?.setInt('level', _level);
  }
}
