# 🍍 Pineapple Finance - Setup Guide

## Prerequisites

- Flutter SDK (3.10.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android Emulator or Physical Device

## Installation Steps

### 1. Install Dependencies

```bash
cd pineapple_finance
flutter pub get
```

### 2. Run the App

For Android:
```bash
flutter run
```

For specific device:
```bash
flutter devices  # List all devices
flutter run -d <device-id>
```

### 3. Build APK (Optional)

```bash
flutter build apk --release
```

The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

## First Time Usage

1. **Launch the App**: You'll see the intro screen with "Get Started" button
2. **Register**: Click "Get Started" → "Don't have an account? Register"
   - Enter your name, email, and password
   - Click "Register"
3. **Auto Login**: After registration, you'll be automatically logged in
4. **Dashboard**: You'll see the main dashboard with:
   - Total Balance card
   - Income and Expense summary
   - Quick actions to add transactions
   - Recent transactions list

## Features Guide

### Adding Transactions

1. From Dashboard, click "Add Income" or "Add Expense"
2. Fill in:
   - Title (e.g., "Salary", "Groceries")
   - Amount (e.g., 5000)
   - Category (select from dropdown)
   - Description (optional)
3. Click "Add"

### Managing Stock

1. Navigate to "Stock" tab from bottom navigation
2. Click the floating "+" button
3. Enter item name and quantity
4. Click "Add"
5. To edit: Click the three dots menu → Edit
6. To delete: Click the three dots menu → Delete

### Viewing Analytics

1. Navigate to "Analytics" tab
2. View:
   - Income vs Expense pie chart
   - Category-wise breakdowns
   - Total transaction count

### Managing Profile

1. Navigate to "Profile" tab
2. View your profile information
3. Click "Logout" to sign out

## Database Location

The SQLite database is stored locally on the device at:
- Android: `/data/data/com.example.pineapple_finance/databases/pineapple_finance.db`
- iOS: `Library/Application Support/pineapple_finance.db`

## Troubleshooting

### Issue: "Building with plugins requires symlink support"
**Solution**: Enable Developer Mode on Windows
```bash
start ms-settings:developers
```

### Issue: App crashes on first launch
**Solution**: Clear app data and reinstall
```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Database not working
**Solution**: Uninstall and reinstall the app to reset the database

## Development Tips

### Hot Reload
Press `r` in the terminal while the app is running to hot reload changes.

### Hot Restart
Press `R` in the terminal to hot restart the app.

### Debug Mode
The app runs in debug mode by default. To run in release mode:
```bash
flutter run --release
```

## Testing

To test the app:

1. Register a new account
2. Add some income transactions (e.g., Salary: ₹50000)
3. Add some expense transactions (e.g., Food: ₹5000, Transport: ₹2000)
4. Add stock items (e.g., Laptops: 10, Phones: 25)
5. Check Analytics to see the charts
6. Navigate through all tabs
7. Logout and login again to verify session management

## Color Customization

To change the app colors, edit `lib/core/theme/app_colors.dart`:

```dart
class AppColors {
  static const yellow = Color(0xFFFFD54F);  // Change this
  static const orange = Color(0xFFFFA726);  // Change this
  static const background = Color(0xFFF8E1); // Change this
}
```

## Support

For issues or questions, please check the README.md file or create an issue in the repository.

## Next Steps

After setup, you can:
- Customize the color theme
- Add more transaction categories
- Implement additional features
- Export data functionality
- Add cloud backup

Happy coding! 🍍
