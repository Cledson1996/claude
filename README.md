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
- **Skills** — comandos personalizados (instalados em `~/.claude/commands/`)
- **MCP ai-coders-context** — contexto e workflows

## Skills

| Comando | O que faz |
|---------|-----------|
| `/start-feature` | Inicia uma feature — busca card Jira, cria branch com ID e sugere plano |
| `/feature-done` | Workflow completo pos-feature: review → docs → commit → PR |
| `/commit` | Gera commit no padrao Conventional Commits com Jira ID da branch |
| `/pr` | Cria PR com template padronizado e contexto do card Jira |
| `/review` | Code review completo da branch — padroes, imports, testes e requisitos do Jira |
| `/docs` | Gera docs em MD na pasta `docs/` e sincroniza com o Confluence (espaco Tech) |
| `/context` | Gera contexto do projeto (CLAUDE.md + .context/) |
| Design System | Ativo automaticamente ao criar UI — usa `@juscash/design-system` |

## Agents

| Agent | O que faz |
|-------|-----------|
| `@qa-agent` | Review profundo — cobertura de testes, criterios do Jira, qualidade e seguranca |
| `@devops-agent` | Checklist de deploy — env vars, migrations, breaking changes e plano de rollback |
| `@onboarding-agent` | Apresenta o projeto ao dev novo e responde duvidas sobre arquitetura e padroes |

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
│   ├── start-feature.md # /start-feature
│   ├── feature-done.md # /feature-done
│   ├── commit.md       # /commit
│   ├── pull-request.md # /pr
│   ├── review.md       # /review
│   ├── docs.md         # /docs
│   ├── context.md      # /context
│   └── design-system.md # regras de UI
└── agents/
    ├── qa-agent.md       # @qa-agent
    ├── devops-agent.md   # @devops-agent
    └── onboarding-agent.md # @onboarding-agent
```

## Atualizar

Para pegar novas skills ou atualizar regras:

```bash
cd claude
git pull
bash setup.sh
```
