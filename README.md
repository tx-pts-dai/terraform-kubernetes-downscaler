# Terraform Kubernetes Downscaler

Terraform that encapsules and deploy `kube-downscaler` from <https://codeberg.org/hjacobs/kube-downscaler>.

## Usage

The goal of the module is to require the least input parameters possible, so you can deploy it (and let it do nothing, by default) like this.

```hcl
module "kube_downscaler" {
  source = "github.com/tx-pts-dai/terraform-kubernetes-downscaler"
}
```

If you want to enable downscaling of your workloads, we recommend using the Deployment, HPA, ... annotation so that you can control in a very precise way which resource you want to scale down. You can do so by following the official documentation at <https://codeberg.org/hjacobs/kube-downscaler/>

## Explanation and description of interesting use-cases

Kube Downscaler allows you to scale down to 0 your workloads when you don't need them (out of office hours, weekends, etc...)

## Examples

< if the folder `examples/` exists, put here the link to the examples subfolders with their descriptions >

## Contributing

In order to contribute, please install `pre-commit` and run some checks locally, before pushing, according to the next section.

### Pre-Commit

Installation: [install pre-commit](https://pre-commit.com/) and execute `pre-commit install`. This will generate pre-commit hooks according to the config in `.pre-commit-config.yaml`

Before submitting a PR be sure to have used the pre-commit hooks or run: `pre-commit run -a`

The `pre-commit` command will run:

- Terraform fmt
- Terraform validate
- Terraform docs
- Terraform validate with tflint
- check for merge conflicts
- fix end of files

as described in the `.pre-commit-config.yaml` file

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding_v1.kube_downscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_cluster_role_v1.kube_downscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_deployment_v1.kube_downscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1) | resource |
| [kubernetes_namespace_v1.kube_downscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_service_account_v1.kube_downscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_uptime"></a> [default\_uptime](#input\_default\_uptime) | Specifies default uptime for all the resources that don't override it. Documentation at https://codeberg.org/hjacobs/kube-downscaler#uptime-downtime-spec. Default is 'always up'. | `string` | `"Mon-Sun 00:00-24:00 Europe/Berlin"` | no |
| <a name="input_dry_run"></a> [dry\_run](#input\_dry\_run) | Whether to use the `--dry-run` CLI flag to block the downscaler from introducing any change. | `bool` | `false` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | Version of the 'kube-downscaler' image deployed as a controller | `string` | `"23.2.0"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Alfredo Gottardo](https://github.com/AlfGot), [David Beauvererd](https://github.com/Davidoutz), [Davide Cammarata](https://github.com/DCamma), [Demetrio Carrara](https://github.com/sgametrio) and [Roland Bapst](https://github.com/rbapst-tamedia)

## License

Apache 2 Licensed. See [LICENSE](< link to license file >) for full details.
