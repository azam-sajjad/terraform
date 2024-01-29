# Production-grade Infrastructure Checklist

## Part 1
1) Install    - Ansible, Chef, Puppet
2) Configure  - Ansible, Chef, Puppet
3) Provision  - Terraform, Cloudformation
4) Deployment - Scripts, Orchestration tools (EKS, K8S, Nomad) 

## Part 2
1) Security     - ACM, EBS Volumes, Cognito, Vault, Server Hardening
2) Monitoring   - Cloudwatch, DataDog, New Relic, Honeycomb
3) Logs         - Cloudwatch Logs, ELK, Sumo Logic, Papertrail
4) Backup/Restore - RDS, Elasticache, ec2-snapper, Lambda, take regular backups, replicate to another region/account

## Part 3
1) Networking       - VPCs, Subnets, IPs, Service Discories, Service MEsh, Firewalls, DNS, SSH access, VPN Access - EIPs, ENIs, VPCs, NACLs, SGs, Route 53, OpenVPN
2) High Availability - Multi AZ, Multi-region, Replication, ASGs, ELBs
3) Scalability       - ASGs, Replication, Sharding, Caching, Horizontally Scale, Vertically Scale
4) Performance       - Dynatrace, Valgrind, VisualVM, ab, Jmeter - Optimize CPU Memory Usage, Network, Query Tuning, Benchmarking, Load Testing, Profiling

## Part 4
1) Cost Optimization - spot, reserved instances - nuke unused resources
2) Documentation     - READMEs, Wikis, Slack - Create playbooks to respond to incidents
3) Tests             - Terratest - write automated tests for your infrastructure after every commit and nightly.