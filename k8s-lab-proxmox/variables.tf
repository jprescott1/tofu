variable "prox_endpoint" {
  type = string
}

variable "host_name" {
  description = "k8s node host names"
  type = list(string)
  default = ["control-plane", "worker-node1", "worker-node2", "worker-node3"]
}

variable "vm_id" {
  description = "VM ID starting at 100"
  default = 300
}