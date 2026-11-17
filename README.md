# 🛠️ Engenharia & DevOps Hub

Repositório central de estudos, automações, scripts, práticas recomendadas e referências em Engenharia de Software, DevOps, Infraestrutura e SRE.

---

## 📂 Estrutura do Repositório

| Módulo | Descrição |
|---|---|
| [**00-trilhas**](./00-trilhas) | Scripts e roteiros para criação e sincronização de trilhas de aprendizado. |
| [**01-linux**](./01-linux) | Administração de sistemas Linux, permissões, systemd, redes, 180 laboratórios e guias do básico ao expert. |
| [**02-git**](./02-git) | Estratégias de branching, convenções de commit, hooks, rebase e resolução de conflitos. |
| [**03-bash**](./03-bash) | Guia e snippets de Shell Scripting do básico ao avançado, gestão de processos e logs. |
| [**04-python**](./04-python) | Algoritmos, estruturas de dados, APIs, POO, testes e trilha completa de SQL/PostgreSQL. |
| [**05-automacao**](./05-automacao) | Scripts de automação operacional em Python e Shell com projetos e laboratórios práticos. |
| [**06-docker**](./06-docker) | Fundamentos de containers, Compose, Dockerfile multi-stage, Kubernetes, Helm e laboratórios. |
| [**07-cloud-e-iac**](./07-cloud-e-iac) | Infraestrutura como Código (Terraform) e arquitetura em nuvem (AWS/Azure/GCP). |
| [**08-ansible**](./08-ansible) | Playbooks, roles, inventários, boas práticas e automação de configuração com Ansible. |
| [**09-ci-cd**](./09-ci-cd) | Pipelines CI/CD (GitHub Actions, GitLab CI, Jenkins, GitOps) e Platform Engineering (Backstage, IDP). |
| [**10-observabilidade**](./10-observabilidade) | Métricas, tracing e logs com Prometheus, Grafana e práticas de confiabilidade (SRE). |

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
