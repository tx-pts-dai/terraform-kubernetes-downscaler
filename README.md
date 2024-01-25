# Terraform Kubernetes Downscaler

Terraform module that encapsules and deploy the `kube-downscaler` controller from <https://codeberg.org/hjacobs/kube-downscaler>.

## Usage

The goal of the module is to require the least input parameters possible, so you can deploy the `kube-downscaler` controller (and let it do nothing, by default) with the following Terraform code.

```hcl
module "kube_downscaler" {
  source  = "tx-pts-dai/downscaler/kubernetes"
  version = "~> 0.1.0"
}
```

If you want to enable downscaling of your workloads, we recommend using the annotation on your resource (Deployment, HPA, ...) so that you can control in a very precise way which resource you want to scale down. You can do so by following the official documentation at <https://codeberg.org/hjacobs/kube-downscaler/>

## Explanation and description of interesting use-cases

Kube Downscaler allows you to scale down to 0 your workloads when you don't need them (out of office hours, weekends, etc...).

Let's say that we want to downscale to 0 the `sample` Deployment at 8pm and bring it back to original replicas at 5am every day. We could add the following annotation on the Deployment and the `kube-downscaler` will do the trick.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: sample
    annotations:
        downscaler/downscale-period: Mon-Sun 20:00-20:01 Europe/Zurich
        downscaler/upscale-period: Mon-Sun 05:00-05:01 Europe/Zurich
```

## F.A.Q

1. _My deployment has been shut down and won't scale up until tomorrow, what options do I have to bring it back up?_

    Re-triggering the pipeline for deploying it again would make it available until the next scale-down window.

## Examples

1. [Shutdown at night, every day](./examples/shutdown-at-night.tf)

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
| [kubernetes_cluster_role_binding_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_cluster_role_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_v1) | resource |
| [kubernetes_deployment_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_service_account_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dry_run"></a> [dry\_run](#input\_dry\_run) | Whether to use the `--dry-run` CLI flag to block the downscaler from introducing any change. | `bool` | `false` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | Version of the 'kube-downscaler' image deployed as a controller | `string` | `"23.2.0"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | Node selector specifics for the Kubernetes deployment | `map(string)` | `{}` | no |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | List of tolerations for the Kubernetes deployment | <pre>list(object({<br>    effect   = optional(string)<br>    key      = optional(string)<br>    operator = optional(string)<br>    value    = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module is maintained by [Alfredo Gottardo](https://github.com/AlfGot), [David Beauvererd](https://github.com/Davidoutz), [Davide Cammarata](https://github.com/DCamma), [Demetrio Carrara](https://github.com/sgametrio) and [Roland Bapst](https://github.com/rbapst-tamedia)

## License

Apache 2 Licensed. See [LICENSE](< link to license file >) for full details.
