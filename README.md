from pathlib import Path

readme_content = """# 🪙 CeloSaver Smart Contract

CeloSaver là **hợp đồng thông minh DeFi** giúp người dùng tạo các **mục tiêu tiết kiệm cá nhân** (Savings Goals) và quản lý tài sản một cách **phi tập trung** trên blockchain **Celo**.  
Người dùng có thể tạo mục tiêu, gửi tiền (CELO), theo dõi tiến trình, và rút tiền bất kỳ lúc nào — hoàn toàn tự chủ, minh bạch và an toàn.

---

## 📘 Tổng quan

Hợp đồng thông minh này đóng vai trò là **back-end phi tập trung** cho ứng dụng di động **CeloSaver App**, cho phép:
- Mọi người có ví Celo đều có thể bắt đầu tiết kiệm.
- Quản lý và theo dõi tiến trình tiết kiệm trực tiếp trên chuỗi.
- Hoạt động hoàn toàn bằng tài sản gốc của Celo (CELO) thông qua `msg.value`.

---

## ✨ Tính năng chính

| Tính năng | Mô tả |
|------------|--------|
| **Tạo mục tiêu** | Người dùng có thể tạo nhiều mục tiêu tiết kiệm với tên, số tiền và thời hạn tùy chỉnh. |
| **Gửi tiền (deposit)** | Gửi CELO vào mục tiêu đang hoạt động. |
| **Rút tiền (withdraw)** | Rút một phần tiền từ mục tiêu đã chọn. |
| **Đóng mục tiêu** | Đóng mục tiêu (hoàn thành hoặc không) và rút toàn bộ số dư còn lại. |
| **Theo dõi tiến trình** | Xem tổng số tiền tiết kiệm và tiến độ đạt được của từng mục tiêu. |
| **Sự kiện (Events)** | Hợp đồng phát sự kiện khi người dùng tạo, gửi tiền, rút tiền hoặc hoàn thành mục tiêu. |

---

## 🧱 Cấu trúc hợp đồng

### `struct SavingsGoal`
```solidity
struct SavingsGoal {
    string name;            // Tên mục tiêu
    uint256 targetAmount;   // Số tiền mục tiêu
    uint256 currentAmount;  // Số tiền đã tiết kiệm
    uint256 deadline;       // Hạn cuối (timestamp)
    bool isActive;          // Trạng thái hoạt động
    uint256 createdAt;      // Ngày tạo
}

