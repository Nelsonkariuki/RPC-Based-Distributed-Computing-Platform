RPC-based Distributed Computing Platform
=========================================

Team Member Contributions:
- Student 1 (25%): RPC interface design and server implementation
- Student 2 (25%): Client console and job scheduling
- Student 3 (25%): Load monitoring and threshold management
- Student 4 (25%): Documentation and testing

Design Details:
--------------
This project implements a distributed computing platform using Sun RPC.
The system consists of:

1. Client (replicator):
   - Interactive console for user commands
   - Job distribution across multiple servers
   - Load monitoring and threshold-based server control
   - Job rescheduling for failed/killed jobs
   - Support for up to 5 servers

2. Servers:
   - RPC server processes running on each machine
   - Fork child processes to execute hyper_link simulations
   - Output redirection to replicate_out directory
   - CPU load monitoring via /proc/loadavg
   - Signal handling for job control

3. RPC Interface (replicate.x):
   - HYPER_LINK: Execute simulation jobs
   - SQUARE: Test function
   - GET_LOAD: Retrieve CPU load
   - GET_STATUS: Check server status
   - STOP_SERVER: Deactivate server
   - START_SERVER: Reactivate server
   - EXECUTE_COMMAND: Generic command execution

Installation Instructions:
-------------------------
1. Install required packages:
   $ sudo apt update
   $ sudo apt install -y build-essential libtirpc-dev rpcbind

2. Start RPC services:
   $ sudo service rpcbind start

Compilation Instructions:
------------------------
1. Simply type 'make' to compile:
   $ make

2. This will generate:
   - replicate_client: Client executable
   - replicate_server: Server executable

Execution Sequence:
------------------
1. On each server machine, start the RPC server:
   $ ./replicate_server

2. On the client machine, start the client console:
   $ ./replicate_client

3. At the client console, you can use the following commands:

   Commands:
   - hyper_link start end step a1 a2 a3 a4 a5 a6 : Start simulation jobs
   - square <value> : Test square operation
   - status : Show server status
   - load <server_index> : Show CPU load for a server
   - stop <server_index> : Stop a server
   - start <server_index> : Start a server
   - set_threshold high <value> : Set high CPU threshold
   - set_threshold low <value> : Set low CPU threshold
   - jobs : Show job status
   - exit : Exit console

Sample Test Run:
---------------
$ ./replicate_client

=== RPC-based Distributed Computing Platform ===
Type 'help' for available commands

replicate> status
Server Status:
Index Hostname   Status  Load  Job
0     localhost  ACTIVE  0.12  -1

replicate> square 5
Square of 25 = 25 (on server localhost)

replicate> hyper_link 1 5 1 1000000 999 1 2 2 100
Creating 5 jobs from 1 to 5 with step 1
Job 1 assigned to server localhost (PID: 12345)
Job 2 assigned to server localhost (PID: 12346)
...

replicate> jobs
Job Status:
ID      Server  Status
1       0       RUNNING
2       0       RUNNING
...

replicate> load 0
Server localhost load: 0.45

replicate> stop 0
Server localhost stopped
Killed job 1 on server localhost

replicate> start 0
Server localhost started

replicate> exit

Troubleshooting:
---------------
1. If you get "Cannot register service" error:
   $ sudo rpcinfo -p
   Make sure rpcbind is running

2. If compilation fails with RPC headers not found:
   $ sudo apt install libtirpc-dev

3. If servers don't connect:
   Check firewall settings and ensure all machines can ping each other

Known Issues/Limitations:
------------------------
1. The hyper_link binary must be present in the same directory as the server
2. RPC portmapper must be running on all servers
3. Maximum 5 servers supported as per requirements
4. Jobs are tracked in memory only (no persistence across client restarts)

All core requirements have been implemented successfully.