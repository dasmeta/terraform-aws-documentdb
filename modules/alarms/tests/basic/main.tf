module "alerts" {
  source = "../../"
  name   = "documentdb-cluster"
  alarms = {
    sns_topic = "test-topic"
  }

}
