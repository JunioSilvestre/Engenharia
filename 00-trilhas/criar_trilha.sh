#!/usr/bin/env bash
# criar_trilha.sh
# Gera a estrutura de uma trilha de estudo a partir de um arquivo de categorias.
#
# Uso:
#   ./criar_trilha.sh DIRETORIO_DESTINO ARQUIVO_TRILHA.txt ["Título da trilha"]
#
# Exemplo:
#   ./criar_trilha.sh ./interview-prep/git trilhas/git.txt "Git"
#
# Formato do arquivo de trilha (uma categoria por linha, campos separados por |):
#   num|slug|nome|desafios|prioridade|exemplo_projeto|exemplo_problema|exemplo_exercicio
#
# Segurança: rodar de novo nunca apaga nada. Um README.md só é reescrito se for
# gerado por este script (marca no início e no fim) ou se for o README padrão
# ainda não alterado. Edições manuais são preservadas.

set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Uso: $0 DIRETORIO_DESTINO ARQUIVO_TRILHA.txt [\"Título\"]" >&2
    exit 2
fi

DESTINO="$1"
ARQUIVO="$2"
TITULO="${3:-$(basename "$ARQUIVO" .txt)}"
MARCA_GERADO="<!-- gerado por criar_trilha.sh -->"
MARCA_FIM="<!-- fim do arquivo gerado -->"

if [[ ! -r "$ARQUIVO" ]]; then
    echo "Erro: arquivo de trilha não encontrado ou ilegível: $ARQUIVO" >&2
    exit 1
fi

# Regra: reescreve apenas arquivos gerados por este script (marca no início e no fim)
# ou o README padrão ainda não alterado.
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

while IFS='|' read -r num slug nome desafios prioridade ex_proj ex_prob ex_exerc; do
    [[ -z "${slug:-}" ]] && continue
    [[ "$num" == \#* ]] && continue

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
        echo "| Trilha | $TITULO |"
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
done < "$ARQUIVO"

index="$DESTINO/INDEX.md"
if pode_escrever "$index"; then
    {
        echo "$MARCA_GERADO"
        echo "# Índice: $TITULO"
        echo
        echo "Prioridades são sugestões para nível sênior. Problemas são desafios práticos; exercícios são construções isoladas; projetos são soluções completas."
        echo
        echo "| # | Categoria | Desafios e conhecimentos | Prioridade |"
        echo "|---|---|---|---|"
        while IFS='|' read -r num slug nome desafios prioridade _ _ _; do
            [[ -z "${slug:-}" ]] && continue
            [[ "$num" == \#* ]] && continue
            echo "| $num | [$nome]($slug/README.md) | $desafios | $prioridade |"
        done < "$ARQUIVO"
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
