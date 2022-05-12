FROM amazon/aws-cli:latest
RUN curl -sL -o /usr/bin/jq https://stedolan.github.io/jq/download/linux64/jq
RUN chmod +x /usr/bin/jq
RUN curl -sL -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    curl -sL -o /usr/bin/aws-iam-authenticator $(curl -s https://api.github.com/repos/kubernetes-sigs/aws-iam-authenticator/releases/latest | jq -r ' .assets[] | select(.name | contains("linux_amd64")    )' | jq -r '.browser_download_url')  && \
    chmod +x /usr/bin/aws-iam-authenticator && \
    chmod +x /usr/bin/kubectl

RUN kubectl version --client
# Add Argo Rollouts Plugin
RUN curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
RUN chmod +x ./kubectl-argo-rollouts-linux-amd64
RUN mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts
RUN kubectl argo rollouts version
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
