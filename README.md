# 🍍 Pineapple Finance

A complete finance management app for small businesses built with Flutter and SQLite.

## Features

###  Dashboard
- View total balance (Income - Expense)
- Quick view of income and expense totals
- Quick actions to add income/expense
- Recent transactions list
- Beautiful pineapple-themed UI

###  Transactions
- Add income and expense transactions
- Categorize transactions (Food, Transport, Shopping, Bills, Salary, Business, etc.)
- View all transactions with filters (All, Income, Expense)
- Delete transactions
- View transaction details with date and description

###  Stock Management
- Add stock items with name and quantity
- Edit existing stock items
- Delete stock items
- View all stock items with dates

###  Analytics
- Visual pie chart showing Income vs Expense
- Category-wise expense breakdown with percentages
- Category-wise income breakdown with percentages
- Total transaction count
- Net balance summary

###  Profile
- View user profile information
- Account settings (Coming soon)
- Notifications settings (Coming soon)
- Security settings (Coming soon)
- Help & Support (Coming soon)
- Logout functionality

###  Authentication
- User registration
- User login
- Session management with SharedPreferences
- Auto-login on app restart

## Tech Stack

- **Flutter** - UI Framework
- **SQLite (sqflite)** - Local database for data persistence
- **SharedPreferences** - Session management
- **fl_chart** - Beautiful charts for analytics
- **intl** - Date formatting

## Database Schema

### Users Table
- id (Primary Key)
- name
- email (Unique)
- password

### Transactions Table
- id (Primary Key)
- title
- amount
- type (income/expense)
- category
- date
- description

### Stocks Table
- id (Primary Key)
- name
- quantity
- addedDate

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## App Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_colors.dart
│   └── utils/
├── data/
│   ├── database/
│   │   └── database_helper.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── transaction_model.dart
│   │   └── stock_model.dart
│   └── services/
│       └── auth_service.dart
├── modules/
│   ├── auth/
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── dashboard/
│   │   ├── screens/
│   │   │   └── dashboard_screen.dart
│   │   └── widgets/
│   │       └── add_transaction_dialog.dart
│   ├── transactions/
│   │   └── screens/
│   │       └── transactions_screen.dart
│   ├── stock/
│   │   └── screens/
│   │       └── stock_screen.dart
│   ├── analytics/
│   │   └── screens/
│   │       └── analytics_screen.dart
│   ├── profile/
│   │   └── screens/
│   │       └── profile_screen.dart
│   └── intro/
│       └── screens/
│           └── intro_screen.dart
└── main.dart
```

## Color Theme

- **Primary Yellow**: #FFD54F
- **Orange**: #FFA726
- **Background**: #FFF8E1

## How to Use

1. **First Time**: Register with your name, email, and password
2. **Login**: Use your credentials to login
3. **Dashboard**: View your financial overview
4. **Add Transaction**: Use quick actions to add income or expense
5. **View Transactions**: Navigate to Transactions tab to see all records
6. **Manage Stock**: Add and manage your inventory items
7. **Analytics**: View visual reports of your finances
8. **Profile**: Manage your account and logout

## License

This project is licensed under the MIT License.
