# 🪙 CeloSaver Smart Contract

**CeloSaver** is a **DeFi smart contract** that allows users to create **personal savings goals** and manage their assets in a **decentralized** way on the **Celo blockchain**.
Users can create goals, deposit CELO, track their progress, and withdraw funds anytime — completely self-custodied, transparent, and secure.

---

## 📘 Overview

This smart contract serves as the **decentralized back-end** for the **CeloSaver mobile app**, enabling:

* Anyone with a Celo wallet to start saving.
* Direct on-chain management and progress tracking.
* All interactions are made with Celo’s native asset (**CELO**) via `msg.value`.

---

## ✨ Key Features

| Feature            | Description                                                                               |
| ------------------ | ----------------------------------------------------------------------------------------- |
| **Create Goals**   | Users can create multiple savings goals with custom names, target amounts, and deadlines. |
| **Deposit Funds**  | Deposit CELO into an active savings goal.                                                 |
| **Withdraw Funds** | Withdraw a portion of funds from a specific goal.                                         |
| **Close Goals**    | Close a goal (completed or not) and withdraw the remaining balance.                       |
| **Track Progress** | View total savings and progress toward each goal.                                         |
| **Events**         | Emits events when goals are created, deposited into, withdrawn from, or completed.        |

---

## 🧱 Contract Structure

### `struct SavingsGoal`

```solidity
struct SavingsGoal {
    string name;            // Goal name
    uint256 targetAmount;   // Target amount to save
    uint256 currentAmount;  // Current amount saved
    uint256 deadline;       // Deadline (timestamp)
    bool isActive;          // Goal active status
    uint256 createdAt;      // Creation timestamp
}
```

### `mapping`

```solidity
mapping(address => SavingsGoal[]) public userGoals;
mapping(address => uint256) public totalSavings;
```

* `userGoals`: List of all goals created by each user.
* `totalSavings`: Total CELO saved across all goals for a user.

---

## ⚙️ Core Functions

### 🔸 User Functions

| Function                                                                   | Description                                        |
| -------------------------------------------------------------------------- | -------------------------------------------------- |
| `createGoal(string _name, uint256 _targetAmount, uint256 _durationInDays)` | Create a new savings goal.                         |
| `deposit(uint256 _goalId)` *(payable)*                                     | Deposit CELO into a specific goal by its ID.       |
| `withdraw(uint256 _goalId, uint256 _amount)`                               | Withdraw a partial amount from the selected goal.  |
| `closeGoal(uint256 _goalId)`                                               | Close the goal and withdraw the remaining balance. |

### 🔹 View Functions

| Function                                          | Description                                         |
| ------------------------------------------------- | --------------------------------------------------- |
| `getUserGoals(address _user)`                     | Returns all goals for a specific user.              |
| `getGoal(address _user, uint256 _goalId)`         | Returns detailed information about a specific goal. |
| `getGoalCount(address _user)`                     | Returns the total number of goals for a user.       |
| `getTotalSavings(address _user)`                  | Returns the total CELO saved by a user.             |
| `isGoalCompleted(address _user, uint256 _goalId)` | Checks if a goal has been completed.                |
| `getGoalProgress(address _user, uint256 _goalId)` | Calculates completion progress percentage (0–100%). |

---

## 🚀 Deployment & Testing

### Requirements

* **Solidity:** `^0.8.19`
* **Environment:** Remix / Hardhat / Truffle
* **Network:** Celo Mainnet or Alfajores Testnet

### Deployment Steps

1. Compile the contract using the Solidity compiler (`^0.8.19`).
2. Deploy to a Celo network (e.g., **Alfajores Testnet**).
3. Call `createGoal` to create a new savings goal.
4. Call `deposit` with CELO value to add funds to your goal.
5. Use `getGoal` or `getGoalProgress` to monitor your progress.

---

## 🔮 Future Roadmap

| Feature                        | Description                                                            |
| ------------------------------ | ---------------------------------------------------------------------- |
| **Stablecoin Support (ERC20)** | Add support for cUSD, cREAL to reduce price volatility.                |
| **Auto-Yield Integration**     | Integrate with Celo DeFi protocols such as Mento to generate interest. |
| **Analytics Dashboard**        | Build a visual dashboard for tracking progress and rewards.            |

---

## ⚠️ Disclaimer

> This source code is provided for **demonstration purposes only**.
> The smart contract **has not been audited** and **should not be used in production** until it has been professionally security-audited.

---

## 🧑‍💻 License

**MIT License** — Free to use, copy, modify, and distribute, provided proper attribution is given.
