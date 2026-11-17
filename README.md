# 🛠️ Engenharia & DevOps Hub

Repositório central de estudos, automações, scripts, práticas recomendadas e referências em Engenharia de Software, DevOps, Infraestrutura e SRE.

---

## 📂 Estrutura do Repositório

| Módulo | Descrição |
|---|---|
| [**00-trilhas**](./00-trilhas) | Scripts e roteiros para criação de trilhas de aprendizado e desenvolvimento. |
| [**01-ansible**](./01-ansible) | Playbooks, roles, inventários, boas práticas e automação de configuração com Ansible. |
| [**02-automacao-e-scripting**](./02-automacao-e-scripting) | Scripts de automação em Python e Shell para tarefas operacionais. |
| [**03-bash**](./03-bash) | Guia e snippets de Shell Scripting do básico ao avançado, gestão de processos e logs. |
| [**04-ci-cd**](./04-ci-cd) | Pipelines CI/CD com GitHub Actions, GitLab CI, Jenkins, GitOps e quality gates. |
| [**05-cloud-e-iac**](./05-cloud-e-iac) | Infraestrutura como Código (Terraform) e arquitetura em nuvem. |
| [**06-devops-e-plataforma**](./06-devops-e-plataforma) | Engenharia de plataforma, esteiras de entrega contínua e padrões DevOps. |
| [**07-docker**](./07-docker) | Fundamentos de containers, Dockerfile multi-stage, redes, volumes e Compose. |
| [**08-git**](./08-git) | Estratégias de branching, convenções de commit, hooks, rebase e resolução de conflitos. |
| [**09-linux**](./09-linux) | Administração de sistemas Linux, permissões, systemd, redes, storage e troubleshooting. |
| [**10-observabilidade-e-sre**](./10-observabilidade-e-sre) | Métricas, tracing e logs com Prometheus, Grafana e práticas de confiabilidade (SRE). |
| [**11-python-entrevistas**](./11-python-entrevistas) | Algoritmos, estruturas de dados, system design e preparação técnica em Python. |
| [**old**](./old) | Arquivo histórico e versões anteriores preservadas (sem perda de dados). |

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
