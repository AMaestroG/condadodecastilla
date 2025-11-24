# PHP Visit Statistics Dashboard

## Overview

This dashboard displays website visit statistics per section using a bar chart. It fetches data from a Progress database via PHP and PDO_ODBC, and renders the chart in the browser using Chart.js.

The system consists of three main PHP files:
-   `db_connect.php`: Handles the database connection. **This file requires manual configuration.**
-   `get_stats.php`: Fetches statistics from the database and outputs them in JSON format.
-   `index.php`: Displays the dashboard, including the chart.

## Prerequisites

Before deploying this dashboard, ensure the following requirements are met:

1.  **PHP Environment**: A web server with PHP installed.
    *   The **PDO ODBC extension** (`php_pdo_odbc.dll` or `pdo_odbc.so`) must be enabled in your `php.ini` file.
2.  **Progress ODBC Driver**: The appropriate Progress OpenEdge ODBC driver must be installed and correctly configured on the server where PHP is running. This includes setting up an ODBC Data Source Name (DSN) if you choose to connect via a system DSN, or ensuring the driver is available for DSN-less connections.
3.  **Database Access**: Network access from the web server to the Progress database server.
4.  **Database Credentials**: Valid username and password for accessing the Progress database.
5.  **Client Internet Access**: The client's web browser needs internet access to load the Chart.js library from the CDN.

## Configuration

The primary configuration file is `dashboard/db_connect.php`. You **must** update this file with your actual Progress database credentials and connection details.

Open `dashboard/db_connect.php` and modify the following placeholder variables:

*   `$db_host`: Your Progress database server hostname or IP address.
    ```php
    $db_host = "YOUR_DB_HOST"; // e.g., "localhost" or "192.168.1.100"
    ```
*   `$db_name`: The name of your Progress database.
    ```php
    $db_name = "YOUR_DB_NAME"; // e.g., "sportsdb"
    ```
*   `$db_user`: The username for database access.
    ```php
    $db_user = "YOUR_DB_USER";
    ```
*   `$db_pass`: The password for the database user.
    ```php
    $db_pass = "YOUR_DB_PASSWORD";
    ```
*   `$db_port`: The port number your Progress database is listening on. This is often specific to your Progress setup (e.g., 2050, 5555).
    ```php
    $db_port = "YOUR_DB_PORT"; // e.g., 2050
    ```
*   `$db_other_params` (Optional): If your connection requires other specific parameters (e.g., ServiceName, EncryptionMethod), you can uncomment and set this variable in `db_connect.php`.
    ```php
    // $db_other_params = "ServiceName=your_service;EncryptionMethod=1;ValidateServerCertificate=0";
    ```

### DSN String Configuration

The script uses a DSN-less connection string by default. The DSN string is constructed as follows:

```php
$dsn = "odbc:DRIVER={Progress OpenEdge Wire Protocol};HOST=$db_host;PORT=$db_port;DB=$db_name;";
```

**Important**:
*   The `DRIVER` name `{Progress OpenEdge Wire Protocol}` might need to be adjusted based on the exact name of the Progress ODBC driver installed on your system. Check your server's ODBC Data Source Administrator for the correct driver name (e.g., it could be `{DataDirect OpenEdge Wire Protocol}` or similar).
*   If you prefer to use a pre-configured System DSN, you can change the `$dsn` variable to something like:
    ```php
    $dsn = "odbc:YOUR_SYSTEM_DSN_NAME";
    // Ensure $db_user and $db_pass are then passed to the PDO constructor,
    // or configure them in your system DSN.
    ```
*   Consult your Progress ODBC driver documentation if you encounter issues with the DSN or connection string.

## Database Table Structure

The `dashboard/get_stats.php` script assumes a specific table structure for fetching visit statistics.

*   **Assumed Table Name**: `visit_stats`
*   **Assumed Columns**:
    *   `section_name` (VARCHAR or similar text type): Stores the name or identifier of the website section (e.g., 'Homepage', 'Products', 'Contact Us').
    *   `visit_count` (INTEGER or similar numeric type): Stores the number of visits recorded for that section for a specific entry or period. The script aggregates these counts.

If your database table or column names are different, you **must** update the SQL query within `dashboard/get_stats.php`.

The current query is:
```sql
SELECT section_name, SUM(visit_count) as total_visits 
FROM visit_stats 
GROUP BY section_name 
ORDER BY total_visits DESC;
```
Modify `visit_stats`, `section_name`, or `visit_count` in this query to match your actual schema.

## Running the Dashboard

1.  **Configure**: Update `dashboard/db_connect.php` with your database credentials and DSN details as described above.
2.  **Modify Query (if needed)**: Adjust the SQL query in `dashboard/get_stats.php` if your table/column names differ.
3.  **Deploy**: Upload the entire `dashboard` directory (containing `index.php`, `get_stats.php`, `db_connect.php`, and this `README.md`) to your PHP-enabled web server.
4.  **Access**: Open your web browser and navigate to the `index.php` file. For example:
    `http://your-server.com/path-to-dashboard/dashboard/index.php`

The dashboard should display a bar chart of visit statistics.

## Troubleshooting

If you encounter issues, here are some common troubleshooting steps:

1.  **Check Web Server Error Logs**: PHP errors, database connection failures, and other issues are often logged by your web server (e.g., Apache error log, Nginx error log, PHP error log). These logs are invaluable for diagnosing problems.
2.  **Verify `db_connect.php`**:
    *   Double-check all database credentials, hostname, port, and database name.
    *   Ensure the ODBC driver name in the DSN string is correct for your system.
3.  **Test `get_stats.php` Directly**:
    *   Navigate to `http://your-server.com/path-to-dashboard/dashboard/get_stats.php` in your browser.
    *   This should output a JSON string.
    *   If it's empty, shows a PHP error, or a JSON error message, it indicates a problem with either the database connection (`db_connect.php`) or the SQL query in `get_stats.php`.
    *   The error message (if any) in the JSON output (e.g., `{"success":false,"message":"Error details..."}`) can provide clues.
4.  **ODBC Driver Configuration**:
    *   Confirm the Progress ODBC driver is correctly installed and configured in your server's ODBC settings.
    *   Ensure the PHP process has the necessary permissions to use the ODBC driver.
5.  **Database Table/Column Names**:
    *   Verify that the table name (`visit_stats`) and column names (`section_name`, `visit_count`) used in the `get_stats.php` query match your actual database schema.
6.  **Browser Console**: Open your browser's developer tools (usually by pressing F12) and check the "Console" tab for any JavaScript errors when viewing `index.php`. This can help diagnose issues with Chart.js or the data fetching process.
7.  **PHP PDO ODBC Extension**: Ensure `extension=pdo_odbc` (or similar for your OS) is uncommented in your `php.ini` file and that the PHP module is loaded. You can verify this using `phpinfo();`.
