# Bank Account System in COBOL

## Overview
This project is a simple **Bank Account System** written in **COBOL**. The system simulates basic banking operations such as account creation, deposits, withdrawals, balance inquiry, transaction logging, and applying interest to savings accounts.


## Features
- **Create Account**: Create a new bank account with a unique account number, holder name, and account type (Savings or Checking).
- **Deposit Money**: Deposit a specified amount into an existing account.
- **Withdraw Money**: Withdraw a specified amount from an existing account, ensuring there are sufficient funds.
  
## Files
- `BankAccountSystem.cbl`: The main COBOL source file that implements the bank management system.
- `account.dat`: A file where account information is stored.
- `transaction.dat`: A file where all transaction logs are stored.

## How to Run

### 1. Install a COBOL Compiler

- Install **GNU COBOL** (OpenCOBOL) using [WSL (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install), [Cygwin](https://cygwin.com/), or use a precompiled binary from [SourceForge](https://sourceforge.net/projects/open-cobol/files/).
  
### 2. Compile the Program

```bash
cobc -x -o BankAccountManagementSystem BankAccountManagementSystem.cbl
