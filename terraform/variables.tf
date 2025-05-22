variable "region" {
  type = map(string)
  default = {
    aws          = "ap-southeast-1"
    tencentcloud = "ap-singapore"
  }
}