# Model Reference Guide

Complete reference for all models in the dbt-fivetran-logs project.

## 📊 Model Layers

### Staging Layer (32 Models)
Raw data standardization with consistent naming and typing.

### Intermediate Layer (3 Models)
Business logic and aggregations.

### Marts Layer (11 Models)
Analytics-ready fact tables for reporting.

---

## 🗂️ Staging Models (32)

### Core Tables (6)

#### `stg_fivetran_log__account`
**Purpose**: Fivetran account information  
**Key Columns**: `account_id`, `account_name`, `account_status`, `country`  
**Primary Key**: `account_id`

#### `stg_fivetran_log__connection`
**Purpose**: Fivetran connection configurations  
**Key Columns**: `connection_id`, `connection_name`, `connector_type_id`, `destination_id`, `is_paused`  
**Primary Key**: `connection_id`

#### `stg_fivetran_log__connector_type`
**Purpose**: Available connector types and metadata  
**Key Columns**: `connector_type_id`, `connector_name`, `connector_type`, `availability_status`  
**Primary Key**: `connector_type_id`

#### `stg_fivetran_log__destination`
**Purpose**: Destination warehouse configurations  
**Key Columns**: `destination_id`, `destination_name`, `account_id`, `region`, `destination_type`  
**Primary Key**: `destination_id`

#### `stg_fivetran_log__log`
**Purpose**: Event logs from sync operations  
**Key Columns**: `log_id`, `logged_at`, `connection_id`, `event_type`, `message_type`, `sync_id`  
**Primary Key**: `log_id`

#### `stg_fivetran_log__user`
**Purpose**: User information and access  
**Key Columns**: `user_id`, `email`, `first_name`, `last_name`  
**Primary Key**: `user_id`

---

### Usage & Billing (2)

#### `stg_fivetran_log__incremental_mar`
**Purpose**: Monthly Active Rows (MAR) tracking for billing  
**Key Columns**: `connection_name`, `measured_date`, `schema_name`, `table_name`, `is_free`, `incremental_rows`  
**Grain**: One row per connection, schema, table, and date

#### `stg_fivetran_log__transformation_runs`
**Purpose**: dbt transformation execution metrics  
**Key Columns**: `destination_id`, `job_id`, `measured_date`, `job_name`, `model_runs`, `is_free`  
**Grain**: One row per job and date

---

### Schema Metadata (7)

#### `stg_fivetran_log__source_schema`
**Purpose**: Schemas discovered in source systems  
**Key Columns**: `source_schema_id`, `connection_id`, `schema_name`  
**Primary Key**: `source_schema_id`

#### `stg_fivetran_log__source_table`
**Purpose**: Tables discovered in source systems  
**Key Columns**: `source_table_id`, `connection_id`, `source_schema_id`, `table_name`  
**Primary Key**: `source_table_id`

#### `stg_fivetran_log__source_column`
**Purpose**: Columns discovered in source systems  
**Key Columns**: `source_column_id`, `source_table_id`, `column_name`, `data_type`, `is_primary_key`  
**Primary Key**: `source_column_id`

#### `stg_fivetran_log__source_foreign_key`
**Purpose**: Foreign key relationships in source systems  
**Key Columns**: `source_column_id`, `ordinal`, `foreign_key_reference`  
**Grain**: One row per foreign key column

#### `stg_fivetran_log__destination_schema`
**Purpose**: Schemas created in destination systems  
**Key Columns**: `destination_schema_id`, `destination_id`, `connection_id`, `schema_name`  
**Primary Key**: `destination_schema_id`

#### `stg_fivetran_log__destination_table`
**Purpose**: Tables created in destination systems  
**Key Columns**: `destination_table_id`, `destination_id`, `destination_schema_id`, `table_name`  
**Primary Key**: `destination_table_id`

#### `stg_fivetran_log__destination_column`
**Purpose**: Columns created in destination systems  
**Key Columns**: `destination_column_id`, `destination_table_id`, `column_name`, `data_type`  
**Primary Key**: `destination_column_id`

---

### Lineage (3)

#### `stg_fivetran_log__schema_lineage`
**Purpose**: Mapping between source and destination schemas  
**Key Columns**: `destination_schema_id`, `source_schema_id`  
**Grain**: One row per schema mapping

#### `stg_fivetran_log__table_lineage`
**Purpose**: Mapping between source and destination tables  
**Key Columns**: `destination_table_id`, `source_table_id`  
**Grain**: One row per table mapping

#### `stg_fivetran_log__column_lineage`
**Purpose**: Mapping between source and destination columns  
**Key Columns**: `destination_column_id`, `source_column_id`  
**Grain**: One row per column mapping

---

### Change Events (6)

#### `stg_fivetran_log__source_schema_change_event`
**Purpose**: Schema-level changes detected in source systems  
**Key Columns**: `source_schema_id`, `connection_id`, `change_type`, `change_detected_at`  
**Grain**: One row per schema change event

#### `stg_fivetran_log__source_table_change_event`
**Purpose**: Table-level changes detected in source systems  
**Key Columns**: `source_table_id`, `connection_id`, `change_type`, `change_detected_at`  
**Grain**: One row per table change event

#### `stg_fivetran_log__source_column_change_event`
**Purpose**: Column-level changes detected in source systems  
**Key Columns**: `source_column_id`, `attribute_name`, `change_type`, `new_value`, `change_detected_at`  
**Grain**: One row per column change event

#### `stg_fivetran_log__destination_schema_change_event`
**Purpose**: Schema-level changes in destination systems  
**Key Columns**: `destination_schema_id`, `destination_id`, `change_type`, `change_detected_at`  
**Grain**: One row per schema change event

#### `stg_fivetran_log__destination_table_change_event`
**Purpose**: Table-level changes in destination systems  
**Key Columns**: `destination_table_id`, `destination_id`, `change_type`, `change_detected_at`  
**Grain**: One row per table change event

#### `stg_fivetran_log__destination_column_change_event`
**Purpose**: Column-level changes in destination systems  
**Key Columns**: `destination_column_id`, `attribute_name`, `change_type`, `new_value`, `change_detected_at`  
**Grain**: One row per column change event

---

### Access Control & Governance (6)

#### `stg_fivetran_log__team`
**Purpose**: Team definitions for access control  
**Key Columns**: `team_id`, `team_name`, `team_description`, `parent_team_id`, `account_id`  
**Primary Key**: `team_id`

#### `stg_fivetran_log__team_membership`
**Purpose**: User membership in teams  
**Key Columns**: `team_id`, `role_id`, `user_id`, `created_at`  
**Grain**: One row per user-team-role combination

#### `stg_fivetran_log__role`
**Purpose**: Role definitions with permissions  
**Key Columns**: `role_id`, `role_name`, `role_description`, `account_id`  
**Primary Key**: `role_id`

#### `stg_fivetran_log__role_permission`
**Purpose**: Individual permissions assigned to roles  
**Key Columns**: `role_id`, `permission`  
**Grain**: One row per role-permission combination

#### `stg_fivetran_log__role_connector_type`
**Purpose**: Connector type access for roles  
**Key Columns**: `role_id`, `connector_type`  
**Grain**: One row per role-connector type combination

#### `stg_fivetran_log__resource_membership`
**Purpose**: Access control for specific resources  
**Key Columns**: `resource_membership_id`, `role_id`, `team_id`, `user_id`, `destination_id`, `connection_id`  
**Primary Key**: `resource_membership_id`

---

### Audit & Monitoring (2)

#### `stg_fivetran_log__audit_trail`
**Purpose**: Complete audit trail of user actions  
**Key Columns**: `audit_id`, `user_id`, `event_type`, `resource_type`, `resource_id`, `old_values`, `new_values`  
**Primary Key**: `audit_id`

#### `stg_fivetran_log__connector_sdk_log`
**Purpose**: Logs from custom SDK connectors  
**Key Columns**: `log_id`, `connection_id`, `sync_id`, `log_level`, `log_message`, `logged_at`  
**Grain**: One row per log entry

---

## 🔄 Intermediate Models (3)

### `int_fivetran_log__connector_details`
**Purpose**: Enriched connector information with type and destination details  
**Key Columns**: `connection_id`, `connection_name`, `connector_name`, `destination_name`  
**Primary Key**: `connection_id`

### `int_fivetran_log__sync_events`
**Purpose**: Parsed and enriched sync events from logs  
**Key Columns**: `connection_id`, `sync_id`, `event_type`, `logged_at`, `rows_synced`  
**Grain**: One row per sync event

### `int_fivetran_log__daily_api_calls`
**Purpose**: Daily API call aggregations by connector  
**Key Columns**: `connection_id`, `call_date`, `api_calls`  
**Grain**: One row per connection per day

---

## 📈 Mart Models (11)

### `fct_fivetran_connector_health`
**Purpose**: Real-time health metrics for all connectors  
**Use Case**: Monitor connector status and identify issues  
**Key Metrics**: `success_rate_last_7d`, `failed_syncs_last_7d`, `avg_sync_duration_minutes`, `last_sync_status`

### `fct_fivetran_monthly_active_rows`
**Purpose**: MAR tracking for billing and usage analysis  
**Use Case**: Understand data volume and optimize costs  
**Key Metrics**: `total_active_rows`, `free_active_rows`, `paid_active_rows`, `month_date`

### `fct_fivetran_sync_performance`
**Purpose**: Detailed sync performance metrics  
**Use Case**: Analyze sync duration and identify slow connectors  
**Key Metrics**: `sync_duration_minutes`, `rows_synced`, `sync_status`, `started_at`

### `fct_fivetran_error_monitoring`
**Purpose**: Error tracking and classification  
**Use Case**: Identify recurring errors and troubleshoot issues  
**Key Metrics**: `error_count`, `is_recurring_error`, `error_type`, `affected_connections`

### `fct_fivetran_schema_change_history`
**Purpose**: Complete history of schema changes  
**Use Case**: Track schema evolution and impact analysis  
**Key Metrics**: `change_type`, `column_name`, `previous_data_type`, `new_data_type`, `change_detected_at`

### `fct_fivetran_user_activity`
**Purpose**: User action audit and governance  
**Use Case**: Compliance reporting and access monitoring  
**Key Metrics**: `event_count`, `event_type`, `resource_type`, `user_email`

### `fct_fivetran_daily_api_usage`
**Purpose**: Daily API call tracking  
**Use Case**: Monitor API usage and rate limiting  
**Key Metrics**: `api_calls`, `call_date`, `connection_name`

### `fct_fivetran_problematic_connectors`
**Purpose**: Connectors requiring attention  
**Use Case**: Proactive issue identification  
**Key Metrics**: `problem_severity`, `error_rate`, `days_since_success`, `recommended_action`

### `fct_fivetran_sync_performance_trends`
**Purpose**: Performance trends over time  
**Use Case**: Identify performance degradation  
**Key Metrics**: `avg_duration_7d`, `avg_duration_30d`, `trend_direction`

### `fct_fivetran_connector_recommendations`
**Purpose**: Optimization recommendations  
**Use Case**: Improve connector configuration  
**Key Metrics**: `recommendation_type`, `priority`, `expected_impact`

### `fct_fivetran_executive_dashboard`
**Purpose**: High-level KPIs for leadership  
**Use Case**: Executive reporting and platform health  
**Key Metrics**: `total_connectors`, `healthy_connectors_pct`, `total_mar`, `error_count_7d`

---

## 🔍 Common Use Cases

### 1. Find Unhealthy Connectors
```sql
SELECT connection_name, success_rate_last_7d, failed_syncs_last_7d
FROM fivetran_analytics.fct_fivetran_connector_health
WHERE success_rate_last_7d < 0.95
ORDER BY success_rate_last_7d;
```

### 2. Track MAR by Connector
```sql
SELECT 
    connection_name,
    SUM(paid_active_rows) as total_paid_rows
FROM fivetran_analytics.fct_fivetran_monthly_active_rows
WHERE month_date = DATE_TRUNC('month', CURRENT_DATE())
GROUP BY 1
ORDER BY 2 DESC;
```

### 3. Monitor Schema Changes
```sql
SELECT 
    change_detected_at,
    connection_name,
    schema_name,
    table_name,
    column_name,
    change_type
FROM fivetran_analytics.fct_fivetran_schema_change_history
WHERE change_detected_at >= DATEADD(day, -7, CURRENT_DATE())
ORDER BY change_detected_at DESC;
```

### 4. Identify Recurring Errors
```sql
SELECT 
    error_type,
    COUNT(*) as occurrences,
    COUNT(DISTINCT connection_name) as affected_connectors
FROM fivetran_analytics.fct_fivetran_error_monitoring
WHERE is_recurring_error = TRUE
GROUP BY 1
ORDER BY 2 DESC;
```

---

## 📚 Additional Resources

- **README.md** - Project overview and quick start
- **SETUP_GUIDE.md** - Detailed setup instructions
- **CONTRIBUTING.md** - Development guidelines
- **CHANGELOG.md** - Version history
- **PROJECT_SUMMARY.md** - Comprehensive project documentation

---

**Last Updated**: 2024
**dbt Version**: 1.9.0
**Total Models**: 47 (32 staging + 3 intermediate + 11 marts + 1 daily active rows intermediate)
