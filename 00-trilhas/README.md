# 🧭 00-Trilhas & Gerador Automatizado

Diretório central responsável pelo gerenciamento, padronização e geração automática de todas as trilhas de estudo e desafios em Engenharia de Software, DevOps e SRE.

---

## 📂 Estrutura

```text
00-trilhas/
├── definicoes/             # Arquivos de texto (.txt) padronizados com o escopo de cada trilha
│   ├── ansible.txt
│   ├── bash.txt
│   ├── cicd.txt
│   ├── docker.txt
│   ├── git.txt
│   ├── linux.txt
│   ├── python.txt
│   └── sql-postgresql.txt
├── gerar_trilhas.sh        # Script mestre único de geração e sincronização
└── README.md               # Esta documentação
```

---

## 🚀 Como Utilizar

### 1. Sincronizar todas as trilhas do projeto
Executa o mapeamento completo e atualiza todos os módulos (`01-linux`, `02-git`, `03-bash`, etc.):
```bash
./gerar_trilhas.sh
```

### 2. Sincronizar apenas uma trilha específica
Basta passar o nome da trilha como argumento:
```bash
./gerar_trilhas.sh linux
./gerar_trilhas.sh python
./gerar_trilhas.sh git
./gerar_trilhas.sh bash
./gerar_trilhas.sh docker
./gerar_trilhas.sh ansible
./gerar_trilhas.sh cicd
./gerar_trilhas.sh sql-postgresql
```

### 3. Execução personalizada para novo arquivo/destino
```bash
./gerar_trilhas.sh definicoes/minha_trilha.txt ../meu-modulo "Meu Título"
```

---

## 📝 Formato do Arquivo de Definição (.txt)

Cada linha do arquivo `.txt` dentro de `definicoes/` representa uma categoria ou tópico, com campos separados por pipe (`|`):

```text
num|slug|nome|desafios|prioridade|exemplo_projeto|exemplo_problema|exemplo_exercicio
```

| Campo | Descrição |
|---|---|
| `num` | Número sequencial na lista (1, 2, 3...) |
| `slug` | Nome da pasta no sistema de arquivos (ex: `arrays-lists`) |
| `nome` | Nome legível exibido nos títulos e índices |
| `desafios` | Resumo de tópicos e habilidades cobertas |
| `prioridade` | Nível de prioridade para entrevistas/nível sênior (Alta, Média, Baixa) |
| `exemplo_projeto` | Subpasta inicial dentro de `projetos/` |
| `exemplo_problema` | Subpasta inicial dentro de `problemas/` |
| `exemplo_exercicio` | Subpasta inicial dentro de `exercicios/` |

---

## 🛡️ Segurança e Preservação de Dados
O script **nunca sobrescreve edições manuais**. Qualquer anotação, código ou solução implementada dentro de um `README.md` de categoria é automaticamente detectada e preservada de forma idempotente.
