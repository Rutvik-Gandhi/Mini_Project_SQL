# Mini_Project_SQL

## Script Overview

The script creates a database named `SWC_TEAM07` and several tables to manage supplier, part, bundle, address, purchaser, and order history information. It also creates views to display purchase details and bundle costs.

## Contents of the Script

### Database Creation and Setup
- Creates the `SWC_TEAM07` database.
- Creates tables: Supplier, Part, Bundle, BundlePartLinkingTable, AddressTable, Purchaser, and OrderHistory.
- Creates indexes for the purchaser's phone and a unique index for the purchaser's email.

### Data Insertion
- Inserts data into the Supplier, Part, Bundle, BundlePartLinkingTable, AddressTable, Purchaser, and OrderHistory tables.

### Views Creation
- Creates views: `VW_PurchaseDetailPlusExtendedAmount` and `VW_BundleCost`.
- `VW_PurchaseDetailPlusExtendedAmount` displays purchase details with extended amounts.
- `VW_BundleCost` displays desktop bundles along with their total costs.

### Questions Execution
- Executes SQL queries for each question, including checking database existence, creating tables, creating views, and inserting data.

## How to Use the Script

1. Open your preferred SQL client or environment.

2. Load the script `ex4_RG.sql` into your SQL client.

3. Execute the script to create the `SWC_TEAM07` database, tables, views, and insert data.

4. Use the created tables and views to manage supplier, part, bundle, purchaser, and order history information.

## Additional Notes

- Ensure that your SQL environment has sufficient privileges to create databases, tables, and views.

## License

This script is provided under the MIT License. See the [LICENSE](LICENSE) file for details.
