import sqlite3
import sys

# Connect to the database
database_path = 'data/transactions.db'
connection = sqlite3.connect(database_path)
cursor = connection.cursor()

# Get all the rules we need to check
cursor.execute("SELECT rule_id, rule_name, check_query, severity FROM data_quality_rules")
rules = cursor.fetchall()

print("=" * 60)
print("DATA QUALITY CHECK RESULTS")
print("=" * 60)

failed_checks = 0

# Run each rule
for rule in rules:
    rule_id, rule_name, check_query, severity = rule
    
    # Execute the check query
    cursor.execute(check_query)
    violation_count = cursor.fetchone()[0]
    
    # Report the result
    if violation_count == 0:
        status = "✓ PASS"
        symbol = "✓"
    else:
        status = "✗ FAIL"
        symbol = "✗"
        failed_checks += 1
    
    print(f"{symbol} {rule_name}: {violation_count} violations ({severity})")

print("=" * 60)

if failed_checks > 0:
    print(f"RESULT: {failed_checks} checks failed - BLOCKING DEPLOYMENT")
    sys.exit(1)  # This tells other programs we failed
else:
    print("RESULT: All checks passed - SAFE TO DEPLOY")
    sys.exit(0)  # This tells other programs we succeeded

connection.close()
