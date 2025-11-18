#!/usr/bin/env python
"""
Test script to validate all SQL queries in the dbt project.
"""

import os
import subprocess
import sys
from pathlib import Path

def find_sql_files(base_dir):
    """Find all SQL files in the project."""
    exclude_dirs = ['target', 'dbt_packages', 'logs']
    sql_files = []
    
    for root, dirs, files in os.walk(base_dir):
        dirs[:] = [d for d in dirs if d not in exclude_dirs]
        for file in files:
            if file.endswith('.sql'):
                sql_files.append(os.path.join(root, file))
    
    return sql_files

def get_dbt_selector(file_path, project_root):
    """Get the dbt selector for a file."""
    rel_path = os.path.relpath(file_path, project_root)
    
    if rel_path.startswith('models/'):
        return f"model:{rel_path[7:].replace('.sql', '').replace('/', '.')}"
    elif rel_path.startswith('analyses/'):
        return f"analysis:{os.path.basename(rel_path).replace('.sql', '')}"
    elif rel_path.startswith('tests/generic/'):
        return f"test:{os.path.basename(rel_path).replace('.sql', '')}"
    else:
        return None

def validate_query(file_path, project_root):
    """Validate a SQL query using dbt compile."""
    selector = get_dbt_selector(file_path, project_root)
    if not selector:
        return True, "Skipped (not a compilable resource)"
    
    try:
        result = subprocess.run(
            ["dbt", "compile", "--select", selector],
            capture_output=True,
            text=True,
            cwd=project_root
        )
        if result.returncode == 0:
            return True, "Compilation successful"
        else:
            return False, f"Failed: {result.stderr.splitlines()[0]}"
    except Exception as e:
        return False, f"Error: {str(e)}"

def main():
    project_root = str(Path(__file__).parent.parent.parent)
    sql_files = find_sql_files(project_root)
    
    results = []
    for file_path in sql_files:
        print(f"Testing: {os.path.relpath(file_path, project_root)}")
        success, message = validate_query(file_path, project_root)
        results.append({
            "file": os.path.relpath(file_path, project_root),
            "success": success,
            "message": message
        })
    
    failures = [r for r in results if not r["success"]]
    
    if failures:
        print(f"\n❌ {len(failures)} queries failed:")
        for f in failures:
            print(f"  - {f['file']}: {f['message']}")
        sys.exit(1)
    else:
        print(f"\n✅ All {len([r for r in results if 'Skipped' not in r['message']])} SQL queries are valid!")
        sys.exit(0)

if __name__ == "__main__":
    main()