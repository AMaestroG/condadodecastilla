<?php
// Database configuration
$db_host = "YOUR_DB_HOST";         // Replace with your database host
$db_name = "YOUR_DB_NAME";         // Replace with your database name
$db_user = "YOUR_DB_USER";         // Replace with your database username
$db_pass = "YOUR_DB_PASSWORD";     // Replace with your database password
$db_port = "YOUR_DB_PORT";         // Replace with your database port (e.g., 2050 or your specific Progress port)
// $db_other_params = "YOUR_OTHER_PARAMS"; // Replace with any other connection parameters (e.g., ServiceName=your_service;EncryptionMethod=1;ValidateServerCertificate=0)

// PDO options (can be customized)
$db_options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Recommended for error handling
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,   // Fetches associative arrays
    PDO::ATTR_EMULATE_PREPARES   => false,              // Use native prepared statements
    // PDO::ATTR_PERSISTENT => true, // Consider if persistent connections are needed
];

// Construct the DSN (Data Source Name) for Progress OpenEdge ODBC
// Ensure the "Progress OpenEdge Wire Protocol" driver (or similar, e.g., "DataDirect OpenEdge Wire Protocol") is installed on the server where PHP is running.
// The driver name might vary based on the specific ODBC driver version installed.
// Check your ODBC Administrator for the exact driver name.
$dsn = "odbc:DRIVER={Progress OpenEdge Wire Protocol};HOST=$db_host;PORT=$db_port;DB=$db_name;";
// Optionally, include UID and PWD in the DSN, though it's often better to pass them to the PDO constructor.
// $dsn .= "UID=$db_user;PWD=$db_pass;";
// If you have other parameters, append them like so:
// if (!empty($db_other_params)) {
//     $dsn .= $db_other_params;
// }


try {
    // Establish the database connection
    // If UID and PWD are not in the DSN, pass them as arguments to the PDO constructor.
    $pdo = new PDO($dsn, $db_user, $db_pass, $db_options);

    // You can uncomment the following line for a quick connection test (remove in production)
    // echo "Connected to Progress database successfully!";

} catch (PDOException $e) {
    // Handle connection errors
    // In a production environment, log this error to a file or a logging system.
    // Avoid displaying detailed error messages to the end-user.
    error_log("Database Connection Error: " . $e->getMessage(), 0);
    
    // Display a generic error message to the user
    // You might want to redirect to an error page or display a more user-friendly message.
    die("ERROR: Could not connect to the database. Please check the configuration and ensure the Progress ODBC driver is installed and configured correctly. Detailed error: " . $e->getMessage());
}

// The $pdo object is now ready to be used for database operations.
// For example:
// $stmt = $pdo->query("SELECT * FROM your_table_name LIMIT 10");
// while ($row = $stmt->fetch()) {
//     print_r($row);
// }

// It's good practice to close the connection when it's no longer needed,
// though PHP usually handles this automatically at the end of the script.
// To explicitly close: $pdo = null;
?>
