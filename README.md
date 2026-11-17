# 🛠️ Engenharia & DevOps Hub

Repositório central de estudos, automações, scripts, práticas recomendadas e referências em Engenharia de Software, DevOps, Infraestrutura e SRE.

---

## 📂 Estrutura do Repositório

| Módulo | Descrição |
|---|---|
| [**01-Ansible**](./01-Ansible) | Playbooks, roles, inventários, boas práticas e automação de configuração com Ansible. |
| [**02-automacao-e-scripting**](./02-automacao-e-scripting) | Scripts de automação em Python e Shell para tarefas operacionais. |
| [**03-bash**](./03-bash) | Guia e snippets de Shell Scripting do básico ao avançado, gestão de processos e logs. |
| [**04-ci - cd**](./04-ci%20-%20cd) | Pipelines CI/CD com GitHub Actions, GitLab CI, Jenkins, GitOps e quality gates. |
| [**05-cloud-e-iac**](./05-cloud-e-iac) | Infraestrutura como Código (Terraform) e arquitetura em nuvem. |
| [**06-devops-e-plataforma**](./06-devops-e-plataforma) | Engenharia de plataforma, esteiras de entrega contínua e padrões DevOps. |
| [**07-docker**](./07-docker) | Fundamentos de containers, Dockerfile multi-stage, redes, volumes e Compose. |
| [**08-git**](./08-git) | Estratégias de branching, convenções de commit, hooks, rebase e resolução de conflitos. |
| [**09-linux**](./09-linux) | Administração de sistemas Linux, permissões, systemd, redes, storage e troubleshooting. |
| [**10-observabilidade-e-sre**](./10-observabilidade-e-sre) | Métricas, tracing e logs com Prometheus, Grafana e práticas de confiabilidade (SRE). |
| [**11-python-entrevistas**](./11-python-entrevistas) | Algoritmos, estruturas de dados, system design e preparação técnica em Python. |
| [**12sistemas-e-containers**](./12sistemas-e-containers) | Arquitetura de sistemas operacionais e orquestração de containers (Kubernetes/Docker). |
| [**trilhas**](./trilhas) | Scripts e roteiros de criação de trilhas de aprendizado e desenvolvimento. |

---

## 💻 Compatibilidade Multiplataforma (Multi-OS & Devs)

Este repositório foi padronizado para desenvolvedores que utilizam diferentes sistemas operacionais (**Linux**, **macOS** ou **Windows**):

- **`.gitattributes`**: Normaliza automaticamente quebras de linha (`LF` para arquivos de texto e scripts Unix, `CRLF` para batch/powershell e binários protegidos).
- **`.editorconfig`**: Mantém consistência de indentação (espaços), charset UTF-8 e final de arquivo em qualquer IDE (VS Code, JetBrains, Vim, Neovim, Sublime).
- **`.gitignore`**: Configurado para ignorar arquivos temporários de SOs (`.DS_Store`, `Thumbs.db`), diretórios de IDEs (`.idea/`, `.vscode/`), segredos (`.env`, certificados) e caches (`__pycache__`, `.terraform`).

---

## 🚀 Como Utilizar

1. **Clonar o repositório:**
   ```bash
   git clone https://github.com/JunioSilvestre/Engenharia.git
   cd Engenharia
   ```

2. **Configuração recomendada do Git para quem usa Windows:**
   ```bash
   git config core.autocrlf true
   ```

3. **Configuração recomendada para quem usa Linux/macOS:**
   ```bash
   git config core.autocrlf input
   ```
