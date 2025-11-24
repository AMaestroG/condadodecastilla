<?php
header('Content-Type: application/json');
require_once 'db_connect.php'; // Establishes $pdo connection

$response = ['success' => false, 'message' => '', 'data' => []];

// Check if $pdo is set and is an instance of PDO
if (!isset($pdo) || !$pdo instanceof PDO) {
    // This case might occur if db_connect.php had an issue but didn't die,
    // or if $pdo was somehow unset.
    $response['message'] = "Database connection is not available. Please check db_connect.php.";
    error_log("get_stats.php: PDO object not available from db_connect.php.", 0);
    http_response_code(500); // Internal Server Error
    echo json_encode($response);
    exit;
}

try {
    // Prepare and execute the SQL statement
    // IMPORTANT: The user must ensure these table and column names match their actual database schema.
    // This example assumes a table named 'visit_stats' with columns 'section_name' and 'visit_count'.
    $sql = "SELECT section_name, SUM(visit_count) as total_visits FROM visit_stats GROUP BY section_name ORDER BY total_visits DESC";
    $stmt = $pdo->query($sql);
    
    // Fetch all results. If no rows are returned, $stats will be an empty array.
    $stats = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    $response['success'] = true;
    $response['data'] = $stats; // Will be an empty array if no stats are found
    
    if (empty($stats)) {
        $response['message'] = "No visit statistics found."; // Optional: a message indicating no data
    }
    
} catch (PDOException $e) {
    // Log the detailed PDO error to the server's error log
    error_log("Database Query Error in get_stats.php: " . $e->getMessage(), 0);
    
    // Set a user-friendly error message for the JSON response
    $response['message'] = "Error fetching statistics. Please check the server logs for more details.";
    // Consider setting an appropriate HTTP status code for client-side handling
    // http_response_code(500); // Internal Server Error
    
} catch (Exception $e) {
    // Catch any other non-PDO exceptions (e.g., issues not directly related to the database query)
    error_log("General Error in get_stats.php: " . $e->getMessage(), 0);
    $response['message'] = "An unexpected error occurred. Please check the server logs for more details.";
    // http_response_code(500); // Internal Server Error
}

// Ensure $pdo is nullified if it's no longer needed, especially if persistent connections were considered.
// $pdo = null; // Usually handled by PHP at script end, but explicit can be good.

echo json_encode($response);
?>
