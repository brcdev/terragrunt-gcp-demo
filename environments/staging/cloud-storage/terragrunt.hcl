include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "${path_relative_from_include("root")}//modules/cloud-storage"
}
