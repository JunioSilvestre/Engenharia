#!/usr/bin/env bash
# ==============================================================================
# gerar_trilhas.sh
# ==============================================================================
# Gerador central e unificado de trilhas de Engenharia & DevOps.
#
# Processa os arquivos de definição (.txt) em definicoes/ e gera a estrutura
# padronizada de estudo:
#   - pastas por categoria com subpastas problemas/, exercicios/ e projetos/
#   - README.md em cada categoria com metadados, desafios e tabela de progresso
#   - INDEX.md na raiz do módulo com links e níveis de prioridade sênior
#
# Segurança:
#   Arquivos editados manualmente são SEMPRE preservados. Apenas arquivos com
#   a marcação de geração automática ou com o template vazio padrão são atualizados.
#
# Uso:
#   ./gerar_trilhas.sh                      # Gera/sincroniza todas as trilhas
#   ./gerar_trilhas.sh <trilha>             # Gera apenas uma trilha (ex: linux, python, git)
#   ./gerar_trilhas.sh ARQ.txt DEST [NOME]  # Execução personalizada
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENG_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DEFINICOES_DIR="$SCRIPT_DIR/definicoes"

MARCA_GERADO="<!-- gerado por gerar_trilhas.sh -->"
MARCA_FIM="<!-- fim do arquivo gerado -->"

# Verifica se o arquivo pode ser reescrito com segurança
pode_escrever() {
    local arq="$1"
    [[ ! -f "$arq" ]] && return 0

    local primeira_linha
    primeira_linha="$(head -n 1 "$arq" 2>/dev/null || true)"
    local ultima_linha
    ultima_linha="$(tail -n 1 "$arq" 2>/dev/null || true)"

    # Arquivo gerado anteriormente por este script ou versões anteriores
    if [[ "$primeira_linha" =~ "<!-- gerado por " && "$ultima_linha" =~ "<!-- fim do arquivo gerado -->" ]]; then
        return 0
    fi

    # Template padrão simples
    local nome_pasta esperado
    nome_pasta="$(basename "$(dirname "$arq")")"
    esperado="$(printf '# %s\n\nSubpastas: `problemas/`, `exercicios/`, `projetos/`.' "$nome_pasta")"
    [[ "$(cat "$arq" 2>/dev/null || true)" == "$esperado" ]]
}

# Processa uma única trilha
gerar_uma_trilha() {
    local arquivo="$1"
    local destino="$2"
    local titulo="$3"

    if [[ ! -r "$arquivo" ]]; then
        echo "❌ Erro: arquivo de definição não encontrado: $arquivo" >&2
        return 1
    fi

    echo "▶ Processando trilha: $titulo"
    echo "  📁 Arquivo: $arquivo"
    echo "  🎯 Destino: $destino"

    mkdir -p "$destino"

    local criadas=0
    local gerados=0
    local preservados=0

    while IFS='|' read -r num slug nome desafios prioridade ex_proj ex_prob ex_exerc; do
        [[ -z "${slug:-}" ]] && continue
        [[ "$num" == \#* ]] && continue

        local base="$destino/$slug"
        mkdir -p "$base/problemas/${ex_prob:-desafio}" \
                 "$base/exercicios/${ex_exerc:-exercicio-1}" \
                 "$base/projetos/${ex_proj:-projeto-1}"
        criadas=$((criadas + 1))

        local arq="$base/README.md"
        if ! pode_escrever "$arq"; then
            preservados=$((preservados + 1))
            continue
        fi

        {
            echo "$MARCA_GERADO"
            echo "# $nome"
            echo
            echo "| Campo | Valor |"
            echo "|---|---|"
            echo "| Trilha | $titulo |"
            echo "| Número na lista | $num |"
            echo "| Prioridade (sugestão sênior) | $prioridade |"
            echo
            echo "## Desafios e conhecimentos"
            echo
            echo "$desafios"
            echo
            echo "## Estrutura"
            echo
            echo "- \`problemas/\`: desafio prático, com critério de sucesso"
            echo "- \`exercicios/\`: construção isolada de um conceito"
            echo "- \`projetos/\`: solução completa, com testes e documentação"
            echo
            echo "## Exemplos iniciais"
            echo
            echo "- Problema: \`problemas/${ex_prob:-desafio}/\`"
            echo "- Exercício: \`exercicios/${ex_exerc:-exercicio-1}/\`"
            echo "- Projeto: \`projetos/${ex_proj:-projeto-1}/\`"
            echo
            echo "## Progresso"
            echo
            echo "| Item | Status | Data |"
            echo "|---|---|---|"
            echo "| ${ex_prob:-desafio} | pendente | |"
            echo "| ${ex_exerc:-exercicio-1} | pendente | |"
            echo "| ${ex_proj:-projeto-1} | pendente | |"
            echo
            echo "$MARCA_FIM"
        } > "$arq"
        gerados=$((gerados + 1))
    done < "$arquivo"

    # Atualiza INDEX.md da raiz daquele módulo
    local index="$destino/INDEX.md"
    if pode_escrever "$index"; then
        {
            echo "$MARCA_GERADO"
            echo "# Índice: $titulo"
            echo
            echo "Prioridades são sugestões para nível sênior. Problemas são desafios práticos; exercícios são construções isoladas; projetos são soluções completas."
            echo
            echo "| # | Categoria | Desafios e conhecimentos | Prioridade |"
            echo "|---|---|---|---|"
            while IFS='|' read -r num slug nome desafios prioridade _ _ _; do
                [[ -z "${slug:-}" ]] && continue
                [[ "$num" == \#* ]] && continue
                echo "| $num | [$nome]($slug/README.md) | $desafios | $prioridade |"
            done < "$arquivo"
            echo
            echo "$MARCA_FIM"
        } > "$index"
    else
        preservados=$((preservados + 1))
    fi

    echo "  ✔ Categorias: $criadas | READMEs gerados: $gerados | Preservados: $preservados"
    echo
}

# Exibição de Ajuda
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    echo "Uso:"
    echo "  $0                                          # Gera todas as trilhas mapeadas"
    echo "  $0 <nome>                                   # Ex: $0 linux (ou git, bash, python, docker, ansible, cicd)"
    echo "  $0 ARQUIVO_TRILHA.txt DESTINO [\"Título\"]    # Customizado"
    exit 0
fi

# Modo Customizado: 2 ou mais argumentos passados
if [[ $# -ge 2 ]]; then
    ARQUIVO="$1"
    DESTINO="$2"
    TITULO="${3:-$(basename "$ARQUIVO" .txt)}"
    gerar_uma_trilha "$ARQUIVO" "$DESTINO" "$TITULO"
    exit 0
fi

# Mapeamento padrão trilha -> módulo de Engenharia
executar_por_chave() {
    local chave="$1"
    case "$chave" in
        linux)
            gerar_uma_trilha "$DEFINICOES_DIR/linux.txt" "$ENG_ROOT/01-linux" "Linux"
            ;;
        git)
            gerar_uma_trilha "$DEFINICOES_DIR/git.txt" "$ENG_ROOT/02-git" "Git"
            ;;
        bash)
            gerar_uma_trilha "$DEFINICOES_DIR/bash.txt" "$ENG_ROOT/03-bash" "Bash"
            ;;
        python)
            gerar_uma_trilha "$DEFINICOES_DIR/python.txt" "$ENG_ROOT/04-python" "Python"
            ;;
        docker)
            gerar_uma_trilha "$DEFINICOES_DIR/docker.txt" "$ENG_ROOT/06-docker" "Docker"
            ;;
        ansible)
            gerar_uma_trilha "$DEFINICOES_DIR/ansible.txt" "$ENG_ROOT/08-ansible" "Ansible"
            ;;
        cicd|ci-cd)
            gerar_uma_trilha "$DEFINICOES_DIR/cicd.txt" "$ENG_ROOT/09-ci-cd" "CI/CD"
            ;;
        sql|postgresql|sql-postgresql)
            gerar_uma_trilha "$DEFINICOES_DIR/sql-postgresql.txt" "$ENG_ROOT/04-python/sql-databases" "SQL / PostgreSQL"
            ;;
        *)
            if [[ -f "$DEFINICOES_DIR/$chave.txt" ]]; then
                gerar_uma_trilha "$DEFINICOES_DIR/$chave.txt" "$ENG_ROOT/$chave" "$chave"
            else
                echo "❌ Trilha desconhecida: $chave" >&2
                echo "Trilhas disponíveis: linux, git, bash, python, docker, ansible, cicd, sql-postgresql" >&2
                exit 1
            fi
            ;;
    esac
}

# Se passou uma chave específica (ex: ./gerar_trilhas.sh linux)
if [[ $# -eq 1 ]]; then
    executar_por_chave "$1"
    exit 0
fi

# Sem argumentos: processa todas as trilhas principais
echo "=========================================================="
echo "🚀 Sincronizando todas as Trilhas de Engenharia & DevOps..."
echo "=========================================================="
echo

executar_por_chave "linux"
executar_por_chave "git"
executar_por_chave "bash"
executar_por_chave "python"
executar_por_chave "sql-postgresql"
executar_por_chave "docker"
executar_por_chave "ansible"
executar_por_chave "cicd"

echo "=========================================================="
echo "✨ Todas as trilhas foram processadas com sucesso!"
echo "=========================================================="
