# Contributing to dbt-fivetran-logs

Thank you for your interest in contributing to this project! This guide will help you get started.

## 📋 Prerequisites

Before you begin, ensure you have:

- **Snowflake Account** with access to Fivetran log data
- **dbt Core 1.8.0+** installed
- **Python 3.8+** for running dbt
- **Fivetran Log Connector** configured and syncing data

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd dbt-fivetran-logs
```

### 2. Set Up Environment Variables

```bash
# Copy the example environment file
cp .nao.env.example .nao.env

# Edit .nao.env and add your Snowflake private key
# See PRIVATE_KEY_SETUP.md for detailed instructions
```

### 3. Configure Your Connection

Edit `profiles.yml` with your Snowflake connection details:

```yaml
default:
  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT
      user: YOUR_USER
      role: YOUR_ROLE
      database: YOUR_DATABASE
      warehouse: YOUR_WAREHOUSE
      schema: YOUR_SCHEMA
      private_key_path: "{{ env_var('SNOWFLAKE_PRIVATE_KEY') }}"
      threads: 4
  target: dev
```

### 4. Test Your Connection

```bash
dbt debug
```

### 5. Build the Project

```bash
dbt build
```

## 📁 Project Structure

```
dbt-fivetran-logs/
├── models/
│   ├── staging/           # 32 staging models (source data standardization)
│   ├── intermediate/      # Business logic transformations
│   └── marts/            # Analytics-ready fact tables
├── analyses/             # Ad-hoc SQL queries for exploration
├── macros/              # Reusable SQL functions
├── tests/               # Custom data tests
└── seeds/               # Static reference data (if any)
```

## 🔧 Development Workflow

### Adding a New Staging Model

1. **Identify the source table** in the Fivetran log schema
2. **Create the SQL file** in `models/staging/`
3. **Add documentation** in `models/staging/stg_fivetran_log.yml`
4. **Add tests** for key columns (not_null, unique)
5. **Run and test** your model

Example:

```sql
-- models/staging/stg_fivetran_log__new_table.sql
with source as (
    select * from {{ source('fivetran_log', 'new_table') }}
),

renamed as (
    select
        id as new_table_id,
        name as table_name,
        created_at,
        _fivetran_synced
    from source
)

select * from renamed
```

### Adding Documentation

Always document your models in the corresponding YAML file:

```yaml
- name: stg_fivetran_log__new_table
  description: Description of what this table contains
  columns:
    - name: new_table_id
      description: Unique identifier
      data_tests:
        - not_null
        - unique
    - name: table_name
      description: Name of the table
```

### Running Tests

```bash
# Run all tests
dbt test

# Run tests for a specific model
dbt test --select stg_fivetran_log__new_table

# Run a specific test type
dbt test --select test_type:unique
```

### Building Specific Models

```bash
# Build a single model
dbt build --select stg_fivetran_log__new_table

# Build a model and its downstream dependencies
dbt build --select stg_fivetran_log__new_table+

# Build a model and its upstream dependencies
dbt build --select +stg_fivetran_log__new_table
```

## 📝 Code Style Guidelines

### SQL Style

- Use **lowercase** for SQL keywords and function names
- Use **snake_case** for column and table names
- **Indent** with 4 spaces (not tabs)
- Use **CTEs** (Common Table Expressions) for readability
- Always use the `source()` macro for source tables
- Always use the `ref()` macro for model dependencies

Example:

```sql
with source as (
    select * from {{ source('fivetran_log', 'connection') }}
),

renamed as (
    select
        id as connection_id,
        connector_id,
        connecting_user_id,
        created_at,
        destination_id,
        name as connection_name,
        paused as is_paused,
        signed_up,
        sync_frequency as sync_frequency_minutes,
        _fivetran_deleted as is_deleted,
        _fivetran_synced
    from source
)

select * from renamed
```

### Naming Conventions

- **Staging models**: `stg_<source>__<table>`
- **Intermediate models**: `int_<source>__<description>`
- **Mart models**: `fct_<description>` or `dim_<description>`
- **Tests**: Descriptive names that explain what's being tested

### Documentation Standards

- Every model must have a description
- Every column should have a description
- Key columns must have data tests (not_null, unique)
- Foreign key relationships should be documented

## 🧪 Testing Standards

### Required Tests

All staging models should have:
- `not_null` tests on primary keys
- `unique` tests on primary keys
- `not_null` tests on foreign keys

### Custom Tests

Create custom tests in the `tests/` directory for business logic validation.

## 🔄 Pull Request Process

1. **Create a feature branch** from `main`
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following the code style guidelines

3. **Test your changes**
   ```bash
   dbt build
   dbt test
   ```

4. **Update documentation** (README, YAML files, etc.)

5. **Commit your changes** with clear, descriptive messages
   ```bash
   git add .
   git commit -m "Add staging model for new_table"
   ```

6. **Push to your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request** with:
   - Clear description of changes
   - Screenshots (if applicable)
   - Test results
   - Documentation updates

## 📊 Performance Considerations

- **Staging models** should be materialized as `view` (default)
- **Intermediate models** should be materialized as `view` unless they're expensive
- **Mart models** should be materialized as `table` for query performance
- Use **incremental models** for large, append-only tables

## 🐛 Reporting Issues

When reporting issues, please include:

1. **Description** of the issue
2. **Steps to reproduce**
3. **Expected behavior**
4. **Actual behavior**
5. **dbt version** (`dbt --version`)
6. **Error messages** (if any)
7. **Screenshots** (if applicable)

## 💡 Feature Requests

We welcome feature requests! Please:

1. Check if the feature already exists
2. Describe the use case clearly
3. Explain why it would be valuable
4. Provide examples if possible

## 📚 Additional Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [Fivetran Log ERD](https://fivetran.com/connector-erd/fivetran_log)
- [Fivetran Log Connector Docs](https://fivetran.com/docs/logs/fivetran-log)
- [Snowflake Documentation](https://docs.snowflake.com/)

## 🤝 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help others learn and grow

## 📧 Contact

For questions or support:
- Email: jason.chletsos@fivetran.com
- Open an issue on GitHub

---

**Thank you for contributing!** 🎉
