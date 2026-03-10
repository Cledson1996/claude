# JusCash — Claude Code Setup

Skills, agents e regras globais para o Claude Code no time da JusCash.

## Setup

```bash
git clone https://github.com/Juscash/claude.git
cd claude
bash setup.sh
```

O script instala automaticamente:
- **CLAUDE.md global** — regras que valem para todos os projetos
- **Skills** — comandos personalizados
- **MCP ai-coders-context** — contexto e workflows

## Skills

| Comando | O que faz |
|---------|-----------|
| `/commit` | Gera commit no padrao Conventional Commits com Jira ID da branch |
| `/pr` | Cria PR com template padronizado e contexto do card Jira |
| `/review` | Code review completo da branch — padroes, imports, testes e requisitos do Jira |
| `/docs` | Gera docs em MD na pasta `docs/` e sincroniza com o Confluence (espaco Tech) |
| `/context` | Gera contexto do projeto (CLAUDE.md + .context/) |
| Design System | Ativo automaticamente ao criar UI — usa `@juscash/design-system` |

## Regras globais (CLAUDE.md)

- Commits: `type(scope): descricao (TASK-ID)`
- PRs: template com Jira
- UI: sempre importar de `@juscash/design-system`
- Icones: `LucideIcons` (nunca `@ant-design/icons`)
- Idioma: portugues
- Sem assinatura do Claude em nada

## Estrutura

```
claude/
├── CLAUDE.md           # Regras globais (copiado para ~/.claude/)
├── setup.sh            # Script de instalacao
├── skills/
│   ├── commit.md       # /commit
│   ├── pull-request.md # /pr
│   ├── review.md       # /review
│   ├── docs.md         # /docs
│   ├── context.md      # /context
│   └── design-system.md # regras de UI
└── agents/
    └── (em breve)
```

## Atualizar

Para pegar novas skills ou atualizar regras:

```bash
cd claude
git pull
bash setup.sh
```
