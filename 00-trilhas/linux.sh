#!/usr/bin/env bash
# criar_estrutura_linux.sh
# Cria a estrutura de preparação para entrevistas técnicas de Linux:
#   - uma pasta por categoria, com problemas/, exercicios/ e projetos/
#   - exemplos de problema, exercício e projeto dentro de cada subpasta
#   - README.md em cada categoria e INDEX.md na raiz
#
# Uso:
#   ./criar_estrutura_linux.sh [DIRETORIO_DESTINO]
#
# Padrão: ./linux-entrevistas
#
# Segurança: rodar de novo nunca apaga nada. Um README.md só é reescrito se for
# gerado por este script e não tiver sido alterado. Edições manuais são preservadas.

set -euo pipefail

DESTINO="${1:-./linux-entrevistas}"
MARCA_GERADO="<!-- gerado por criar_estrutura_linux.sh -->"
MARCA_FIM="<!-- fim do arquivo gerado -->"

# Formato: num|slug|nome|desafios|prioridade|exemplo_projeto|exemplo_problema|exemplo_exercicio
# Prioridade é uma sugestão para nível sênior, não uma regra.
read -r -d '' TABELA <<'EOF' || true
1|linux-fundamentals|Linux Fundamentals|Kernel, distributions, filesystem, boot process|Média|relatorio-sistema-bash|identificar-distro-e-kernel|mapear-fases-do-boot
2|filesystem|Filesystem|/etc, /var, /home, /proc, /sys, FHS|Média|auditoria-fhs|encontrar-onde-fica-arquivo|diferenca-var-e-usr
3|file-management|File Management|ls, find, locate, stat, cp, mv, rm|Alta|organizador-downloads|encontrar-arquivos-grandes|find-com-tempo-e-tamanho
4|permissions|Permissions|chmod, chown, umask, ACL, sudo|Alta|auditoria-suid-sgid|corrigir-permissao-diretorio-compartilhado|calcular-umask
5|users-groups|Users / Groups|useradd, usermod, passwd, groupadd|Alta|provisionamento-usuarios-csv|bloquear-conta-expirada|adicionar-grupo-sem-perder-outros
6|process-management|Process Management|ps, top, htop, kill, nice, jobs|Alta|watchdog-processo|matar-processo-travado|jobs-fg-bg-nohup
7|services-systemd|Services / systemd|systemctl, units, targets, services|Alta|unidade-systemd-customizada|servico-nao-inicia-no-boot|override-com-systemctl-edit
8|logs-troubleshooting|Logs / Troubleshooting|journalctl, /var/log, dmesg, logrotate|Alta|analisador-journal-erros|diagnosticar-disco-cheio-por-log|filtrar-journalctl-por-tempo
9|networking|Networking|ip, ss, ping, traceroute, DNS, routing|Alta|diagnostico-conectividade|sem-internet-mas-ping-no-gateway|adicionar-rota-estatica
10|storage-management|Storage Management|fdisk, parted, lsblk, blkid, mount|Média|relatorio-discos-montagens|montar-disco-por-uuid|particionar-com-parted
11|lvm-raid|LVM / RAID|PV, VG, LV, RAID 0/1/5/10|Média|provisionar-lvm-com-snapshot|estender-lv-online|criar-raid1-mdadm
12|package-management|Package Management|apt, dpkg, dnf, rpm|Alta|repositorio-local-pacotes|descobrir-pacote-do-arquivo|instalar-deb-com-dependencias
13|ssh-remote-access|SSH / Remote Access|ssh, ssh-keygen, sshd, SCP, SFTP|Alta|hardening-sshd|acesso-ssh-recusado|tunel-ssh-local
14|security|Security|SELinux, AppArmor, firewall, SSH hardening|Alta|script-hardening-basico|portas-abertas-inesperadas|configurar-ufw-regras
15|scheduling|Scheduling|cron, crontab, systemd timers|Média|backup-agendado-systemd-timer|cron-nao-executa|escrever-expressao-cron
16|performance|Performance|CPU, RAM, swap, I/O, load average|Alta|coletor-metricas-sar|load-alto-com-cpu-ociosa|interpretar-vmstat
17|boot-recovery|Boot / Recovery|GRUB, initramfs, rescue mode|Alta|runbook-recuperacao-grub|sistema-nao-inicia-fstab-errado|entrar-em-rescue-mode
18|dns-dhcp|DNS / DHCP|BIND9, dig, nslookup, DHCP|Média|servidor-dns-interno-bind|nome-nao-resolve|consultar-com-dig
19|web-services|Web Services|Apache, Nginx, reverse proxy, TLS|Média|nginx-proxy-reverso-tls|502-bad-gateway|redirect-http-para-https
20|containers|Containers|Docker, Podman, namespaces, cgroups|Alta|ambiente-docker-com-volumes|container-sem-acesso-a-rede|inspecionar-namespaces
21|linux-automation|Linux Automation|Bash, Python, Ansible|Alta|playbook-ansible-hardening|script-nao-idempotente|funcao-bash-com-tratamento-de-erro
22|kernel-advanced|Kernel / Advanced|modules, sysctl, kernel parameters|Média|ajuste-sysctl-rede|modulo-nao-carrega|ler-parametros-proc-sys
23|backup-recovery|Backup / Recovery|rsync, tar, snapshots, restore|Alta|backup-rsync-incremental|verificar-integridade-tar|restaurar-arquivo-unico
24|enterprise-linux|Enterprise Linux|RHEL, Ubuntu Server, Rocky Linux|Média|comparativo-rhel-ubuntu|diferencas-dnf-apt|identificar-release-e-suporte
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
        echo "- \`problemas/\`: cenário prático resolvido pelo terminal"
        echo "- \`exercicios/\`: tarefa curta focada em um comando ou conceito"
        echo "- \`projetos/\`: script, runbook ou playbook completo"
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
        echo "# Índice: preparação para entrevistas técnicas (Linux)"
        echo
        echo "Categorias com links para cada pasta. Prioridades são sugestões para nível sênior."
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