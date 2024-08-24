1. You can only have 5 Elastic IP in your account
2. When we are doing SSH into our EC2 machines:
    • We can’t use a private IP, because we are not in the same network • We can only use the public IP.
3. If your machine is stopped and then started, the public IP can change
4. 10 Gbps bandwidth with in the zone 
5. Cons: If the AZ fails, all instances fails at the same time
6.   You can create ENI independently and attach them on the fly (move them) on EC2 instances for failover
7. An instance can NOT be hibernated more than 60 days
    Hibernate: • Supported Instance Families – C3, C4, C5, I3, M3, M4, R3, R4,T2,T3, ...
                • Instance RAM Size – must be less than 150 GB.
                • Instance Size – not supported for bare metal instances.
                • AMI – Amazon Linux 2, Linux AMI, Ubuntu, RHEL, CentOS & Windows... • Root Volume – must be EBS, encrypted, not instance store, and large
                • Available for On-Demand, Reser ved and Spot Instances
8. • It’s locked to an Availability Zone (AZ)
    • An EBS Volume in us-east-1a cannot be attached to us-east-1b 
    • To move a volume across, you first need to snapshot it
9. EBS Snapshots Features: 
    • EBS Snapshot Archive: • Move a Snapshot to an ”archive tier” that is 75% cheaper
                            • Takes within 24 to 72 hours for restoring the archive
    • Recycle Bin for EBS Snapshots: • Setup rules to retain deleted snapshots so you can recover them after an accidental deletion
                                      • Specify retention (from 1 day to 1 year)
10. • EBS Volumes are characterized in Size | Throughput | IOPS (I/O Ops Per Sec), • Only gp2/gp3 and io1/io2 Block Express can be used as boot volumes
     - EBS Multi-Attach – io1/io2 family
11. EFS(Elastic File System): • EFS works with EC2 instances in multi-AZ, Highly available, scalable, expensive (3x gp2), pay per use 
12. EBS vs EFS – Elastic Block Storage:   • EBS volumes...
                                              • one instance (except multi-attach io1/io2)
                                              • are locked at the Availability Zone (AZ) level • gp2: IO increases if the disk size increases
                                              • gp3 & io1: can increase IO independently
                                          • To migrate an EBS volume across AZ 
                                              • Take a snapshot
                                              • Restore the snapshot to another AZ
                                              • EBS backups use IO and you shouldn’t run them while your application is handling a lot of traffic
13. Types of load balancer on AWS: 
    • Classic Load Balancer: Suppor ts TCP (Layer 4), HTTP & HTTPS (Layer 7)
    • Application Load Balancer: Application load balancers is Layer 7 (HTTP), Suppor t for HTTP/2 and WebSocket,• ALB are a great fit for micro services & container-based application
                                • The application servers don’t see the IP of the client directly
                                    • The true IP of the client is inserted in the header X-Forwarded-For
                                    • We can also get Port (X-Forwarded-Port) and proto (X-Forwarded-Proto)
                                     No charges for inter AZ data
    • Network Load Balancer (Layer 4): Forward TCP & UDP traffic to your instances,Handle millions of request per seconds, Less latency ~100 ms (vs 400 ms for ALB)
                                      NLB has one static IP per AZ, and supports assigning Elastic IP(helpful for whitelisting specific IP), You pay charges ($) for inter AZ data if enabled
    • Gateway Load Balancer(Layer 3 (Network Layer)): Deploy, scale, and manage a fleet of 3rd party network virtual appliances in AWS, Example: Firewalls, Intrusion Detection and Prevention Systems, Deep Packet Inspection Systems, payload manipulation, ...
    • Some load balancers can be setup as internal (private) or external (public) ELBs
14. Sticky Sessions (Session Affinity): It is possible to implement stickiness so that the same client is always redirected to the same instance behind a load balancer
                                        For both CLB & ALB, the “cookie” used for stickiness has an expiration date you control
