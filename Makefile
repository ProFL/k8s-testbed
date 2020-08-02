SHELL=bash

.PHONY: apply-nginx-igcontroller
apply-nginx-igcontroller:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/cloud/deploy.yaml

.PHONY: delete-nginx-igcontroller
delete-nginx-igcontroller:
	@kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/cloud/deploy.yaml

.PHONY: apply-hpa
apply-hpa:
	@kubectl apply -k monitoring
	@kubectl apply -k kube-znn
	@kubectl apply -f nginxc-ingress
	@( cd hpa \
	   	&& touch metrics-ca.key metrics-ca.crt metrics-ca-config.json \
	   	&& make certs )
	@kubectl apply -k hpa

.PHONY: delete-hpa
delete-hpa:
	@kubectl delete -k hpa
	@kubectl delete -f nginxc-ingress
	@kubectl delete -k kube-znn
	@kubectl delete -k monitoring

.PHONY: apply-kubow
apply-kubow:
	@kubectl apply -k monitoring
	@kubectl apply -k kube-znn
	@kubectl apply -f nginxc-ingress
	@kubectl apply -k kubow/overlay/kube-znn

.PHONY: delete-kubow
delete-kubow:
	@kubectl delete -k kubow/overlay/kube-znn
	@kubectl delete -f nginxc-ingress
	@kubectl delete -k kube-znn
	@kubectl delete -k monitoring