-- This file creates our entire system from scratch
-- Don't worry about understanding every line yet

CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    transaction_date TEXT NOT NULL
);

-- Insert good transactions (these should pass all checks)
INSERT INTO transactions VALUES (1, 101, 49.99, '2025-10-28');
INSERT INTO transactions VALUES (2, 102, 150.00, '2025-10-29');
INSERT INTO transactions VALUES (3, 103, 25.50, '2025-10-29');

-- Insert BAD transactions (these will be caught by our checks)
INSERT INTO transactions VALUES (4, 104, -10.00, '2025-10-29');  -- NEGATIVE AMOUNT
INSERT INTO transactions VALUES (5, NULL, 99.99, '2025-10-29');  -- MISSING USER

CREATE TABLE data_quality_rules (
    rule_id INTEGER PRIMARY KEY,
    rule_name TEXT NOT NULL,
    table_name TEXT NOT NULL,
    check_query TEXT NOT NULL,
    severity TEXT NOT NULL
);

-- Rule 1: Catch negative amounts
INSERT INTO data_quality_rules VALUES (
    1,
    'positive_amounts',
    'transactions',
    'SELECT COUNT(*) FROM transactions WHERE amount <= 0',
    'CRITICAL'
);

-- Rule 2: Catch missing users
INSERT INTO data_quality_rules VALUES (
    2,
    'no_null_users',
    'transactions',
    'SELECT COUNT(*) FROM transactions WHERE user_id IS NULL',
    'CRITICAL'
);
INSERT INTO transactions VALUES (999, 999, -500.00, '2025-10-30');
