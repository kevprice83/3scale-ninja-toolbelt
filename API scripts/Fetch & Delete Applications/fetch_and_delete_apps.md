# What
This shell script is useful for bulk deleting applications under a single account. If those applications are created maliciously or intentionally but with a total number greater than ~100 it can sometimes cause a timeout to delete the account directly via the API or the admin portal. This script filters a paginated API resource by `account_id` and removes all the applications belonging to it.

# How
From a UNIX shell the following command will print the usage:
```bash
./fetch_and_delete_applications.sh
"Usage: <https://ADMIN_PORTAL_URL> <ACCOUNT_ID> <ACCESS_TOKEN>"
```

**Example:**

```bash
./fetch_and_delete_applications.sh https://tenant-admin.lvh.me 1234567890 myaccesstoken12345
```