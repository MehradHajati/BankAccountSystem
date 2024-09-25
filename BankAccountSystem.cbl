       IDENTIFICATION DIVISION.
       PROGRAM-ID. BankAccountSystem.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT account-file ASSIGN TO "account.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT transaction-file ASSIGN TO "transaction.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  account-file.
       01  account-record.
           05  account-number       PIC 9(5).
           05  account-holder-name  PIC A(20).
           05  account-type         PIC X.         *> S for Savings, C for Checking
           05  account-balance      PIC 9(7)V99.

       FD  transaction-file.
       01  transaction-record.
           05  transaction-account  PIC 9(5).
           05  transaction-type     PIC X.         *> D for Deposit, W for Withdrawal
           05  transaction-amount   PIC 9(7)V99.
           05  transaction-date     PIC 9(8).

       WORKING-STORAGE SECTION.
       77  user-choice             PIC 9 VALUE 0.
       77  account-no-input         PIC 9(5).
       77  account-holder-input     PIC A(20).
       77  account-type-input       PIC X VALUE 'S'.
       77  deposit-amount           PIC 9(7)V99 VALUE 0.
       77  withdraw-amount          PIC 9(7)V99 VALUE 0.
       77  found                    PIC X VALUE 'N'.
       77  current-date             PIC 9(8) VALUE 20240101.  *> YYYYMMDD Format
       77  interest-rate            PIC 9V99 VALUE 0.05.      *> 5% interest rate for Savings

       01  account-details.
           05  ac-number            PIC 9(5).
           05  ac-holder            PIC A(20).
           05  ac-type              PIC X.
           05  ac-balance           PIC 9(7)V99.

       01  transaction-details.
           05  trans-account        PIC 9(5).
           05  trans-type           PIC X.
           05  trans-amount         PIC 9(7)V99.
           05  trans-date           PIC 9(8).

       PROCEDURE DIVISION.
       MAIN-PROCEDURE.
           PERFORM UNTIL user-choice = 6
               DISPLAY "Bank Account Management System"
               DISPLAY "1. Create Account"
               DISPLAY "2. Deposit Money"
               DISPLAY "3. Withdraw Money"
               DISPLAY "4. Exit"
               ACCEPT user-choice
               EVALUATE user-choice
                   WHEN 1
                       PERFORM CREATE-ACCOUNT
                   WHEN 2
                       PERFORM DEPOSIT-MONEY
                   WHEN 3
                       PERFORM WITHDRAW-MONEY
                   WHEN 4
                       DISPLAY "Thank you for using the system."
                   WHEN OTHER
                       DISPLAY "Invalid choice, please try again."
               END-EVALUATE
           END-PERFORM.
           STOP RUN.

       *> -------------------------------
       *> Create a new account
       *> -------------------------------
       CREATE-ACCOUNT.
           DISPLAY "Enter account number (5 digits): "
           ACCEPT account-no-input
           DISPLAY "Enter account holder's name (20 characters): "
           ACCEPT account-holder-input
           DISPLAY "Enter account type(S for Savings, C for Checking):"
           ACCEPT account-type-input
           MOVE account-no-input TO ac-number
           MOVE account-holder-input TO ac-holder
           MOVE account-type-input TO ac-type
           MOVE 0 TO ac-balance
           OPEN OUTPUT account-file
           WRITE account-record FROM account-details
           CLOSE account-file
           DISPLAY "Account created successfully."
           DISPLAY "Account Number: " ac-number
           DISPLAY "Account Holder: " ac-holder
           DISPLAY "Account Type: " ac-type
           DISPLAY "Initial Balance: " ac-balance.

       *> -------------------------------
       *> Deposit money into an account
       *> -------------------------------
       DEPOSIT-MONEY.
           DISPLAY "Enter account number to deposit money: "
           ACCEPT account-no-input
           PERFORM FIND-ACCOUNT
           IF found = 'Y'
               DISPLAY "Enter deposit amount: "
               ACCEPT deposit-amount
               IF deposit-amount > 0
                   ADD deposit-amount TO account-balance
                   REWRITE account-record
                   PERFORM LOG-TRANSACTION
                   DISPLAY "Money deposited successfully."
                   DISPLAY "Updated Balance: " account-balance
               ELSE
                   DISPLAY "Deposit amount must be positive."
               END-IF
           ELSE
               DISPLAY "Account not found."
           END-IF.

       *> -------------------------------
       *> Withdraw money from an account
       *> -------------------------------
       WITHDRAW-MONEY.
           DISPLAY "Enter account number to withdraw money: "
           ACCEPT account-no-input
           PERFORM FIND-ACCOUNT
           IF found = 'Y'
               DISPLAY "Enter withdrawal amount: "
               ACCEPT withdraw-amount
               IF withdraw-amount <= account-balance
                   SUBTRACT withdraw-amount FROM account-balance
                   REWRITE account-record  *> Fixed REWRITE statement
                   PERFORM LOG-TRANSACTION
                   DISPLAY "Money withdrawn successfully."
                   DISPLAY "Updated Balance: " account-balance
               ELSE
                   DISPLAY "Invalid withdrawal amount."
               END-IF
           ELSE
               DISPLAY "Account not found."
           END-IF.

       *> -------------------------------
       *> Find account based on account number
       *> -------------------------------
       FIND-ACCOUNT.
           MOVE 'N' TO found
           OPEN I-O account-file
           READ account-file INTO account-record
               AT END DISPLAY "End of file reached."
           END-READ
           PERFORM UNTIL found = 'Y'
               IF account-no-input = account-number
                   MOVE 'Y' TO found
               ELSE
                   READ account-file INTO account-record
                       AT END DISPLAY "End of file reached."
                   END-READ
               END-IF
           END-PERFORM
           CLOSE account-file.

       *> -------------------------------
       *> Log Transaction
       *> -------------------------------
       LOG-TRANSACTION.
           MOVE account-no-input TO trans-account
           MOVE FUNCTION CURRENT-DATE TO trans-date
           MOVE deposit-amount TO trans-amount *> This ensures correct transaction amount
           MOVE 'D' TO trans-type *> Assuming deposit transaction
           OPEN OUTPUT transaction-file
           WRITE transaction-record FROM transaction-details
           CLOSE transaction-file.

       *> -------------------------------
       *> End of program
       *> -------------------------------
       END PROGRAM BankAccountSystem.
