# File Permissions on Mac

---

File permissions define who and what can read, write to, and execute a given
file on your Mac. Maintaining well-defined file permissions will both improve
your overall system security and ensure that automated processes can execute
within a given workflow when called.

---

## How does file ownership work on Mac? ----------------------------------------

Files on macOS have permissions defined for three subsets of system users.
There are permissions granted to the single user who owns the file, the
group of users the owner is associated with, and everyone else.

User: The owner of a given file – the file’s creator by default.
Group: A group of users who will share common permissions – “staff” is the
default group on macOS.
Everyone Else (Others): All other users and groups in the system.

---

## What are the different permission levels on Mac files? ----------------------

| Description       | Octal Value | Permissions Set |
| :---------------- | :---------- | :-------------- |
| No access         |      0      |       ---       |
| Execute           |      1      |       --x       |
| Write             |      2      |       -w-       |
| Write, exec       |      3      |       -wx       |
| Read              |      4      |       r--       |
| Read, exec        |      5      |       r-x       |
| Read, write       |      6      |       rw-       |
| Read, write, exec |      7      |       rwx       |

The values r, w, and x are pretty straightforward. They represent read, write
and execute permissions respectively. The octal values are less straightforward
but useful for setting distinct permissions for all user types in a single
command, which we’ll look at below.

The octal values represent each possible combination of permissions as a
single integer ranging from 0 to 7. Combinations of permissions have an octal
value that is equal to the sum of the octal values of each individual
permission being granted.

For example, write and execute (with an octal value of 3) is the sum of the
values that represent execute (1) and write (2). As another example, read and
write (with an octal value of 6) is the sum of read (4) and write (2)
privileges.

---

## How to Change File Permissions on Mac with Chmod ----------------------------

On Mac, you can use the utility chmod to change the permissions on a given
file. For example, to make a file executable for all users, you can run either
of the following commands:

- 1. chmod ugo+x example.sh

Above, we have identified each user type we want to set the execute permission
for (every type in this case), used the + symbol to indicate the adding of
new privileges, and passed x to indicate the execute permission. We could also
use the - symbol to indicate the removal of privileges. Furthermore, because
we are setting the same permission to all user types, we can shorten the
above to the more commonly used chmod +x example.sh.

- 2. chmod 111 example.sh

Here, we are using the octal value of the execute permission (1) to explicitly
set the permission levels for each user type in the following order – user,
group, everyone else.

---

## Setting distinct permission levels on a file with a single command ----------

Because we always set the permissions of the user, group, and everyone else in
that order, we can use the octal values from the table above to set distinct
permissions for a given file’s owner, group, and everyone else in a single
command, like so:

chmod 610 example.sh
Above, we gave the user a 6 (read and write permissions), the group a 1
(execute permission), and everyone else 0 (no access).

---

## TL;DR -----------------------------------------------------------------------

File permissions on Mac determine which users can read, write to, and execute
a given file. This is important because when managed well, file permissions
can enhance system security, but when done badly it can have the inverse
effect. Above, we outlined the various types of permissions, the various user
types to which permissions can be assigned, and how to go about setting these
permission types.