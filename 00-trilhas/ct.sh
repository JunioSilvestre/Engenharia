#!/usr/bin/env bash
# gerar_docs_treino.sh
# Gera INDEX.md na raiz do destino e README.md em cada categoria, a partir da
# lista unificada de Python para entrevistas (tipo, categoria, desafios, prioridade).
#
# Uso:
#   ./gerar_docs_treino.sh [DIRETORIO_DESTINO]
#
# Regra de segurança: um README.md só é reescrito se tiver a marca
# MARCA_GERADO na primeira linha. Arquivos editados por você (sem a marca) são
# preservados e aparecem como "ignorado" na saída.

set -euo pipefail

DESTINO="${1:-./python-entrevistas}"
MARCA_GERADO="<!-- gerado por gerar_docs_treino.sh -->"
MARCA_FIM="<!-- fim do arquivo gerado -->"

if [[ ! -d "$DESTINO" ]]; then
    echo "Erro: diretório não existe: $DESTINO" >&2
    echo "Rode primeiro o criar_pastas_treino.sh com o mesmo destino." >&2
    exit 1
fi

# Formato: numero|tipo|categoria_pasta|nome_exibicao|desafios|prioridade
read -r -d '' TABELA <<'EOF' || true
1|Linguagem|arrays-lists|Arrays / Lists|Ordenação, duplicados, maior/menor valor, rotações|Alta
2|Linguagem|strings|Strings|Palíndromos, anagramas, parsing, regex|Alta
3|Linguagem|dictionaries-hash-maps|Dictionaries / Hash Maps|Frequência, agrupamento, busca por chave|Alta
4|Linguagem|sets|Sets|Unicidade, interseção, diferença|Média
5|Linguagem|tuples|Tuples|Imutabilidade, desempacotamento, retorno múltiplo|Média
6|Algoritmos|numbers-math|Numbers / Math|Primos, Fibonacci, fatoriais, operações matemáticas|Baixa
7|Algoritmos|sorting-searching|Sorting / Searching|Binary Search, uso de sorted com key, noção de Merge e Quick Sort|Média
8|Algoritmos|recursion|Recursion|Árvore de recursão, memoização, quando não usar|Média
9|Algoritmos|algorithms|Algorithms|Two Pointers, Sliding Window, Greedy, BFS/DFS, Dijkstra|Alta
10|Algoritmos|data-structures|Data Structures|Stack, Queue, deque, Linked List, Trees, Graphs, Heap, bisect|Alta
11|Algoritmos|complexity-big-o|Complexity / Big O|Time e Space Complexity, otimização com medição|Alta
12|Linguagem|dates-time|Dates / Time|datetime, timezone, timedelta, UTC|Média
13|Linguagem|files-io|Files / I/O|Arquivos, CSV, JSON, pathlib, logs|Média
14|Linguagem|regular-expressions|Regular Expressions|Validação, extração e transformação de texto|Média
15|Linguagem|oop|OOP|Classes, herança, encapsulamento, polimorfismo, Protocols e ABCs|Média
16|Linguagem|python-advanced|Python Advanced|Decorators, Generators, Iterators, Context Managers|Média
17|Linguagem|exception-handling|Exception Handling|Try/Except, custom exceptions, logging|Média
18|Linguagem|functional-programming|Functional Programming|Lambda, map, filter, comprehensions|Baixa
19|Arquitetura|concurrency-async|Concorrência|GIL, threads vs processos vs asyncio, race conditions, locks, concurrent.futures, async/await|Alta
20|Dados|sql-databases|SQL / Databases|PostgreSQL, SQL Server, JOIN, índices compostos, EXPLAIN, transações|Alta
21|Backend|apis-backend|APIs / Backend|REST, HTTP, FastAPI, Django, Flask, Pydantic|Alta
22|Qualidade|testing-qa|Testing / QA|pytest, fixtures, mocks, unit e integration tests|Alta
23|Dados|data-engineering|Data Engineering|Pandas, NumPy, ETL, Airflow, processamento em lote, idempotência|Média
24|Operação|cloud-deployment|Cloud / Deployment|AWS, Azure, Docker, Kubernetes, CI/CD|Alta
25|Segurança|security|Security|Authentication, Authorization, JWT, OAuth2, secrets, validação de entrada, injeção SQL, dependências vulneráveis|Alta
26|Qualidade|code-quality|Code Quality|Type Hints, Ruff, Black, PEP 8, clean code, SOLID, injeção de dependência|Alta
27|Arquitetura|system-design|System Design|Escalabilidade, cache, filas, load balancing, consistência, particionamento, design de APIs|Alta
28|SO / Infra|linux-so|Linux / SO|Processos, threads, file descriptors, signals, strace, lsof, /proc, cgroups, systemd|Alta
29|Operação|performance-profiling|Performance e profiling|cProfile, timeit, py-spy, memory profiling, vetorização, alocações|Alta
30|Operação|observabilidade|Observabilidade|Logs estruturados, métricas (Prometheus), tracing (OpenTelemetry), SLIs/SLOs|Alta
31|Operação|resiliencia|Resiliência|Retries com backoff e jitter, timeouts, circuit breaker, idempotência, graceful shutdown|Alta
32|Operação|debugging|Debugging e troubleshooting|Reproduzir bug, ler traceback, isolar causa, incidente em produção|Média-alta
33|Operação|packaging-ambiente|Packaging e ambiente|pyproject.toml, venv, uv/poetry, lock files, versionamento semântico|Média
34|Colaboração|git-colaboracao|Git e colaboração|Rebase vs merge, revisão de PR, conflitos, branching|Média
35|IA / Dados|engenharia-dados-ia|Engenharia de dados e ML/IA|Pipelines, schema evolution, MLOps básico, avaliação de modelos, chamadas a LLMs (custo, latência, retries, fallback)|Média (alta para vagas de IA)
36|Comportamental|comportamental-star|Comportamental (STAR)|Conflitos, decisões difíceis, liderança técnica, mentoria, incidentes|Alta
EOF

# Exemplos de projeto e problema, usados para preencher as categorias.
# Formato: categoria_pasta|exemplo_projeto|exemplo_problema
read -r -d '' EXEMPLOS <<'EOF' || true
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

# Retorna 0 se o arquivo pode ser (re)escrito pelo script:
#   - não existe;
#   - tem a marca deste script;
#   - é o README padrão do criar_pastas_treino.sh, sem nenhuma alteração.
# Qualquer outro conteúdo é tratado como trabalho seu e preservado.
pode_escrever() {
    local arq="$1"
    [[ ! -f "$arq" ]] && return 0
    # Gerado por este script: marca no início E no fim. Se você acrescentar
    # texto depois, a última linha deixa de ser a marca de fim e o arquivo é preservado.
    if [[ "$(head -n 1 "$arq")" == "$MARCA_GERADO" && "$(tail -n 1 "$arq")" == "$MARCA_FIM" ]]; then
        return 0
    fi

    # README padrão do criar_pastas_treino.sh: "# <pasta>", linha vazia e a linha "Subpastas: ..."
    local nome_pasta
    nome_pasta="$(basename "$(dirname "$arq")")"
    local esperado
    esperado="$(printf '# %s\n\nSubpastas: `problemas/`, `exercicios/`, `projetos/`.' "$nome_pasta")"
    [[ "$(cat "$arq")" == "$esperado" ]]
}

gerados=0
ignorados=0

# ---------- README de cada categoria ----------
while IFS='|' read -r num tipo pasta nome desafios prioridade; do
    [[ -z "$pasta" ]] && continue
    dir="$DESTINO/$pasta"
    arq="$dir/README.md"

    if [[ ! -d "$dir" ]]; then
        echo "AVISO: pasta ausente, pulando: $pasta"
        continue
    fi

    if ! pode_escrever "$arq"; then
        echo "IGNORADO (editado manualmente): $pasta/README.md"
        ignorados=$((ignorados + 1))
        continue
    fi

    ex_proj=""; ex_prob=""
    while IFS='|' read -r c p pr; do
        if [[ "$c" == "$pasta" ]]; then
            ex_proj="$p"; ex_prob="$pr"
        fi
    done <<< "$EXEMPLOS"

    {
        echo "$MARCA_GERADO"
        echo "# $nome"
        echo
        echo "| Campo | Valor |"
        echo "|---|---|"
        echo "| Tipo | $tipo |"
        echo "| Prioridade (sênior) | $prioridade |"
        echo "| Número na lista | $num |"
        echo
        echo "## Desafios e conhecimentos"
        echo
        echo "$desafios"
        echo
        echo "## Estrutura"
        echo
        echo "- \`problemas/\`: desafios algorítmicos curtos"
        echo "- \`exercicios/\`: tarefas focadas em um conceito"
        echo "- \`projetos/\`: programas completos"
        echo
        echo "## Exemplos iniciais"
        echo
        echo "- Problema: \`problemas/$ex_prob/\`"
        echo "- Projeto: \`projetos/$ex_proj/\`"
        echo
        echo "## Progresso"
        echo
        echo "| Item | Status | Data |"
        echo "|---|---|---|"
        echo "| $ex_prob | pendente | |"
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
        echo "# Índice: preparação para entrevistas (Python)"
        echo
        echo "Lista unificada de categorias, com tipo, prioridade para nível sênior e links para cada pasta."
        echo
        echo "| # | Tipo | Categoria | Desafios e conhecimentos | Prioridade |"
        echo "|---|---|---|---|---|"
        while IFS='|' read -r num tipo pasta nome desafios prioridade; do
            [[ -z "$pasta" ]] && continue
            echo "| $num | $tipo | [$nome]($pasta/README.md) | $desafios | $prioridade |"
        done <<< "$TABELA"
        echo
        echo "## Legenda de prioridade"
        echo
        echo "- **Alta**: base de quase toda entrevista, ou diferencial de sênior. Estude primeiro."
        echo "- **Média**: aparece com frequência, depende da vaga."
        echo "- **Baixa**: relevante para vagas específicas (ex.: dados, matemática)."
        echo
        echo "$MARCA_FIM"
    } > "$index"
    echo "INDEX.md gerado: $index"
else
    echo "IGNORADO (editado manualmente): INDEX.md"
    ignorados=$((ignorados + 1))
fi

echo "README.md gerados: $gerados"
echo "Arquivos preservados: $ignorados"