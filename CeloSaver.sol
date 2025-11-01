// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title CeloSaver - Micro-Savings Platform
 * @dev A DeFi-powered savings platform for financial inclusion on Celo
 * @notice Users can create savings goals and track their progress
 */
contract CeloSaver {
    
    // Struct to represent a savings goal
    struct SavingsGoal {
        string name;
        uint256 targetAmount;
        uint256 currentAmount;
        uint256 deadline;
        bool isActive;
        uint256 createdAt;
    }
    
    // Mapping from user address to their savings goals
    mapping(address => SavingsGoal[]) public userGoals;
    
    // Mapping to track total savings per user
    mapping(address => uint256) public totalSavings;
    
    // Events
    event GoalCreated(
        address indexed user,
        uint256 indexed goalId,
        string name,
        uint256 targetAmount,
        uint256 deadline
    );
    
    event Deposit(
        address indexed user,
        uint256 indexed goalId,
        uint256 amount,
        uint256 newBalance
    );
    
    event Withdrawal(
        address indexed user,
        uint256 indexed goalId,
        uint256 amount,
        uint256 remainingBalance
    );
    
    event GoalCompleted(
        address indexed user,
        uint256 indexed goalId,
        uint256 finalAmount
    );
    
    event GoalClosed(
        address indexed user,
        uint256 indexed goalId
    );
    
    /**
     * @dev Create a new savings goal
     * @param _name Name of the savings goal
     * @param _targetAmount Target amount to save (in wei)
     * @param _durationInDays Duration to achieve the goal
     */
    function createGoal(
        string memory _name,
        uint256 _targetAmount,
        uint256 _durationInDays
    ) external {
        require(_targetAmount > 0, "Target amount must be greater than 0");
        require(_durationInDays > 0, "Duration must be greater than 0");
        require(bytes(_name).length > 0, "Goal name cannot be empty");
        
        uint256 deadline = block.timestamp + (_durationInDays * 1 days);
        
        SavingsGoal memory newGoal = SavingsGoal({
            name: _name,
            targetAmount: _targetAmount,
            currentAmount: 0,
            deadline: deadline,
            isActive: true,
            createdAt: block.timestamp
        });
        
        userGoals[msg.sender].push(newGoal);
        uint256 goalId = userGoals[msg.sender].length - 1;
        
        emit GoalCreated(msg.sender, goalId, _name, _targetAmount, deadline);
    }
    
    /**
     * @dev Deposit funds into a specific savings goal
     * @param _goalId Index of the goal to deposit into
     */
    function deposit(uint256 _goalId) external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        require(_goalId < userGoals[msg.sender].length, "Invalid goal ID");
        
        SavingsGoal storage goal = userGoals[msg.sender][_goalId];
        require(goal.isActive, "Goal is not active");
        
        goal.currentAmount += msg.value;
        totalSavings[msg.sender] += msg.value;
        
        emit Deposit(msg.sender, _goalId, msg.value, goal.currentAmount);
        
        // Check if goal is completed
        if (goal.currentAmount >= goal.targetAmount) {
            emit GoalCompleted(msg.sender, _goalId, goal.currentAmount);
        }
    }
    
    /**
     * @dev Withdraw funds from a specific savings goal
     * @param _goalId Index of the goal to withdraw from
     * @param _amount Amount to withdraw (in wei)
     */
    function withdraw(uint256 _goalId, uint256 _amount) external {
        require(_goalId < userGoals[msg.sender].length, "Invalid goal ID");
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        
        SavingsGoal storage goal = userGoals[msg.sender][_goalId];
        require(goal.isActive, "Goal is not active");
        require(goal.currentAmount >= _amount, "Insufficient balance");
        
        goal.currentAmount -= _amount;
        totalSavings[msg.sender] -= _amount;
        
        // Transfer funds to user
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawal(msg.sender, _goalId, _amount, goal.currentAmount);
    }
    
    /**
     * @dev Close a savings goal and withdraw all funds
     * @param _goalId Index of the goal to close
     */
    function closeGoal(uint256 _goalId) external {
        require(_goalId < userGoals[msg.sender].length, "Invalid goal ID");
        
        SavingsGoal storage goal = userGoals[msg.sender][_goalId];
        require(goal.isActive, "Goal is already closed");
        
        uint256 amount = goal.currentAmount;
        
        goal.isActive = false;
        goal.currentAmount = 0;
        totalSavings[msg.sender] -= amount;
        
        if (amount > 0) {
            (bool success, ) = payable(msg.sender).call{value: amount}("");
            require(success, "Transfer failed");
        }
        
        emit GoalClosed(msg.sender, _goalId);
    }
    
    /**
     * @dev Get all goals for a user
     * @param _user Address of the user
     * @return Array of savings goals
     */
    function getUserGoals(address _user) external view returns (SavingsGoal[] memory) {
        return userGoals[_user];
    }
    
    /**
     * @dev Get a specific goal for a user
     * @param _user Address of the user
     * @param _goalId Index of the goal
     * @return The savings goal
     */
    function getGoal(address _user, uint256 _goalId) external view returns (SavingsGoal memory) {
        require(_goalId < userGoals[_user].length, "Invalid goal ID");
        return userGoals[_user][_goalId];
    }
    
    /**
     * @dev Get the number of goals for a user
     * @param _user Address of the user
     * @return Number of goals
     */
    function getGoalCount(address _user) external view returns (uint256) {
        return userGoals[_user].length;
    }
    
    /**
     * @dev Get total savings for a user across all goals
     * @param _user Address of the user
     * @return Total savings amount
     */
    function getTotalSavings(address _user) external view returns (uint256) {
        return totalSavings[_user];
    }
    
    /**
     * @dev Check if a goal has reached its target
     * @param _user Address of the user
     * @param _goalId Index of the goal
     * @return True if goal is completed
     */
    function isGoalCompleted(address _user, uint256 _goalId) external view returns (bool) {
        require(_goalId < userGoals[_user].length, "Invalid goal ID");
        SavingsGoal memory goal = userGoals[_user][_goalId];
        return goal.currentAmount >= goal.targetAmount;
    }
    
    /**
     * @dev Get progress percentage for a goal
     * @param _user Address of the user
     * @param _goalId Index of the goal
     * @return Progress percentage (0-100)
     */
    function getGoalProgress(address _user, uint256 _goalId) external view returns (uint256) {
        require(_goalId < userGoals[_user].length, "Invalid goal ID");
        SavingsGoal memory goal = userGoals[_user][_goalId];
        
        if (goal.targetAmount == 0) return 0;
        
        uint256 progress = (goal.currentAmount * 100) / goal.targetAmount;
        return progress > 100 ? 100 : progress;
    }
}
