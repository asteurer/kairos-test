IP_ADDR := 192.168.0.183
USER := kairos
OS := ubuntu
BUNDLE := ghcr.io/asteurer/kairos-test-bundle:0.0.1
SSH_CMD := ssh $(USER)@$(IP_ADDR) \
		-o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null

.PHONY: config
config:
	@cat ./server_config/kairos_config.yaml | \
		sed 's/{{ .IPAddress }}/$(IP_ADDR)/' | \
			$(SSH_CMD) "sudo sh -c 'cat > /usr/local/cloud-config/kairos_config.yaml'"
	@$(SSH_CMD) 'sudo reboot'

.PHONY: k3s
k3s:
	@./scripts/get_k3s_config.sh $(USER) $(IP_ADDR) $(OS)

.PHONY: push-bundle
push-bundle:
	@docker login ghcr.io && \
		docker build ./test_bundle -t $(BUNDLE) && \
		docker push $(BUNDLE)

.PHONY: install-bundle
install-bundle: push-bundle
	@$(SSH_CMD) 'sudo kairos-agent install-bundle run://$(BUNDLE)'

.PHONY: ssh
ssh:
	$(SSH_CMD)

