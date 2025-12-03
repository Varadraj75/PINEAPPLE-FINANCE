# 🔧 How to Fix "Email Already Exists" Error

## Problem
Database already has test data from previous runs, causing:
- ❌ "Email already exists" when registering
- ❌ "Invalid password" when logging in

## ✅ Solution (Choose One)

### **Method 1: Use Reset Button in App (EASIEST)**

1. **Open the app** (it should be running)
2. You'll see the **Intro Screen** with "Pineapple Finance"
3. Look for the **RED "Reset App Data" button**
4. Click it
5. Confirm "Reset"
6. ✅ Database will be cleared!
7. Now click "Get Started" → "Register"
8. Create your account:
   - Name: Akshat
   - Email: akshatp439@gmail.com
   - Password: aasgu107

---

### **Method 2: Hot Restart (If app is running)**

1. Go to the **terminal where flutter run is active**
2. Press **`R`** (capital R) and hit Enter
3. This will hot restart the app
4. Database will be recreated with version 2
5. ✅ All old data will be cleared!
6. Now register your account

---

### **Method 3: Stop and Restart App**

1. In terminal, press **`q`** to quit the app
2. Run again: `flutter run -d windows`
3. Database will be recreated
4. ✅ Register your account

---

### **Method 4: Manual Database Delete**

1. Close the app completely
2. Go to: `C:\Users\Akshat Patil\AppData\Local\pineapple_finance\`
3. Delete the folder or find `pineapple_finance.db` and delete it
4. Run the app again
5. ✅ Fresh database will be created

---

## ✅ After Reset - Register Your Account

1. Click "Get Started"
2. Click "Don't have an account? Register"
3. Fill in:
   - **Name:** Akshat
   - **Email:** akshatp439@gmail.com
   - **Password:** aasgu107
4. Click "Register"
5. ✅ You'll be logged in automatically!

---

## 🎯 What I Fixed

1. ✅ Added **"Reset App Data" button** on intro screen
2. ✅ Changed database **version from 1 to 2** (auto-clears old data)
3. ✅ Added **onUpgrade** handler to drop old tables
4. ✅ Better error messages with dialogs
5. ✅ "Go to Login" option when email exists

---

## 📱 Now You Can Use All Features

After successful registration/login:
- ✅ **Dashboard** - View balance, add transactions
- ✅ **Transactions** - Add income/expense, view all
- ✅ **Stock** - Manage inventory
- ✅ **Analytics** - View charts and reports
- ✅ **Profile** - View profile, logout

---

**Database Location:**
- Windows: `C:\Users\Akshat Patil\AppData\Local\pineapple_finance\pineapple_finance.db`
- The app creates this automatically on first run

---

**Try Method 1 first - it's the easiest!** 🍍
