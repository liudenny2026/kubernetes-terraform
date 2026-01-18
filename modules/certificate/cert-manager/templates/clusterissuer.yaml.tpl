apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${name}
spec:
  acme:
    email: ${email}
    server: ${server}
    privateKeySecretRef:
      name: ${name}-account-key
  solvers:
  %~ for solver in solvers ~%
    - selector:
        %{~ for key, value in lookup(solver, "selector", {}) ~}
        ${key}: ${value}
        %{~ endfor ~}
      http01:
        %{~ if lookup(solver, "http01", {}) != {} ~}
        %{~ if lookup(lookup(solver, "http01", {}), "ingress", {}) != {} ~}
        ingress:
          class: ${lookup(lookup(solver, "http01", {}), "ingress", {}).class}
        %{~ endif ~}
        %{~ if lookup(lookup(solver, "http01", {}), "service", {}) != {} ~}
        service:
          name: ${lookup(lookup(solver, "http01", {}), "service", {}).name}
          port: ${lookup(lookup(solver, "http01", {}), "service", {}).port}
        %{~ endif ~}
        %{~ endif ~}
      %{~ if lookup(solver, "dns01", {}) != {} ~}
      dns01:
        %{~ if lookup(lookup(solver, "dns01", {}), "route53", {}) != {} ~}
        route53:
          region: ${lookup(lookup(solver, "dns01", {}), "route53", {}).region}
          hostedZoneID: ${lookup(lookup(solver, "dns01", {}), "route53", {}).hostedZoneID}
          accessKeyID: ${lookup(lookup(solver, "dns01", {}), "route53", {}).accessKeyID}
          secretAccessKeySecretRef:
            name: ${lookup(lookup(solver, "dns01", {}), "route53", {}).secretAccessKeySecretRef.name}
            key: ${lookup(lookup(solver, "dns01", {}), "route53", {}).secretAccessKeySecretRef.key}
        %{~ endif ~}
        %{~ if lookup(lookup(solver, "dns01", {}), "cloudflare", {}) != {} ~}
        cloudflare:
          email: ${lookup(lookup(solver, "dns01", {}), "cloudflare", {}).email}
          apiTokenSecretRef:
            name: ${lookup(lookup(solver, "dns01", {}), "cloudflare", {}).apiTokenSecretRef.name}
            key: ${lookup(lookup(solver, "dns01", {}), "cloudflare", {}).apiTokenSecretRef.key}
        %{~ endif ~}
      %{~ endif ~}
  %~ endfor ~}
