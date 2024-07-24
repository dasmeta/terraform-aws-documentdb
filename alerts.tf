module "alerts" {
  count = var.alarms.enabled ? 1 : 0

  source = "./modules/alarms/"
  name   = var.name
  alarms = var.alarms

  depends_on = [
    module.documentdb_cluster
  ]

}
