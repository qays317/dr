# Disaster Recovery Runbook

## Purpose

This runbook defines the operational procedures for handling failures in the multi-region disaster recovery platform architecture.

It provides step-by-step guidance for:

* Detecting failures
* Executing failover
* Validating system recovery
* Performing post-incident recovery (failback)

This runbook assumes a **warm standby DR model** with manual intervention for database and compute failover.

---

## DR Model Overview

* Primary Region: Active (serving traffic)
* DR Region: Warm standby (ECS scaled to 0)
* CloudFront: Automatic origin failover (ALB + S3)
* RDS: Cross-region read replica (manual promotion required)

---

## Incident Types

### 1. Full Primary Region Failure

* Region unavailable
* ALB unreachable
* ECS tasks down
* RDS primary unavailable

### 2. Partial Application Failure

* ECS tasks unhealthy
* ALB failing health checks
* Application errors (5xx)

### 3. Database Failure

* RDS unavailable
* replication lag spike
* connection failures

---

# 🚨 Incident Response

---

## Incident: Primary Region Failure

### Symptoms

* CloudFront serving traffic from DR origin
* ALB health checks failing in primary region
* Elevated error rates or timeouts
* Application unreachable in primary region

---

## Step 1: Confirm Failure

* Check CloudWatch metrics:

  * ALB HealthyHostCount
  * ECS service health
* Verify CloudFront origin failover is triggered
* Attempt to access application endpoint

---

## Step 2: Promote DR Database

Promote RDS read replica in DR region:

* AWS Console → RDS → Select DR replica
* Click **Promote**
* Wait until status becomes `available`

⚠️ Note:

* This makes the DR database writable
* Replication link to primary is broken after promotion

---

## Step 3: Scale ECS in DR Region

Increase ECS tasks:

* Service → Update desired count
* Example:

  * 0 → 2 tasks

Confirm:

* Tasks start successfully
* Targets register in DR ALB
* Health checks pass

---

## Step 4: Validate Application

* Access application via CloudFront URL
* Verify:

  * Homepage loads
  * WordPress admin works
  * Media files load correctly

---

## Step 5: Monitor System Stability

* Check:

  * Error rate
  * Latency
  * ECS logs (CloudWatch)
* Observe for 10–15 minutes

---

## Expected Outcome

* DR region fully serving traffic
* System stable
* No user-facing errors

---

# ⚠️ Partial Failure Handling

---

## Scenario: ECS / ALB Issues Only

### Symptoms

* ALB health checks failing
* ECS tasks restarting
* CloudFront still hitting primary origin

---

### Actions

* Restart ECS tasks
* Check container logs
* Verify target group health
* Redeploy ECS service if needed

---

## Scenario: Database Issues Only

### Symptoms

* Application reachable but errors displayed
* DB connection failures

---

### Actions

* Check RDS status
* Evaluate replication lag
* Promote DR replica if needed

---

# 🔁 Post-Incident Recovery (Failback)

---

## Step 1: Restore Primary Region

* Recreate or fix:

  * ECS service
  * ALB
  * Networking

---

## Step 2: Rebuild Database Topology

* Create new read replica from DR primary
* Re-establish cross-region replication

---

## Step 3: Gradual Failback

* Shift traffic back to primary
* Scale ECS in primary region
* Reduce DR ECS capacity

---

## Step 4: Validate

* Ensure:

  * replication working
  * application stable
  * no data inconsistency

---

# 📊 RTO / RPO Expectations

| Metric | Expected Value                                  |
| ------ | ----------------------------------------------- |
| RTO    | ~5–15 minutes (manual ECS scale + DB promotion) |
| RPO    | Seconds to minutes (due to async replication)   |

---

# 🧠 Operational Notes

* CloudFront handles failover automatically (no DNS changes)
* Database failover is manual to avoid false positives
* ECS DR scaling is manual or can be automated later
* S3 failover is fully automatic (read)

---

# ⚠️ Important Considerations

* Data loss may occur due to replication lag
* DR ECS must be scaled before serving traffic
* Failover should be confirmed before execution
* Post-failover cleanup is required

---

# 🧪 DR Testing Recommendation

* Perform DR drills periodically
* Simulate region failure
* Validate:

  * failover time
  * system stability
  * recovery process

---

# ✅ Summary

This runbook ensures:

* Controlled and predictable disaster recovery
* Minimal downtime during regional failure
* Clear operational procedures for engineers

The system is designed for **reliability and cost-efficiency**, not full active-active complexity.
