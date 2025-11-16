# Renaming the Project to dbt-fivetran-logs

## What Was Changed

All internal references to the project name have been updated:

### ✅ Files Updated:
1. **`dbt_project.yml`** - Project name changed from `fivetran_analytics` to `dbt_fivetran_logs`
2. **`README.md`** - Title updated to `dbt-fivetran-logs`
3. **`SETUP_GUIDE.md`** - References updated, personal info removed
4. **`PROJECT_SUMMARY.md`** - Title updated
5. **`PRIVATE_KEY_SETUP.md`** - Personal file paths removed
6. **`.dbt/profiles.yml`** - Query tag updated to `dbt-fivetran-logs`

### ⚠️ What Needs Manual Action:

To complete the rename, you need to:

## Step 1: Rename the Local Directory

```bash
# Navigate to the parent directory
cd /Users/jason.chletsos/Documents/GitHub/

# Rename the directory
mv dbt-nao-testing dbt-fivetran-logs

# Navigate into the renamed directory
cd dbt-fivetran-logs
```

## Step 2: Update Git Remote (If Applicable)

If you've already pushed this to GitHub and want to rename the repository:

### Option A: Rename on GitHub
1. Go to your repository on GitHub
2. Click **Settings**
3. Under **Repository name**, change it to `dbt-fivetran-logs`
4. Click **Rename**

GitHub will automatically redirect the old URL to the new one, so you don't need to update your local remote.

### Option B: Create a New Repository
If you want a fresh start:

```bash
# Remove the old remote (if exists)
git remote remove origin

# Create a new repository on GitHub named 'dbt-fivetran-logs'
# Then add it as the remote
git remote add origin https://github.com/<your-username>/dbt-fivetran-logs.git

# Push to the new repository
git push -u origin main
```

## Step 3: Verify Everything Works

```bash
# Test the connection
dbt debug

# Compile the project with the new name
dbt compile

# Run a quick test
dbt run --select stg_fivetran_log__connection
```

## Step 4: Update Any External References

If you have any of the following, update them:

- [ ] CI/CD pipelines (GitHub Actions, GitLab CI, etc.)
- [ ] Documentation links
- [ ] Bookmarks or shortcuts
- [ ] Team documentation
- [ ] Slack/Teams channel topics
- [ ] dbt Cloud project settings (if using dbt Cloud)

## What Changed Internally

### Project Name in `dbt_project.yml`
```yaml
# Before
name: 'fivetran_analytics'

# After
name: 'dbt_fivetran_logs'
```

### Model Configuration
```yaml
# Before
models:
  fivetran_analytics:
    staging:
      ...

# After
models:
  dbt_fivetran_logs:
    staging:
      ...
```

### Query Tag
```yaml
# Before
query_tag: dbt-fivetran-analytics

# After
query_tag: dbt-fivetran-logs
```

## Important Notes

✅ **Schema names remain the same** - Your data will still be in:
- `stg_fivetran_log` (staging)
- `int_fivetran_log` (intermediate)
- `fivetran_analytics` (marts)

✅ **No data migration needed** - This is just a project name change

✅ **All models will be recompiled** - The first `dbt run` after the rename will recompile all models

✅ **Git history preserved** - Renaming the directory doesn't affect your git history

## Troubleshooting

### Issue: "Could not find a profile named 'default'"

**Solution**: Make sure you're in the renamed directory:
```bash
pwd
# Should show: /Users/jason.chletsos/Documents/GitHub/dbt-fivetran-logs
```

### Issue: "Project name mismatch"

**Solution**: Run `dbt clean` and then `dbt compile` to clear any cached files:
```bash
dbt clean
dbt compile
```

### Issue: Old directory still showing in terminal

**Solution**: Close and reopen your terminal, or navigate out and back in:
```bash
cd ..
cd dbt-fivetran-logs
```

---

**After completing these steps, your project will be fully renamed to `dbt-fivetran-logs`!** 🎉
