#!/bin/bash
# Script to test all SQL queries in the dbt project

set -e  # Exit on any error

echo "Testing all SQL queries in the dbt project..."

# 1. Run dbt compile to check all model syntax
echo "Step 1: Compiling all dbt models..."
dbt compile

# 2. Run the specific test for SQL query validity
echo "Step 2: Running SQL validity tests..."
dbt test --select test_sql_query_validity

# 3. Run the Python integration test for all SQL files
echo "Step 3: Running integration tests for all SQL files..."
python tests/integration/test_all_queries.py

# 4. Test the analysis queries specifically
echo "Step 4: Testing analysis queries..."
for analysis in analyses/*.sql; do
  echo "Testing $analysis..."
  
  # Extract just the filename without extension
  filename=$(basename "$analysis" .sql)
  
  # Run the query through dbt compile
  dbt compile --select "analysis:$filename"
done

echo "All tests completed successfully!"