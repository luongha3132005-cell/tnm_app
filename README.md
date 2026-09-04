# TNM App - Flutter E-Commerce & Product Management

| Đăng Nhập / Đăng Ký | Danh Sách Sản Phẩm | Lọc & Trạng Thái |
| :---: | :---: | :---: |
| ![Auth Screen](<img width="339" height="717" alt="Screenshot 2026-09-05 061023" src="https://github.com/user-attachments/assets/2f1b1305-ae68-48fe-a473-082d027d9861" />
) | ![Product List](<img width="342" height="719" alt="Screenshot 2026-09-05 061151" src="https://github.com/user-attachments/assets/6e72a6fb-4f33-40cb-b2c8-ee5f86974b4c" />
) | ![Filter Screen](<img width="344" height="723" alt="Screenshot 2026-09-05 061200" src="https://github.com/user-attachments/assets/dbb7f4b5-a248-4ea4-8bfc-a265848f14a5" />
) |

---

## Tính năng chính

- **Xác thực tài khoản (Authentication):**
  - Đăng ký (`POST /register`), Đăng nhập (`POST /login`).
  - Tự động duy trì phiên đăng nhập khi mở lại app qua `GET /me`.
  - Đăng xuất (`POST /logout`) và dọn dẹp sạch token thiết bị.
- **Quản lý danh mục & sản phẩm (Products):**
  - Hiển thị danh sách sản phẩm kèm hình ảnh, giá bán, mô tả.
  - Lọc sản phẩm theo trạng thái: Còn hàng (`con_hang`), Hết hàng (`het_hang`), Ngừng bán (`ngung_ban`).
  - Xử lý mượt mà các trạng thái UI: Đang tải (Loading), Trống (Empty State), Lỗi (Error State có nút thử lại).
- **Cơ chế mạng & Bảo mật nâng cao:**
  - Tự động đính kèm `Bearer Token` vào mọi request qua Dio Interceptor.
  - Xử lý mã lỗi tập trung (400, 401 Unauthorized, 403, 500, Timeout).
  - Hỗ trợ gọi API HTTP nội bộ trên môi trường Development qua Android Cleartext Traffic.

---

## Thư viện & Công nghệ sử dụng

- **Flutter SDK**: `>= 3.19.0` | **Dart**: `>= 3.3.0`
- **State Management**: `flutter_bloc: ^8.1.6` (tách biệt logic nghiệp vụ và giao diện).
- **Mạng (Networking)**: `dio: ^5.4.1` (REST client, Interceptors, timeouts).
- **Bảo mật & Lưu trữ**:
  - `flutter_secure_storage: ^9.0.0`: Lưu JWT Access Token mã hóa qua Android Keystore.
  - `shared_preferences: ^2.2.2`: Lưu cấu hình cài đặt cục bộ và cờ trạng thái app.
- **UI Icon**: `cupertino_icons: ^1.0.6`.

---

## Kiến trúc thư mục dự án

Dự án áp dụng mô hình phân tách tầng rõ ràng (**Layered Architecture**):

```text
tnm_app/
├── android/                        # Cấu hình Android Manifest & Permissions
├── lib/
│   ├── core/                       # Thành phần dùng chung toàn app
│   │   ├── network/                # ApiClient, ApiExceptions, Dio Interceptors
│   │   └── storage/                # TokenStorage (Secure Storage & Shared Prefs)
│   ├── data/                       # Tầng dữ liệu (Data Layer)
│   │   ├── models/                 # ProductModel, Enum trạng thái, UserModel
│   │   └── repositories/           # AuthRepository, ProductRepository
│   ├── presentation/               # Tầng hiển thị (UI Layer)
│   │   ├── blocs/                  # AuthBloc, ProductBloc/Cubit
│   │   └── product/                # Module màn hình sản phẩm
│   │       ├── product_list_screen.dart
│   │       └── widgets/            # ProductCard, FilterChip, EmptyState,...
│   └── main.dart                   # Điểm khởi chạy ứng dụng (Entry point)
└── pubspec.yaml
```

## Hướng Dẫn Cài Đặt và Khởi Chạy Dự Án

2. Các bước cài đặt
Bước 1: Clone repository về máy
Bash
git clone [https://github.com/luongha3132005-cell/tnm_app.git](https://github.com/luongha3132005-cell/tnm_app.git)
cd tnm_app
Bước 2: Tải các thư viện phụ thuộc (Dependencies)

Bash
flutter pub get
Bước 3: Cấu hình địa chỉ API Backend
Mở file cấu hình mạng lib/core/network/api_client.dart (hoặc nơi cấu hình Base URL) để trỏ đến server tương ứng:

Chạy trên máy ảo Android mặc định: Dùng IP http://10.0.2.2:<cổng_port> (đại diện cho localhost của máy tính).

Chạy trên điện thoại Android thật: Dùng IP mạng Wi-Fi nội bộ của máy tính (ví dụ: http://192.168.1.x:<cổng_port>). Lưu ý cả điện thoại và máy tính phải kết nối chung một mạng Wi-Fi.

Server deploy online: Điền trực tiếp URL máy chủ backend.

3. Chạy ứng dụng (Debug Mode)
Mở sẵn máy ảo Android hoặc cắm điện thoại vào máy tính.

Kiểm tra danh sách thiết bị khả dụng:

Bash
flutter devices
Chạy ứng dụng:

Bash
flutter run
4. Đóng gói file cài đặt (Build APK)
Để tạo file APK Release cài thử nghiệm trên các máy Android độc lập:

Bash
flutter build apk --release
Sau khi tiến trình build kết thúc, file APK sẽ nằm tại đường dẫn:

Plaintext
build/app/outputs/flutter-apk/app-release.apk
5. Khắc phục sự cố thường gặp (Troubleshooting)
Lỗi không kết nối được API HTTP cục bộ (Cleartext HTTP traffic not permitted):

Mở file android/app/src/main/AndroidManifest.xml, thêm thuộc tính android:usesCleartextTraffic="true" vào trong thẻ <application>:

XML
<application
    ...
    android:usesCleartextTraffic="true">
Lỗi xung đột bộ nhớ đệm (Cache / Gradle):

Chạy lần lượt chuỗi lệnh sau để làm sạch dự án và build lại:

Bash
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter run
