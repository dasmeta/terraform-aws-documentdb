module "cw_alerts" {
  count = var.alarms.enabled ? 1 : 0

  source  = "dasmeta/monitoring/aws//modules/alerts"
  version = "1.3.5"

  sns_topic = var.alarms.sns_topic

  alerts = [
    {
      name   = "DocumentDB ${var.name} CPUUtilization"
      source = "AWS/RDS/CPUUtilization"
      filters = {
        DBClusterIdentifier = var.name
      }
      statistic = try(var.alarms.custom_values.cpu.statistic, "avg")
      threshold = try(var.alarms.custom_values.cpu.threshold, "90") # percent
      period    = try(var.alarms.custom_values.cpu.period, "300")
    },
    {
      name   = "DocumentDB ${var.name} EBSIOBalance%"
      source = "AWS/DocDB/EBSIOBalance%"
      filters = {
        DBClusterIdentifier = var.name
      }
      period    = try(var.alarms.custom_values.ebs.IObalance.period, "1800")
      threshold = try(var.alarms.custom_values.ebs.IObalance.threshold, "10") # percent
      equation  = try(var.alarms.custom_values.ebs.IObalance.equation, "lt")
      statistic = try(var.alarms.custom_values.ebs.IObalance.statistic, "avg")
    },
    {
      name   = "DocumentDB ${var.name} FreeableMemory"
      source = "AWS/DocDB/FreeableMemory"
      filters = {
        DBClusterIdentifier = var.name
      }
      period    = try(var.alarms.custom_values.memory.period, "1800")
      threshold = try(var.alarms.custom_values.memory.threshold,2)
      equation  = try(var.alarms.custom_values.memory.equation, "lt")
      statistic = try(var.alarms.custom_values.memory.statistic, "avg")
    },
    {
      name   = "DocumentDB ${var.name} ReadLatency"
      source = "AWS/DocDB/ReadLatency"
      filters = {
        DBClusterIdentifier = var.name
      }
      period    = try(var.alarms.custom_values.network.read.period, "60")
      threshold = try(var.alarms.custom_values.network.read.threshold, "1")
      equation  = try(var.alarms.custom_values.network.read.equation, "gte")
      statistic = try(var.alarms.custom_values.network.read.statistic, "avg")
    },
    {
      name   = "DocumentDB ${var.name} WriteLatency"
      source = "AWS/DocDB/WriteLatency"
      filters = {
        DBClusterIdentifier = var.name
      }
      period    = try(var.alarms.custom_values.network.write.period, "60")
      threshold = try(var.alarms.custom_values.network.write.threshold, "1")
      equation  = try(var.alarms.custom_values.network.write.equation, "gte")
      statistic = try(var.alarms.custom_values.network.write.statistic, "avg")
    },
    {
      name   = "DocumentDB ${var.name} DatabaseConnections"
      source = "AWS/DocDB/DatabaseConnections"
      filters = {
        DBClusterIdentifier = var.name
      }
      # considering https://aws.amazon.com/premiumsupport/knowledge-center/rds-mysql-max-connections/; expecting that only 80% of memory is used for PostgreSQL; warn at 80% connection usage
      period    = try(var.alarms.custom_values.connections.period, "60")
      threshold = try(var.alarms.custom_values.connections.threshold, 100)
      statistic = try(var.alarms.custom_values.connections.statistic, "avg")
    },
    {
      name   = "DocumentDB ${var.name} FreeStorageSpace"
      source = "AWS/DocDB/FreeStorageSpace"
      filters = {
        DBClusterIdentifier = var.name
      }
      period    = try(var.alarms.custom_values.disk.period, "300")
      threshold = try(var.alarms.custom_values.disk.threshold, 3)
      equation  = try(var.alarms.custom_values.disk.equation, "lt")
      statistic = try(var.alarms.custom_values.disk.statistic, "avg")
    },
  ]

  depends_on = [
    module.documentdb_cluster
  ]
}
