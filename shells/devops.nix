{
  description = "Full-featured DevOps Senior Engineer development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Kubernetes config switcher script
        kubeSwitch = pkgs.writeShellScriptBin "kube-switch" ''
          #!/usr/bin/env bash
          case "$1" in
            work)
              export KUBECONFIG="$HOME/.kube/config-work"
              echo "Switched to WORK Kubernetes context"
              ${pkgs.kubectl}/bin/kubectl config current-context
              ;;
            personal)
              export KUBECONFIG="$HOME/.kube/config-personal"
              echo "Switched to PERSONAL Kubernetes context"
              ${pkgs.kubectl}/bin/kubectl config current-context
              ;;
            *)
              echo "Usage: kube-switch [work|personal]"
              echo "Current KUBECONFIG: $KUBECONFIG"
              ;;
          esac
        '';

        # Multi-cluster kubectl wrapper
        kubectlWrapper = pkgs.writeShellScriptBin "k" ''
          #!/usr/bin/env bash
          if [ -z "$KUBECONFIG" ]; then
            export KUBECONFIG="$HOME/.kube/config"
          fi
          ${pkgs.kubectl}/bin/kubectl "$@"
        '';

        # Terraform workspace switcher
        tfSwitch = pkgs.writeShellScriptBin "tf-switch" ''
          #!/usr/bin/env bash
          case "$1" in
            work)
              export TF_WORKSPACE="work"
              export AWS_PROFILE="work"
              echo "Switched to WORK Terraform workspace and AWS profile"
              ;;
            personal)
              export TF_WORKSPACE="personal"
              export AWS_PROFILE="personal"
              echo "Switched to PERSONAL Terraform workspace and AWS profile"
              ;;
            *)
              echo "Usage: tf-switch [work|personal]"
              echo "Current TF_WORKSPACE: $TF_WORKSPACE"
              echo "Current AWS_PROFILE: $AWS_PROFILE"
              ;;
          esac
        '';

        # Docker context switcher
        dockerSwitch = pkgs.writeShellScriptBin "docker-switch" ''
          #!/usr/bin/env bash
          case "$1" in
            work)
              ${pkgs.docker}/bin/docker context use work
              echo "Switched to WORK Docker context"
              ;;
            personal)
              ${pkgs.docker}/bin/docker context use personal
              echo "Switched to PERSONAL Docker context"
              ;;
            *)
              echo "Usage: docker-switch [work|personal]"
              ${pkgs.docker}/bin/docker context ls
              ;;
          esac
        '';

      in
      {
        devShells.default = pkgs.mkShell {
          name = "devops-senior-env";

          buildInputs = with pkgs; [
            # === Core DevOps Tools ===
            kubectl
            kubernetes-helm
            helmfile
            kustomize
            k9s # Kubernetes TUI
            kubectx # Context switcher
            kubens # Namespace switcher
            stern # Multi-pod log tailing
            kubeseal # Sealed secrets

            # === Terraform & IaC ===
            terraform
            terragrunt
            terraform-docs
            tflint
            terrascan
            infracost # Cost estimation

            # === Cloud CLI Tools ===
            awscli2
            google-cloud-sdk
            azure-cli

            # === Container Tools ===
            docker
            docker-compose
            podman
            skopeo # Container image operations
            dive # Docker image analyzer
            trivy # Security scanner

            # === CI/CD ===
            gitlab-runner
            argocd
            flux
            tektoncd-cli

            # === Configuration Management ===
            ansible
            ansible-lint

            # === Monitoring & Observability ===
            prometheus
            grafana
            promtool

            # === Service Mesh ===
            istioctl
            linkerd

            # === Networking ===
            curl
            wget
            jq
            yq-go
            httpie
            grpcurl
            nmap
            tcpdump
            wireshark
            mtr

            # === Security & Secrets ===
            sops
            age
            vault
            gnupg

            # === Git & Version Control ===
            git
            gh # GitHub CLI
            glab # GitLab CLI
            git-crypt
            pre-commit

            # === Development ===
            go
            python311
            python311Packages.pip
            nodejs_20
            rustc
            cargo

            # === Databases ===
            postgresql
            mysql80
            redis
            mongodb-tools

            # === Scripting & CLI ===
            bash
            zsh
            fish
            tmux
            starship # Prompt
            fzf # Fuzzy finder
            ripgrep # Better grep
            fd # Better find
            bat # Better cat
            eza # Better ls
            zoxide # Smart cd
            direnv # Environment switcher

            # === Text Editors ===
            neovim
            vim

            # === Documentation ===
            mdbook

            # === Performance & Debugging ===
            htop
            btop
            iotop
            strace
            lsof

            # === Custom Scripts ===
            kubeSwitch
            kubectlWrapper
            tfSwitch
            dockerSwitch
          ];

          shellHook = ''
            # === Environment Setup ===
            export DEVOPS_ENV="senior-devops-shell"

            # === Kubernetes Configuration ===
            # Default to personal config if not set
            if [ -z "$KUBECONFIG" ]; then
              export KUBECONFIG="$HOME/.kube/config"
            fi

            # Create kubeconfig directories if they don't exist
            mkdir -p $HOME/.kube

            # === Terraform Configuration ===
            export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
            mkdir -p $TF_PLUGIN_CACHE_DIR

            # === Docker Configuration ===
            export DOCKER_CONFIG="$HOME/.docker"
            mkdir -p $DOCKER_CONFIG

            # === AWS Configuration ===
            export AWS_CONFIG_FILE="$HOME/.aws/config"
            export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
            mkdir -p $HOME/.aws

            # === GCP Configuration ===
            export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"
            mkdir -p $HOME/.config/gcloud

            # === History ===
            export HISTFILE="$HOME/.devops_history"
            export HISTSIZE=10000
            export HISTFILESIZE=10000

            # === Aliases ===
            alias k="kubectl"
            alias kgp="kubectl get pods"
            alias kgs="kubectl get svc"
            alias kgd="kubectl get deployments"
            alias kdp="kubectl describe pod"
            alias kl="kubectl logs"
            alias klf="kubectl logs -f"
            alias kx="kubectx"
            alias kn="kubens"

            alias tf="terraform"
            alias tfi="terraform init"
            alias tfp="terraform plan"
            alias tfa="terraform apply"
            alias tfd="terraform destroy"

            alias d="docker"
            alias dc="docker-compose"
            alias dps="docker ps"
            alias di="docker images"

            alias g="git"
            alias gs="git status"
            alias gl="git log --oneline --graph --decorate"

            alias ls="eza --icons"
            alias ll="eza -l --icons"
            alias la="eza -la --icons"
            alias tree="eza --tree --icons"

            alias cat="bat"
            alias grep="rg"
            alias find="fd"

            # === Functions ===

            # Quick namespace switch and list pods
            kns() {
              kubens $1 && kubectl get pods
            }

            # Get pod logs with fuzzy finder
            klogs() {
              local pod=$(kubectl get pods --all-namespaces -o name | fzf)
              if [ -n "$pod" ]; then
                kubectl logs -f $pod
              fi
            }

            # Port forward with fuzzy finder
            kpf() {
              local pod=$(kubectl get pods -o name | fzf)
              if [ -n "$pod" ]; then
                echo "Port to forward (e.g., 8080:8080):"
                read port
                kubectl port-forward $pod $port
              fi
            }

            # Exec into pod with fuzzy finder
            kexec() {
              local pod=$(kubectl get pods -o name | fzf)
              if [ -n "$pod" ]; then
                kubectl exec -it $pod -- /bin/bash || kubectl exec -it $pod -- /bin/sh
              fi
            }

            # === Starship Prompt ===
            eval "$(${pkgs.starship}/bin/starship init bash)"

            # === Direnv ===
            eval "$(${pkgs.direnv}/bin/direnv hook bash)"

            # === Zoxide ===
            eval "$(${pkgs.zoxide}/bin/zoxide init bash)"

            # === Welcome Message ===
            echo ""
            echo "╔═══════════════════════════════════════════════════════════╗"
            echo "║      DevOps Senior Engineer Environment Activated         ║"
            echo "╚═══════════════════════════════════════════════════════════╝"
            echo ""
            echo "🔧 Context Switchers:"
            echo "   kube-switch [work|personal]    - Switch Kubernetes config"
            echo "   tf-switch [work|personal]      - Switch Terraform workspace"
            echo "   docker-switch [work|personal]  - Switch Docker context"
            echo ""
            echo "📦 Current Configuration:"
            echo "   KUBECONFIG: $KUBECONFIG"
            echo "   TF_WORKSPACE: $TF_WORKSPACE"
            echo "   AWS_PROFILE: $AWS_PROFILE"
            echo ""
            echo "🚀 Quick Commands:"
            echo "   k9s           - Kubernetes TUI"
            echo "   klogs         - Interactive pod log viewer"
            echo "   kexec         - Interactive pod shell"
            echo "   kpf           - Interactive port forward"
            echo ""
          '';

          # === Environment Variables ===
          EDITOR = "nvim";
          VISUAL = "nvim";
          KUBE_EDITOR = "nvim";

          # Enable completion
          KUBECTL_EXTERNAL_DIFF = "diff";
        };

        # === Configuration Templates ===
        # You can generate these with: nix develop --command config-init
        apps.config-init = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "config-init" ''
                          echo "Initializing DevOps configuration structure..."
                          
                          # Kubernetes configs
                          mkdir -p $HOME/.kube
                          cat > $HOME/.kube/config-work << 'EOF'
              apiVersion: v1
              kind: Config
              clusters:
              - cluster:
                  server: https://work-cluster.example.com
                  certificate-authority-data: YOUR_CA_DATA
                name: work-cluster
              contexts:
              - context:
                  cluster: work-cluster
                  user: work-user
                  namespace: default
                name: work
              current-context: work
              users:
              - name: work-user
                user:
                  token: YOUR_TOKEN
              EOF

                          cat > $HOME/.kube/config-personal << 'EOF'
              apiVersion: v1
              kind: Config
              clusters:
              - cluster:
                  server: https://personal-cluster.example.com
                  certificate-authority-data: YOUR_CA_DATA
                name: personal-cluster
              contexts:
              - context:
                  cluster: personal-cluster
                  user: personal-user
                  namespace: default
                name: personal
              current-context: personal
              users:
              - name: personal-user
                user:
                  token: YOUR_TOKEN
              EOF

                          # AWS configs
                          mkdir -p $HOME/.aws
                          cat > $HOME/.aws/config << 'EOF'
              [profile work]
              region = us-east-1
              output = json

              [profile personal]
              region = us-west-2
              output = json
              EOF

                          cat > $HOME/.aws/credentials << 'EOF'
              [work]
              aws_access_key_id = YOUR_WORK_ACCESS_KEY
              aws_secret_access_key = YOUR_WORK_SECRET_KEY

              [personal]
              aws_access_key_id = YOUR_PERSONAL_ACCESS_KEY
              aws_secret_access_key = YOUR_PERSONAL_SECRET_KEY
              EOF

                          # Docker contexts
                          mkdir -p $HOME/.docker
                          
                          echo ""
                          echo "✅ Configuration templates created!"
                          echo ""
                          echo "📝 Next steps:"
                          echo "   1. Edit $HOME/.kube/config-work with your work cluster details"
                          echo "   2. Edit $HOME/.kube/config-personal with your personal cluster details"
                          echo "   3. Edit $HOME/.aws/credentials with your AWS credentials"
                          echo "   4. Run: docker context create work --docker host=unix:///var/run/docker.sock"
                          echo "   5. Run: docker context create personal --docker host=unix:///var/run/docker.sock"
                          echo ""
            ''
          );
        };
      }
    );
}
