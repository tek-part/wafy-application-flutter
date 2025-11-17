# 🚀 دليل شامل: رفع تطبيق Flutter على Google Play Store (2025)

## من الصفر إلى النشر - خطوة بخطوة

---

## 📋 جدول المحتويات

1. [التحضيرات الأولية](#1-التحضيرات-الأولية)
2. [إعداد حساب Google Play Developer](#2-إعداد-حساب-google-play-developer)
3. [إعداد التطبيق للرفع](#3-إعداد-التطبيق-للرفع)
4. [إنشاء مفتاح التوقيع (Signing Key)](#4-إنشاء-مفتاح-التوقيع-signing-key)
5. [بناء Android App Bundle (AAB)](#5-بناء-android-app-bundle-aab)
6. [إعداد Store Listing](#6-إعداد-store-listing)
7. [إعداد Privacy Policy و Data Safety](#7-إعداد-privacy-policy-و-data-safety)
8. [Content Rating](#8-content-rating)
9. [رفع التطبيق](#9-رفع-التطبيق)
10. [المراجعة والنشر](#10-المراجعة-والنشر)
11. [التحقق من الامتثال](#11-التحقق-من-الامتثال)

---

## 1. التحضيرات الأولية

### 1.1 متطلبات النظام

- ✅ Flutter SDK مثبت (آخر إصدار)
- ✅ Android Studio مثبت
- ✅ حساب Google (Gmail)
- ✅ بطاقة ائتمانية أو PayPal (لدفع $25)
- ✅ تطبيق Flutter جاهز للاختبار

### 1.2 التحقق من حالة التطبيق

قبل البدء، تأكد من:

```bash
# التحقق من إصدار Flutter
flutter --version

# التحقق من حالة التطبيق
flutter doctor

# اختبار التطبيق
flutter run --release
```

---

## 2. إعداد حساب Google Play Developer

### 2.1 إنشاء الحساب

1. **اذهب إلى Google Play Console:**

   - الرابط: https://play.google.com/console
   - سجل الدخول بحساب Google

2. **إنشاء حساب المطور:**

   - اضغط على "Get Started" أو "إنشاء حساب"
   - املأ المعلومات المطلوبة:
     - الاسم الكامل
     - اسم الشركة (اختياري)
     - البلد/المنطقة
     - رقم الهاتف
     - عنوان البريد الإلكتروني

3. **دفع الرسوم:**

   - رسوم لمرة واحدة: **$25 USD**
   - يمكن الدفع ببطاقة ائتمانية أو PayPal
   - **ملاحظة:** هذه رسوم لمرة واحدة وليست سنوية

4. **إكمال الملف الشخصي:**
   - معلومات الاتصال
   - عنوان المطور
   - معلومات الدفع (للتطبيقات المدفوعة)

### 2.2 الموافقة على الشروط

- قراءة وموافقة على **Developer Distribution Agreement**
- الموافقة على **Developer Program Policies**

---

## 3. إعداد التطبيق للرفع

### 3.1 تغيير Application ID

**⚠️ مهم جداً:** يجب تغيير `com.example.wafy` إلى معرف فريد خاص بك.

#### الخطوة 1: اختيار Application ID

صيغة Application ID:

```
com.[yourcompany].[appname]
```

أمثلة:

- `com.wafy.restaurant`
- `com.yourcompany.wafy`
- `sa.com.wafy.pos`

#### الخطوة 2: تعديل build.gradle.kts

افتح الملف: `android/app/build.gradle.kts`

```kotlin
android {
    namespace = "com.wafy.restaurant"  // غيّر هذا
    // ...

    defaultConfig {
        applicationId = "com.wafy.restaurant"  // غيّر هذا أيضاً
        // ...
        targetSdk = 35  // ✅ يجب أن يكون 35 أو أحدث (2025)
    }
}
```

#### الخطوة 3: تحديث MainActivity

إذا كان لديك ملف `MainActivity.kt`، تأكد من أن package name متطابق:

```kotlin
package com.wafy.restaurant  // غيّر هذا

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

### 3.2 تحديث معلومات التطبيق

#### تحديث pubspec.yaml

```yaml
name: wafy
description: "نظام إدارة المطاعم والمقاهي - Wafy POS System" # غيّر هذا
version: 1.0.0+1 # versionName + versionCode
```

**شرح Version:**

- `1.0.0` = versionName (يظهر للمستخدم)
- `+1` = versionCode (يستخدمه Google Play، يجب أن يزيد مع كل تحديث)

### 3.3 تحديث AndroidManifest.xml

افتح: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />

    <!-- إذا كنت تستخدم Bluetooth (للطابعات) -->
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />

    <!-- إذا كنت تستخدم الموقع -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <application
        android:label="Wafy"  <!-- اسم التطبيق -->
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- ... -->
    </application>
</manifest>
```

**ملاحظات مهمة:**

- إذا كنت تستخدم Bluetooth، يجب تبرير ذلك في Play Console
- إذا كنت تستخدم الموقع، يجب تبرير ذلك أيضاً
- `usesCleartextTraffic="true"` قد يسبب مشاكل - استخدم HTTPS في الإنتاج

### 3.4 إزالة Debug Signing

**⚠️ مهم جداً:** لا يمكن رفع تطبيق موقع بـ debug key!

في `android/app/build.gradle.kts`:

```kotlin
buildTypes {
    release {
        // ❌ احذف هذا السطر:
        // signingConfig = signingConfigs.getByName("debug")

        // ✅ سنضيف signing config في الخطوة التالية
    }
}
```

---

## 4. إنشاء مفتاح التوقيع (Signing Key)

### 4.1 إنشاء Keystore

**⚠️ مهم جداً:** احفظ هذا الملف والمعلومات في مكان آمن! إذا فقدته، لن تتمكن من تحديث التطبيق!

#### على Windows (PowerShell):

```powershell
# انتقل إلى مجلد android
cd android

# أنشئ keystore
keytool -genkey -v -keystore wafy-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias wafy

# سيطلب منك:
# - كلمة مرور (احفظها!)
# - اسمك الكامل
# - اسم الشركة
# - المدينة
# - البلد (مثلاً: SA)
```

#### على macOS/Linux:

```bash
cd android
keytool -genkey -v -keystore wafy-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias wafy
```

### 4.2 إنشاء ملف key.properties

أنشئ ملف جديد: `android/key.properties`

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=wafy
storeFile=wafy-keystore.jks
```

**⚠️ مهم:**

- لا ترفع هذا الملف إلى Git!
- أضفه إلى `.gitignore`:

```gitignore
# في ملف .gitignore
android/key.properties
android/*.jks
android/*.keystore
```

### 4.3 إعداد build.gradle.kts

عدّل `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// أضف هذا في البداية
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.wafy.restaurant"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.wafy.restaurant"
        minSdk = flutter.minSdkVersion
        targetSdk = 35  // ✅ Android 15 (2025)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // أضف signingConfigs هنا
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release  // ✅ استخدم release signing
        }
    }
}

flutter {
    source = "../.."
}
```

**ملاحظة:** إذا كنت تستخدم Kotlin DSL (`.kts`)، استخدم هذا:

```kotlin
// في بداية الملف
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

// في android block
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = keystoreProperties["storeFile"]?.let { file(it) }
        storePassword = keystoreProperties["storePassword"] as String
    }
}

buildTypes {
    getByName("release") {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

---

## 5. بناء Android App Bundle (AAB)

### 5.1 التحقق من التطبيق

```bash
# تنظيف المشروع
flutter clean

# الحصول على dependencies
flutter pub get

# اختبار البناء
flutter build appbundle --release
```

### 5.2 بناء AAB

```bash
# بناء App Bundle
flutter build appbundle --release
```

**النتيجة:**

- الملف سيكون في: `build/app/outputs/bundle/release/app-release.aab`
- حجم الملف عادة بين 10-50 MB

### 5.3 التحقق من AAB

يمكنك استخدام `bundletool` للتحقق:

```bash
# تحميل bundletool (اختياري)
# https://github.com/google/bundletool/releases

# فحص AAB
java -jar bundletool.jar build-apks --bundle=app-release.aab --output=app.apks
```

---

## 6. إعداد Store Listing

### 6.1 إنشاء تطبيق جديد في Play Console

1. **سجل الدخول إلى Play Console:**

   - https://play.google.com/console

2. **إنشاء تطبيق جديد:**

   - اضغط "Create app" أو "إنشاء تطبيق"
   - املأ المعلومات:
     - **App name:** Wafy (أو الاسم الذي تريده)
     - **Default language:** Arabic (العربية)
     - **App or Game:** App
     - **Free or Paid:** Free (أو Paid حسب اختيارك)

3. **الموافقة على الشروط:**
   - قراءة وموافقة على Developer Program Policies
   - الموافقة على US export laws

### 6.2 Store Listing - المعلومات الأساسية

#### أ) App Name (اسم التطبيق)

- **الحد الأقصى:** 30 حرف
- **مثال:** "Wafy - نظام إدارة المطاعم"

#### ب) Short Description (الوصف القصير)

- **الحد الأقصى:** 80 حرف
- **مثال:** "نظام إدارة شامل للمطاعم والمقاهي مع دعم الطابعات الحرارية"

#### ج) Full Description (الوصف الكامل)

- **الحد الأقصى:** 4000 حرف
- **يجب أن يتضمن:**
  - وصف التطبيق
  - المميزات الرئيسية
  - كيفية الاستخدام
  - متطلبات النظام

**مثال:**

```
نظام Wafy هو حل متكامل لإدارة المطاعم والمقاهي بطريقة احترافية وسهلة.

المميزات الرئيسية:
✅ إدارة الطاولات والأدوار
✅ قوائم الطعام التفاعلية
✅ إدارة الطلبات والفواتير
✅ دعم الطابعات الحرارية (Bluetooth)
✅ تقارير مبيعات شاملة
✅ واجهة عربية سهلة الاستخدام

كيفية الاستخدام:
1. قم بتسجيل الدخول
2. اختر الطاولة
3. أضف الطلبات من القائمة
4. اطبع الفاتورة مباشرة

متطلبات:
- Android 6.0 أو أحدث
- Bluetooth (للاتصال بالطابعة)
```

### 6.3 Store Listing - الصور والأيقونات

#### أ) App Icon (أيقون التطبيق)

- **الحجم:** 512 × 512 بكسل
- **الصيغة:** PNG (بدون شفافية)
- **الموقع:** `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`

**نصيحة:** استخدم أدوات مثل:

- [App Icon Generator](https://www.appicon.co/)
- [Icon Kitchen](https://icon.kitchen/)

#### ب) Feature Graphic

- **الحجم:** 1024 × 500 بكسل
- **الصيغة:** PNG أو JPG
- **الاستخدام:** يظهر في أعلى صفحة التطبيق في المتجر

#### ج) Screenshots (لقطات الشاشة)

- **الحد الأدنى:** 2 لقطة
- **الموصى به:** 5-8 لقطات
- **الحجم:**
  - Phone: 320-3840 بكسل (الارتفاع)
  - Tablet: 320-3840 بكسل (الارتفاع)
- **الصيغة:** PNG أو JPG

**نصائح للقطات الشاشة:**

- ابدأ بأفضل المميزات
- أظهر واجهة المستخدم بوضوح
- استخدم نصوص توضيحية (اختياري)
- اجعلها باللغة العربية

#### د) Phone Screenshots

- **الحد الأدنى:** 2
- **الموصى به:** 4-8

#### هـ) Tablet Screenshots (اختياري)

- إذا كان التطبيق يدعم الأجهزة اللوحية

### 6.4 معلومات إضافية

#### Category (الفئة)

- اختر الفئة المناسبة:
  - Business (الأعمال)
  - Food & Drink (الطعام والشراب)
  - Productivity (الإنتاجية)

#### Tags (العلامات)

- أضف علامات ذات صلة:
  - `restaurant`
  - `pos`
  - `management`
  - `عربي`

#### Contact Details (معلومات الاتصال)

- **Email:** بريد إلكتروني للدعم
- **Phone:** رقم هاتف (اختياري)
- **Website:** موقع الويب (إن وجد)

---

## 7. إعداد Privacy Policy و Data Safety

### 7.1 Privacy Policy (سياسة الخصوصية)

**⚠️ مطلوب إذا:**

- التطبيق يجمع أي بيانات شخصية
- التطبيق يستخدم الإنترنت
- التطبيق يخزن بيانات محلية

#### إنشاء Privacy Policy

يمكنك استخدام:

- [Termly](https://termly.io/)
- [Privacy Policy Generator](https://www.privacypolicygenerator.info/)
- محامي (للشركات الكبيرة)

#### محتوى Privacy Policy يجب أن يتضمن:

1. **ما البيانات التي تجمعها؟**

   - بيانات تسجيل الدخول
   - بيانات الطلبات
   - معلومات الجهاز
   - بيانات الموقع (إن وجدت)

2. **كيف تستخدم البيانات؟**

   - لتشغيل التطبيق
   - لتحسين الخدمة
   - للتواصل مع المستخدم

3. **كيف تحمي البيانات؟**

   - التشفير
   - الأمان
   - الوصول المحدود

4. **مشاركة البيانات**

   - هل تشارك مع أطراف ثالثة؟
   - مع من ولماذا؟

5. **حقوق المستخدم**
   - حذف البيانات
   - الوصول للبيانات
   - التعديل

#### مثال Privacy Policy (بسيط):

```
سياسة الخصوصية - Wafy

آخر تحديث: [التاريخ]

نحن في Wafy نحترم خصوصيتك. هذه السياسة توضح كيفية جمع واستخدام بياناتك.

البيانات التي نجمعها:
- معلومات تسجيل الدخول (البريد الإلكتروني، كلمة المرور)
- بيانات الطلبات والفواتير
- معلومات الجهاز (للاتصال بالطابعة)

كيف نستخدم البيانات:
- لتشغيل التطبيق وتقديم الخدمة
- لتحسين الأداء والتجربة

حماية البيانات:
- نستخدم تشفير SSL/TLS
- البيانات محفوظة بشكل آمن
- الوصول محدود للموظفين المصرح لهم

مشاركة البيانات:
- لا نشارك بياناتك مع أطراف ثالثة
- إلا إذا كان مطلوباً قانونياً

حقوقك:
- يمكنك طلب حذف بياناتك
- يمكنك الوصول لبياناتك
- يمكنك تعديل بياناتك

للتواصل:
البريد الإلكتروني: support@wafy.com
```

**رفع Privacy Policy:**

- أنشئ صفحة ويب أو PDF
- ارفعها على موقعك أو GitHub Pages
- أضف الرابط في Play Console

### 7.2 Data Safety Section

في Play Console، املأ قسم **Data Safety**:

#### البيانات التي تجمعها:

1. **Location (الموقع)**

   - إذا كنت تستخدم Bluetooth scanning
   - اختر: "Approximate location" أو "Precise location"
   - الغرض: "App functionality" (للاتصال بالطابعة)

2. **Personal info (المعلومات الشخصية)**

   - Email address (إذا كنت تجمعها)
   - User IDs

3. **App activity**

   - App interactions
   - In-app search history

4. **Device or other IDs**
   - Device ID (إذا كنت تستخدمه)

#### كيف تستخدم البيانات:

- **App functionality:** لتشغيل التطبيق
- **Analytics:** لتحسين التطبيق
- **Advertising:** (إذا كنت تستخدم إعلانات)

#### هل تشارك البيانات؟

- عادة: **No**
- إلا إذا كنت تستخدم خدمات خارجية (مثل Firebase Analytics)

#### أمان البيانات:

- **Encryption in transit:** ✅ Yes (HTTPS)
- **Encryption at rest:** ✅ Yes (إذا كنت تشفر البيانات المحلية)

---

## 8. Content Rating

### 8.1 إكمال استبيان Content Rating

1. **في Play Console:**

   - اذهب إلى "Content rating"
   - ابدأ الاستبيان

2. **الأسئلة الشائعة:**

   **Q: Does your app contain user-generated content?**

   - عادة: No (ما لم يكن لديك تعليقات أو تقييمات من المستخدمين)

   **Q: Does your app allow users to communicate with each other?**

   - عادة: No (ما لم يكن لديك دردشة)

   **Q: Does your app contain violence?**

   - عادة: No

   **Q: Does your app contain sexual content?**

   - عادة: No

   **Q: Does your app allow users to gamble?**

   - عادة: No

   **Q: Does your app contain references to alcohol, tobacco, or drugs?**

   - إذا كان تطبيق مطعم: قد يكون Yes (للقوائم)
   - اختر: "References only" (إشارات فقط)

3. **النتيجة:**
   - عادة: **Everyone** أو **Teen**
   - حسب إجاباتك

---

## 9. رفع التطبيق

### 9.1 إنشاء Release

1. **في Play Console:**

   - اذهب إلى "Production" (أو "Testing" للاختبار أولاً)
   - اضغط "Create new release"

2. **رفع AAB:**

   - اضغط "Upload"
   - اختر ملف `app-release.aab`
   - انتظر حتى يكتمل الرفع

3. **Release name:**

   - مثال: "1.0.0 (Initial Release)"
   - أو: "الإصدار الأول"

4. **Release notes:**

   - اكتب ملاحظات الإصدار (بالعربية والإنجليزية):

   ```
   الإصدار الأول من Wafy
   - إدارة الطاولات والأدوار
   - قوائم الطعام
   - إدارة الطلبات
   - دعم الطابعات الحرارية
   ```

### 9.2 Review Information

املأ معلومات المراجعة:

- **Contact email:** بريدك الإلكتروني
- **Phone number:** رقم هاتفك
- **App access:**
  - إذا كان التطبيق يحتاج حساب: "Restricted"
  - أضف معلومات تسجيل الدخول للاختبار

### 9.3 Export Compliance

- **Does your app use encryption?**
  - إذا كنت تستخدم HTTPS فقط: **No**
  - إذا كنت تستخدم تشفير مخصص: **Yes** (قد تحتاج تصريح)

### 9.4 إرسال للمراجعة

1. **راجع كل شيء:**

   - ✅ Store Listing مكتمل
   - ✅ Privacy Policy موجودة
   - ✅ Data Safety مكتمل
   - ✅ Content Rating مكتمل
   - ✅ AAB مرفوع
   - ✅ Release notes مكتوبة

2. **اضغط "Send for review"**

3. **انتظر المراجعة:**
   - عادة: 1-7 أيام
   - قد تصل رسالة بأسئلة إضافية

---

## 10. المراجعة والنشر

### 10.1 أثناء المراجعة

- **تحقق من البريد الإلكتروني:**

  - قد يرسل Google أسئلة
  - أجب بسرعة

- **تحقق من Play Console:**
  - قد تظهر مشاكل تحتاج إصلاح
  - راجع "Policy status"

### 10.2 بعد الموافقة

1. **سيظهر التطبيق في Play Store:**

   - قد يستغرق بضع ساعات
   - ابحث عن اسم التطبيق

2. **التحقق من النشر:**
   - افتح Google Play Store
   - ابحث عن تطبيقك
   - تحقق من المعلومات

### 10.3 تحديثات مستقبلية

لرفع تحديث:

1. **زيادة versionCode:**

   ```yaml
   # في pubspec.yaml
   version: 1.0.1+2 # +2 يعني versionCode الجديد
   ```

2. **بناء AAB جديد:**

   ```bash
   flutter build appbundle --release
   ```

3. **رفع في Play Console:**
   - اذهب إلى "Production"
   - "Create new release"
   - ارفع AAB الجديد
   - أضف Release notes

---

## 11. التحقق من الامتثال

### 11.1 Checklist قبل الرفع

- [ ] Application ID تم تغييره من `com.example.*`
- [ ] targetSdk = 35 (Android 15)
- [ ] Release signing key تم إنشاؤه
- [ ] key.properties موجود وآمن
- [ ] AAB تم بناؤه بنجاح
- [ ] Store Listing مكتمل (اسم، وصف، صور)
- [ ] Privacy Policy موجودة ومتاحة
- [ ] Data Safety مكتمل
- [ ] Content Rating مكتمل
- [ ] جميع الأذونات مبررة
- [ ] التطبيق تم اختباره على أجهزة حقيقية

### 11.2 متطلبات 2025

- [x] **Target API 35:** ✅ (Android 15)
- [ ] **Data Safety:** مطلوب
- [ ] **Privacy Policy:** مطلوب إذا جمعت بيانات
- [ ] **Play App Signing:** إلزامي للتطبيقات الجديدة

### 11.3 تجنب المشاكل الشائعة

#### ❌ مشاكل شائعة:

1. **استخدام com.example.\***

   - ✅ الحل: غيّر Application ID

2. **Debug signing**

   - ✅ الحل: استخدم Release signing key

3. **عدم وجود Privacy Policy**

   - ✅ الحل: أنشئ واحدة

4. **عدم تبرير الأذونات**

   - ✅ الحل: املأ Data Safety بشكل صحيح

5. **Target API قديم**

   - ✅ الحل: استخدم API 35

6. **محتوى غير مناسب**
   - ✅ الحل: راجع Content Guidelines

---

## 📚 روابط مهمة

### روابط رسمية:

- [Google Play Console](https://play.google.com/console)
- [Developer Program Policies](https://play.google.com/about/developer-content-policy/)
- [Data Safety Section Guide](https://support.google.com/googleplay/android-developer/answer/10787469)
- [App Signing](https://support.google.com/googleplay/android-developer/answer/9842756)

### أدوات مفيدة:

- [App Icon Generator](https://www.appicon.co/)
- [Privacy Policy Generator](https://www.privacypolicygenerator.info/)
- [Bundletool](https://github.com/google/bundletool)

### وثائق Flutter:

- [Flutter Build and Release](https://docs.flutter.dev/deployment/android)
- [Android App Signing](https://docs.flutter.dev/deployment/android#signing-the-app)

---

## 🎯 ملخص سريع

### الخطوات الأساسية:

1. ✅ إنشاء حساب Google Play Developer ($25)
2. ✅ تغيير Application ID
3. ✅ إنشاء Release signing key
4. ✅ بناء AAB
5. ✅ إعداد Store Listing
6. ✅ إضافة Privacy Policy
7. ✅ إكمال Data Safety
8. ✅ إكمال Content Rating
9. ✅ رفع AAB
10. ✅ إرسال للمراجعة

### الوقت المتوقع:

- **إعداد الحساب:** 30 دقيقة
- **إعداد التطبيق:** 1-2 ساعة
- **إعداد Store Listing:** 2-3 ساعات
- **المراجعة:** 1-7 أيام

---

## 💡 نصائح إضافية

1. **ابدأ بـ Internal Testing:**

   - اختبر التطبيق مع فريق صغير أولاً
   - ثم Closed Testing
   - ثم Production

2. **احفظ نسخ احتياطية:**

   - من keystore
   - من key.properties
   - في مكان آمن (مشفر)

3. **راقب التطبيق:**

   - راجع التقييمات
   - أجب على التعليقات
   - راقب الأخطاء (Crash reports)

4. **حدّث بانتظام:**
   - أصلح الأخطاء
   - أضف مميزات جديدة
   - حافظ على Target API محدث

---

## ❓ أسئلة شائعة

### Q: كم يستغرق النشر؟

**A:** عادة 1-7 أيام للمراجعة الأولى.

### Q: هل يمكنني تحديث التطبيق بعد النشر؟

**A:** نعم، لكن يجب زيادة versionCode.

### Q: ماذا لو رُفض التطبيق؟

**A:** ستصل رسالة توضح السبب. أصلح المشكلة وأعد الإرسال.

### Q: هل أحتاج Privacy Policy؟

**A:** نعم، إذا كان التطبيق يجمع أي بيانات أو يستخدم الإنترنت.

### Q: كيف أغير Application ID بعد النشر؟

**A:** لا يمكن. Application ID دائم. يجب إنشاء تطبيق جديد.

---

## ✅ الخلاصة

هذا الدليل يغطي جميع الخطوات من الصفر حتى النشر. اتبع الخطوات بالترتيب، وراجع كل قسم بعناية. إذا واجهت مشاكل، راجع قسم "المشاكل الشائعة" أو وثائق Google Play.

**حظاً موفقاً في نشر تطبيقك! 🚀**

---

_آخر تحديث: يناير 2025_
