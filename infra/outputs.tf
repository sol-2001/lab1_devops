output "kubernetes_cluster_id" {
  value = yandex_kubernetes_cluster.todo_k8s_cluster.id
}

output "kubernetes_cluster_endpoint" {
  value = yandex_kubernetes_cluster.todo_k8s_cluster.master[0].external_v4_endpoint
}

output "container_registry_id" {
  value = yandex_container_registry.todo_registry.id
}

output "container_registry_name" {
  value = yandex_container_registry.todo_registry.name
}

output "node_group_id" {
  value = yandex_kubernetes_node_group.todo_k8s_node_group.id
}

output "vm_nat_ip" {
  value = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

