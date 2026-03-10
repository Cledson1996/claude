# JusCash — Regras Globais do Claude Code

Este arquivo configura o Claude Code para todos os projetos da JusCash.
Instalado automaticamente via `setup.sh`.

---

## Idioma
- Responder sempre em **portugues**

## Identidade
- Nunca adicionar `Co-Authored-By`, assinatura do Claude ou qualquer menção ao Claude em commits, PRs, código ou comentários
- O output deve parecer inteiramente do desenvolvedor

## Git — Commits
Padrão: **Conventional Commits** com Jira ID

```
type(scope): descrição curta (TASK-ID)
```

- **Tipos**: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`
- **scope**: inferido dos arquivos alterados (pasta/módulo principal)
- **TASK-ID**: extraído da branch atual (ex: `feature/ENG-123-desc` → `ENG-123`). Omitir se não encontrar.
- **Descrição**: imperativo em português ("adiciona", "corrige", "remove"), máx 72 chars

## Git — Pull Requests
Usar template padronizado com contexto do Jira. Executar `/pr` para gerar automaticamente.

## Design System
- Componentes UI: importar de `@juscash/design-system` (NUNCA do `antd` direto)
- Ícones: `LucideIcons` de `@juscash/design-system` (NUNCA `@ant-design/icons`)
- Storybook: https://juscash.github.io/design-system/
- Ao receber link do Figma, usar MCP Figma para extrair o design e mapear para componentes da biblioteca

## Jira
- Organização: https://juscash.atlassian.net
- Usar MCP Atlassian para buscar cards quando disponível
- Link de card: `https://juscash.atlassian.net/browse/{TASK-ID}`

## Contexto de projeto
- Se o projeto não tiver `CLAUDE.md` local, sugerir executar `/context` para gerar
- O MCP ai-coders-context está disponível para análises profundas

## Skills disponíveis
- `/commit` — gera mensagem de commit padronizada com Jira ID
- `/pr` — cria PR com template e contexto do Jira
- `/review` — code review completo da branch antes de abrir PR
- `/docs` — gera docs locais em `docs/` e sincroniza com Confluence
- `/context` — gera contexto do projeto (CLAUDE.md + .context/)
- Design System — ativo automaticamente ao criar componentes UI
