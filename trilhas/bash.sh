#!/usr/bin/env bash
# criar_estrutura_bash.sh
# Cria a estrutura de preparação para entrevistas técnicas de Bash:
#   - uma pasta por categoria, com problemas/, exercicios/ e projetos/
#   - exemplos de problema, exercício e projeto dentro de cada subpasta
#   - README.md em cada categoria e INDEX.md na raiz
#
# Uso:
#   ./criar_estrutura_bash.sh [DIRETORIO_DESTINO]
#
# Padrão: ./bash-entrevistas
#
# Segurança: rodar de novo nunca apaga nada. Um README.md só é reescrito se for
# gerado por este script e não tiver sido alterado. Edições manuais são preservadas.

set -euo pipefail

DESTINO="${1:-./bash-entrevistas}"
MARCA_GERADO="<!-- gerado por criar_estrutura_bash.sh -->"
MARCA_FIM="<!-- fim do arquivo gerado -->"

# Formato: num|slug|nome|desafios|prioridade|exemplo_projeto|exemplo_problema|exemplo_exercicio
# Prioridade é uma sugestão para nível sênior, não uma regra.
read -r -d '' TABELA <<'EOF' || true
1|bash-fundamentals|Bash Fundamentals|Shell, comandos, variáveis, ambiente|Média|relatorio-sistema-shell|primeiro-script-com-shebang|diferenca-variavel-shell-e-ambiente
2|variables|Variables|Declaração, expansão, environment variables|Média|config-por-ambiente|expandir-variavel-com-default|export-e-subshell
3|input-output|Input / Output|read, echo, printf, redirection|Média|menu-interativo-cli|ler-linha-com-read-r|printf-vs-echo
4|operators|Operators|Comparações, operadores lógicos e aritméticos|Média|validador-faixas-numericas|comparar-strings-e-numeros|aritmetica-com-duplo-parenteses
5|conditionals|Conditionals|if, elif, else, case|Alta|verificador-servicos-case|if-com-test-de-arquivo|elif-com-codigos-de-saida
6|loops|Loops|for, while, until|Alta|renomeador-em-lote|iterar-linhas-de-arquivo|while-com-read-sem-subshell
7|functions|Functions|Declaração, parâmetros, retorno|Alta|biblioteca-funcoes-log|funcao-que-retorna-status|passar-parametros-e-local
8|arrays|Arrays|Arrays indexados e associativos|Média|coletor-hosts-associativo|remover-duplicatas-com-array|arrays-associativos-contadores
9|string-manipulation|String Manipulation|Substring, expansão, substituição|Média|normalizador-nomes-arquivos|extrair-extensao-sem-sed|substituicao-de-padrao-com-expansao
10|text-processing|Text Processing|grep, sed, awk, cut, sort, uniq|Alta|relatorio-top-ips-awk|contar-ocorrencias-com-sort-uniq|extrair-campo-com-awk
11|file-operations|File Operations|find, test, touch, cp, mv|Alta|sincronizador-diretorios|encontrar-arquivos-antigos|testar-existencia-com-test
12|pipes-redirection|Pipes / Redirection|pipe, stdin, stdout, stderr|Média|pipeline-logs-compactados|separar-stdout-e-stderr|tee-para-arquivo-e-tela
13|exit-codes|Exit Codes|$?, exit, set -e, set -u, pipefail|Alta|script-com-set-euo-pipefail|pipeline-que-falha-escondido|capturar-codigo-com-dollar-question
14|process-management|Process Management|jobs, wait, kill, background|Média|supervisor-paralelo|esperar-varios-jobs-com-wait|background-e-kill
15|arguments|Arguments|$1, $2, $@, $#, getopts|Alta|cli-com-getopts|tratar-argumentos-com-espacos|shift-e-dollar-at
16|error-handling|Error Handling|Traps, signals, validações|Alta|runner-com-trap-cleanup|limpar-arquivo-temp-em-erro|validar-entrada-antes-de-usar
17|scheduling|Scheduling|cron e execução automatizada|Alta|backup-agendado-cron|cron-sem-variaveis-de-ambiente|lock-com-flock
18|logging|Logging|Logs, timestamps, níveis de mensagens|Alta|biblioteca-logging-niveis|log-com-timestamp-utc|redirecionar-log-para-syslog
19|networking-automation|Networking Automation|ping, curl, nc, DNS checks|Média|checker-endpoints-curl|teste-porta-com-nc|resolver-dns-com-getent
20|system-automation|System Automation|Backup, monitoramento, limpeza, health checks|Alta|health-check-servidor|limpar-logs-antigos-com-seguranca|alerta-de-disco-cheio
21|security|Security|Quoting, permissões, validação de entrada|Alta|script-com-validacao-entrada|injecao-por-variavel-sem-aspas|permissoes-de-arquivo-com-segredo
22|advanced-scripting|Advanced Scripting|Modularização, debugging, ShellCheck, testes|Alta|modulo-bash-com-testes|depurar-com-set-x|rodar-shellcheck-e-corrigir
EOF

# Regra: o arquivo só é reescrito se tiver a marca no início E no fim, ou se for
# o README padrão deste script (ainda sem alteração). Qualquer outra coisa é preservada.
pode_escrever() {
    local arq="$1"
    [[ ! -f "$arq" ]] && return 0
    if [[ "$(head -n 1 "$arq")" == "$MARCA_GERADO" && "$(tail -n 1 "$arq")" == "$MARCA_FIM" ]]; then
        return 0
    fi
    local nome_pasta esperado
    nome_pasta="$(basename "$(dirname "$arq")")"
    esperado="$(printf '# %s\n\nSubpastas: `problemas/`, `exercicios/`, `projetos/`.' "$nome_pasta")"
    [[ "$(cat "$arq")" == "$esperado" ]]
}

mkdir -p "$DESTINO"

criadas=0
gerados=0
preservados=0

# ---------- pastas, exemplos e README por categoria ----------
while IFS='|' read -r num slug nome desafios prioridade ex_proj ex_prob ex_exerc; do
    [[ -z "$slug" ]] && continue
    base="$DESTINO/$slug"

    mkdir -p "$base/problemas/$ex_prob" "$base/exercicios/$ex_exerc" "$base/projetos/$ex_proj"
    criadas=$((criadas + 1))

    arq="$base/README.md"
    if ! pode_escrever "$arq"; then
        echo "PRESERVADO (editado manualmente): $slug/README.md"
        preservados=$((preservados + 1))
        continue
    fi

    {
        echo "$MARCA_GERADO"
        echo "# $nome"
        echo
        echo "| Campo | Valor |"
        echo "|---|---|"
        echo "| Número na lista | $num |"
        echo "| Prioridade (sugestão sênior) | $prioridade |"
        echo
        echo "## Desafios e conhecimentos"
        echo
        echo "$desafios"
        echo
        echo "## Estrutura"
        echo
        echo "- \`problemas/\`: pequeno script de desafio"
        echo "- \`exercicios/\`: construção isolada (sintaxe ou comando)"
        echo "- \`projetos/\`: automação completa, com testes e logs"
        echo
        echo "## Exemplos iniciais"
        echo
        echo "- Problema: \`problemas/$ex_prob/\`"
        echo "- Exercício: \`exercicios/$ex_exerc/\`"
        echo "- Projeto: \`projetos/$ex_proj/\`"
        echo
        echo "## Progresso"
        echo
        echo "| Item | Status | Data |"
        echo "|---|---|---|"
        echo "| $ex_prob | pendente | |"
        echo "| $ex_exerc | pendente | |"
        echo "| $ex_proj | pendente | |"
        echo
        echo "$MARCA_FIM"
    } > "$arq"
    gerados=$((gerados + 1))
done <<< "$TABELA"

# ---------- INDEX.md na raiz ----------
index="$DESTINO/INDEX.md"
if pode_escrever "$index"; then
    {
        echo "$MARCA_GERADO"
        echo "# Índice: preparação para entrevistas técnicas (Bash)"
        echo
        echo "Categorias com links para cada pasta. Prioridades são sugestões para nível sênior. Problemas são pequenos scripts de desafio; exercícios são construções isoladas; projetos são automações completas."
        echo
        echo "| # | Categoria | Desafios e conhecimentos | Prioridade |"
        echo "|---|---|---|---|"
        while IFS='|' read -r num slug nome desafios prioridade _ _ _; do
            [[ -z "$slug" ]] && continue
            echo "| $num | [$nome]($slug/README.md) | $desafios | $prioridade |"
        done <<< "$TABELA"
        echo
        echo "$MARCA_FIM"
    } > "$index"
    echo "INDEX.md gerado: $index"
else
    echo "PRESERVADO (editado manualmente): INDEX.md"
    preservados=$((preservados + 1))
fi

echo "Categorias processadas: $criadas"
echo "README.md gerados: $gerados"
echo "Arquivos preservados: $preservados"
echo "Destino: $DESTINO"