#!/bin/bash
# JusCash — Setup do Claude Code
# Instala CLAUDE.md global + skills para o dev

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/commands"

echo "=== JusCash Claude Code Setup ==="
echo ""

# 1. Criar diretorio ~/.claude se nao existir
if [ ! -d "$CLAUDE_DIR" ]; then
  mkdir -p "$CLAUDE_DIR"
  echo "[+] Criado $CLAUDE_DIR"
else
  echo "[ok] $CLAUDE_DIR ja existe"
fi

# 2. Copiar CLAUDE.md global
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  echo "[!] CLAUDE.md global ja existe. Fazendo backup..."
  cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
fi
cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
echo "[+] CLAUDE.md global instalado"

# 3. Copiar skills (comandos ficam em ~/.claude/commands/)
mkdir -p "$SKILLS_DIR"
SKILL_COUNT=0
for skill in "$SCRIPT_DIR/skills/"*.md; do
  filename=$(basename "$skill")
  if [ "$filename" = "exemplo-skill.md" ]; then
    continue
  fi
  cp "$skill" "$SKILLS_DIR/$filename"
  SKILL_COUNT=$((SKILL_COUNT + 1))
  echo "    -> $filename"
done
echo "[+] $SKILL_COUNT commands instalados em $SKILLS_DIR"

# 4. Copiar agents
AGENTS_DIR="$CLAUDE_DIR/agents"
mkdir -p "$AGENTS_DIR"
AGENT_COUNT=0
if ls "$SCRIPT_DIR/agents/"*.md 2>/dev/null | grep -v "exemplo-agent.md" > /dev/null; then
  for agent in "$SCRIPT_DIR/agents/"*.md; do
    filename=$(basename "$agent")
    if [ "$filename" = "exemplo-agent.md" ]; then
      continue
    fi
    cp "$agent" "$AGENTS_DIR/$filename"
    AGENT_COUNT=$((AGENT_COUNT + 1))
    echo "    -> $filename"
  done
fi
echo "[+] $AGENT_COUNT agents instalados em $AGENTS_DIR"

# 5. Instalar MCP ai-coders-context
echo ""
echo "[...] Instalando MCP ai-coders-context..."
if npx @ai-coders/context mcp:install 2>/dev/null; then
  echo "[+] MCP ai-coders-context instalado"
else
  echo "[!] Falha ao instalar MCP (pode precisar de Node.js 20+)"
fi

# 6. Resumo
echo ""
echo "=== Setup completo ==="
echo ""
echo "Instalado:"
echo "  - CLAUDE.md global em $CLAUDE_DIR/CLAUDE.md"
echo "  - $SKILL_COUNT commands em $SKILLS_DIR/"
echo "  - $AGENT_COUNT agents em $AGENTS_DIR/"
echo "  - MCP ai-coders-context"
echo ""
echo "Skills disponiveis:"
echo "  /start-feature — inicia feature: card Jira + branch + plano"
echo "  /feature-done  — workflow completo: review + docs + commit + PR"
echo "  /commit       — commit padronizado com Jira ID"
echo "  /pr           — PR com template e contexto Jira"
echo "  /review       — code review da branch antes de abrir PR"
echo "  /docs         — gera docs locais e sincroniza com Confluence"
echo "  /context      — gerar contexto do projeto"
echo ""
echo "Agents disponiveis:"
echo "  @qa-agent         — review profundo + testes + criterios Jira"
echo "  @devops-agent     — checklist de deploy: env vars, migrations, rollback"
echo "  @onboarding-agent — apresenta o projeto ao dev novo"
echo ""
echo "Reinicie o Claude Code para aplicar as mudancas."
