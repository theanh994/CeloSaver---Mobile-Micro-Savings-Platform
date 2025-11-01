# 🪙 CeloSaver Smart Contract

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
```

### `mapping`
```solidity
mapping(address => SavingsGoal[]) public userGoals;
mapping(address => uint256) public totalSavings;
```
- `userGoals`: Danh sách tất cả mục tiêu của mỗi người dùng.  
- `totalSavings`: Tổng số CELO đang tiết kiệm của người dùng trên tất cả mục tiêu.

---

## ⚙️ Các hàm chính

### 🔸 Dành cho người dùng

| Hàm | Mô tả |
|------|-------|
| `createGoal(string _name, uint256 _targetAmount, uint256 _durationInDays)` | Tạo một mục tiêu tiết kiệm mới. |
| `deposit(uint256 _goalId)` *(payable)* | Gửi CELO vào mục tiêu có mã `_goalId`. |
| `withdraw(uint256 _goalId, uint256 _amount)` | Rút một phần tiền từ mục tiêu. |
| `closeGoal(uint256 _goalId)` | Đóng mục tiêu và rút toàn bộ số dư còn lại. |

### 🔹 Hàm xem (View)

| Hàm | Mô tả |
|------|-------|
| `getUserGoals(address _user)` | Trả về danh sách mục tiêu của người dùng. |
| `getGoal(address _user, uint256 _goalId)` | Lấy thông tin chi tiết của mục tiêu. |
| `getGoalCount(address _user)` | Trả về số lượng mục tiêu hiện có. |
| `getTotalSavings(address _user)` | Tổng số CELO đang tiết kiệm. |
| `isGoalCompleted(address _user, uint256 _goalId)` | Kiểm tra xem mục tiêu đã hoàn thành chưa. |
| `getGoalProgress(address _user, uint256 _goalId)` | Tính phần trăm tiến trình hoàn thành (0–100%). |

---

## 🚀 Triển khai & Kiểm thử

### Yêu cầu
- **Solidity:** `^0.8.19`  
- **Môi trường:** Remix / Hardhat / Truffle  
- **Mạng:** Celo Mainnet hoặc Alfajores Testnet  

### Các bước triển khai
1. Biên dịch hợp đồng bằng Solidity Compiler (`^0.8.19`).
2. Triển khai lên Celo Testnet (ví dụ: **Alfajores**).
3. Gọi `createGoal` để tạo mục tiêu tiết kiệm.
4. Gọi `deposit` kèm giá trị CELO để nạp tiền vào mục tiêu.
5. Sử dụng các hàm `getGoal` hoặc `getGoalProgress` để theo dõi tiến trình.

---

## 🔮 Kế hoạch phát triển tương lai

| Hướng mở rộng | Mô tả |
|----------------|--------|
| **Hỗ trợ Stablecoin (ERC20)** | Thêm hỗ trợ cUSD, cREAL để giảm rủi ro biến động giá. |
| **Sinh lãi tự động** | Tích hợp các giao thức DeFi trên Celo như Mento để sinh lợi từ số tiền tiết kiệm. |
| **Dashboard thống kê** | Giao diện trực quan hóa tiến trình tiết kiệm và phần thưởng. |

---

## ⚠️ Tuyên bố miễn trừ trách nhiệm

> Mã nguồn này được cung cấp cho mục đích **trình diễn**.  
> Hợp đồng **chưa được kiểm toán bảo mật**, **không nên sử dụng trong môi trường sản xuất** cho đến khi được đánh giá bởi tổ chức audit chuyên nghiệp.

---

## 🧑‍💻 Giấy phép

**MIT License** — Tự do sử dụng, sao chép, chỉnh sửa và phân phối với điều kiện ghi rõ nguồn.
