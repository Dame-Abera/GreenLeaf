import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class TestConfig {
  static Future<void> setup() async {
    // Initialize the integration test binding
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    
    // Add any global test setup here
    TestWidgetsFlutterBinding.ensureInitialized();

  }

  static Future<void> teardown() async {

  }
} 
