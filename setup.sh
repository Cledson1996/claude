#!/bin/bash
# JusCash — Setup do Claude Code
# Instala CLAUDE.md global + skills para o dev

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"

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

# 3. Copiar skills
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
echo "[+] $SKILL_COUNT skills instaladas em $SKILLS_DIR"

# 4. Instalar MCP ai-coders-context
echo ""
echo "[...] Instalando MCP ai-coders-context..."
if npx @ai-coders/context mcp:install 2>/dev/null; then
  echo "[+] MCP ai-coders-context instalado"
else
  echo "[!] Falha ao instalar MCP (pode precisar de Node.js 20+)"
fi

# 5. Resumo
echo ""
echo "=== Setup completo ==="
echo ""
echo "Instalado:"
echo "  - CLAUDE.md global em $CLAUDE_DIR/CLAUDE.md"
echo "  - $SKILL_COUNT skills em $SKILLS_DIR/"
echo "  - MCP ai-coders-context"
echo ""
echo "Skills disponiveis:"
echo "  /feature-done — workflow completo: review + docs + commit + PR"
echo "  /commit       — commit padronizado com Jira ID"
echo "  /pr           — PR com template e contexto Jira"
echo "  /review       — code review da branch antes de abrir PR"
echo "  /docs         — gera docs locais e sincroniza com Confluence"
echo "  /context      — gerar contexto do projeto"
echo ""
echo "Reinicie o Claude Code para aplicar as mudancas."
