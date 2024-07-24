module "documentdb_cluster" {
  source = "../../"

  master_username                 = "user1"
  master_password                 = "user1pass"

  alarms = {
      sns_topic = "test-topic"
  }
}
