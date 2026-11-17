#!/usr/bin/env bash
# criar_pastas_treino.sh
# Cria uma pasta por categoria de Python para entrevistas, com as subpastas
# problemas/, exercicios/ e projetos/. Dentro de problemas/ e projetos/ cria
# a pasta do exemplo indicado na tabela.
#
# Uso:
#   ./criar_pastas_treino.sh [DIRETORIO_DESTINO]
#
# Se o destino não for informado, usa ./python-entrevistas

set -euo pipefail

DESTINO="${1:-./python-entrevistas}"

# Formato: categoria|exemplo_projeto|exemplo_problema
# Linhas começando com # são ignoradas.
read -r -d '' TABELA <<'EOF' || true
arrays-lists|monitor-metricas-cpu|rotacao-array
strings|analisador-auth-log|palindromo-alfanumerico
dictionaries-hash-maps|cache-lru-dns|two-sum
sets|auditoria-grupos-usuarios|interseccao-permissoes
tuples|parser-registros-imutaveis|retorno-multiplo-min-max
numbers-math|calculadora-estatisticas-series|primos-ate-n
sorting-searching|ranking-latencia-servicos|busca-binaria-rotacionada
recursion|explorador-arvore-diretorios|fibonacci-memoizado
algorithms|detector-janela-deslizante-metricas|two-pointers-soma-alvo
data-structures|fila-tarefas-com-prioridade|validar-parenteses
complexity-big-o|benchmark-estruturas-dados|reduzir-complexidade-quadratica
dates-time|agendador-backups-utc|diferenca-dias-fusos
files-io|rotacao-logs-por-tamanho|contar-linhas-arquivo-grande
regular-expressions|validador-config-regex|extrair-emails-texto
oop|sistema-alertas-polimorfico|classe-conta-encapsulada
python-advanced|pipeline-generators-logs|decorator-medir-tempo
exception-handling|cliente-api-com-retry|excecao-customizada-validacao
functional-programming|transformador-eventos-pipeline|map-filter-comprehension
concurrency-async|coletor-status-async|race-condition-contador
sql-databases|relatorio-sql-indices|join-agregacao-pedidos
apis-backend|api-metricas-fastapi|validar-payload-pydantic
testing-qa|suite-testes-parser-logs|mock-chamada-http
data-engineering|etl-csv-para-banco|agregacao-pandas-grupos
cloud-deployment|pipeline-ci-docker|dockerfile-multistage
security|verificador-jwt-expiracao|hash-senha-seguro
code-quality|refatoracao-com-type-hints|aplicar-solid-modulo
system-design|design-encurtador-url|consistency-trade-offs
linux-so|watchdog-servico-backoff|ler-proc-status
performance-profiling|otimizacao-processamento-logs|profilar-funcao-lenta
observabilidade|exporter-metricas-prometheus|logs-estruturados-json
resiliencia|cliente-circuit-breaker|retry-com-jitter
debugging|reproducao-bug-traceback|isolar-causa-regressao
packaging-ambiente|projeto-pyproject-cli|lock-dependencias
git-colaboracao|fluxo-pr-com-revisao|resolver-conflito-rebase
engenharia-dados-ia|pipeline-avaliacao-llm|chunking-texto-embeddings
comportamental-star|historias-incidente-star|caso-decisao-tecnica
EOF

criadas=0
while IFS='|' read -r categoria exemplo_projeto exemplo_problema; do
    [[ -z "$categoria" ]] && continue

    base="$DESTINO/$categoria"
    mkdir -p "$base/problemas" "$base/exercicios" "$base/projetos"
    mkdir -p "$base/problemas/$exemplo_problema" "$base/projetos/$exemplo_projeto"

    # README da categoria, só se ainda não existir (não sobrescreve seu trabalho)
    if [[ ! -f "$base/README.md" ]]; then
        printf '# %s\n\nSubpastas: `problemas/`, `exercicios/`, `projetos/`.\n' "$categoria" > "$base/README.md"
    fi

    criadas=$((criadas + 1))
done <<< "$TABELA"

echo "Categorias criadas em: $DESTINO"
echo "Total de categorias: $criadas"