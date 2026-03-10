---
type: skill
name: Feature Done
description: Workflow completo pós-feature — review, docs, commit e PR em sequência
skillSlug: feature-done
phases: [C]
trigger: quando o usuário executar /feature-done após terminar uma feature
generated: 2026-03-10
status: filled
scaffoldVersion: "2.0.0"
---

# Skill: Feature Done

Workflow completo para finalizar uma feature. Encadeia `/review` → `/docs` → `/commit` → `/pr` em sequência, pausando nos pontos que precisam de decisão do usuário.

## Uso

```
/feature-done
```

## Instruções para o Claude

Quando o usuário executar `/feature-done`, siga estes passos:

### Setup inicial — coletar contexto compartilhado

Execute em paralelo antes de iniciar qualquer fase:
- `git branch -r` — listar branches remotas
- `git branch --show-current` — branch atual

Detectar branch base na ordem de prioridade:
- `origin/development` → usar `development`
- `origin/develop` → usar `develop`
- `origin/main` → usar `main`
- `origin/master` → usar `master`

Confirmar com o usuário:
```
Branch base detectada: `development`. Está correto? (ou informe outra)
```

Após confirmação, executar em paralelo:
- `git diff {BASE}...HEAD --stat` — arquivos alterados
- `git diff {BASE}...HEAD` — diff completo
- `git log {BASE}..HEAD --oneline` — commits da branch
- Se houver TASK-ID na branch (regex: `[A-Z]+-\d+`): usar `getAccessibleAtlassianResources` + `getJiraIssue` para buscar `summary`, `description`, `issuetype.name`

Se o diff estiver vazio: avisar "Nenhuma diferença em relação à `{BASE}`. Nada a fazer." e encerrar.

---

### Fase 1/4 — Review

Analisar o diff completo executando os 4 checks:

**Check A — Design System e Imports**
- Import direto de `antd`? → ❌ Blocker — deve ser `@juscash/design-system`
- Import de `@ant-design/icons`? → ❌ Blocker — deve ser `LucideIcons` de `@juscash/design-system`
- Imports relativos com muitos `../`? → ⚠️ Sugerir alias

**Check B — Padrões de código**
- `console.log`, `console.error`, `debugger` esquecidos? → ⚠️
- Funções com mais de 50 linhas? → ⚠️ Sugerir extração
- Código comentado / código morto? → ⚠️
- Lógica duplicada? → ⚠️
- Naming conventions inconsistentes? → ⚠️

**Check C — Testes**
- Arquivos de lógica de negócio modificados sem testes correspondentes (`*.test.*`, `*.spec.*`)? → ⚠️
- Novos fluxos ou funções públicas sem testes? → ⚠️
- Testes existentes quebrados pelas mudanças? → ❌ Blocker

**Check D — Segurança e qualidade**
- Tokens, senhas ou chaves de API hardcoded? → ❌ Blocker
- Variáveis de ambiente acessadas sem `process.env` ou sem fallback? → ⚠️
- Try/catch ausente em operações assíncronas críticas? → ⚠️
- Inputs sem validação? → ⚠️

Se card Jira encontrado: verificar cada critério de aceite no diff, marcar `[x]` ou `[ ]`.

**Apresentar relatório:**

```
--- Fase 1/4: Review ---

### Card Jira: {TASK-ID} — {título} ({tipo})
#### Requisitos do card
- [x] {critério implementado}
- [ ] {critério NÃO encontrado}

### ✅ Aprovado
- {checks que passaram}

### ⚠️ Atenção
- {arquivo} linha {N}: {problema}

### ❌ Bloqueadores
- {arquivo} linha {N}: {problema}
```

**Ponto de pausa — se houver blockers:**
```
❌ {N} blocker(s) encontrado(s). Corrija-os antes de continuar.
Quer que eu aplique as correções automaticamente?
Quando terminar, responda "continuar".
```

**Se não houver blockers:**
```
✅ Review aprovado — nenhum blocker.
Prosseguindo para Docs...
```

Para cada ⚠️, oferecer sugestão de correção. Perguntar se o usuário quer que sejam aplicadas automaticamente.

---

### Fase 2/4 — Docs

1. Detectar tipo do projeto pelos arquivos:
   - **Node.js/TypeScript**: `package.json` com NestJS/Express + arquivos `.ts`
   - **Python**: `requirements.txt`, `pyproject.toml`, arquivos `.py`
   - **Frontend**: `package.json` com React/Next.js + `src/components/`
   - **EDA**: filas (SQS, RabbitMQ, Kafka), consumers, producers

2. Verificar se `docs/` existe na raiz; listar `.md` existentes

3. Gerar/atualizar os arquivos MD afetados pelo diff, seguindo os templates da JusCash (Node.js, Python, EDA). Sempre:
   - Manter conteúdo existente, atualizar apenas o que mudou
   - Adicionar entrada no `docs/changelog.md` com o que foi implementado nesta feature (referenciar TASK-ID)
   - Linguagem técnica em português

**Ponto de pausa — Confluence:**
```
--- Fase 2/4: Docs ---

Docs atualizadas localmente:
- docs/modules/{modulo}.md (criado/atualizado)
- docs/changelog.md (atualizado)

Quer sincronizar com o Confluence?
Se sim, informe qual página do Confluence cada arquivo deve atualizar
(ou "nova" para criar uma nova página).
Se não, responda "pular".
```

Se confirmar: sincronizar via `updateConfluencePage` (se página existe) ou `createConfluencePage` (se nova).
- Cloud ID: `63422ba0-3fba-4a86-916a-7a6abc3fb31f`
- Espaço Tech: `DT`, spaceId: `164069`
- Usar `contentFormat: "markdown"`

---

### Fase 3/4 — Commit

1. Verificar staged: `git diff --cached --stat`

2. Se `docs/` foi alterada mas não está staged, perguntar:
   ```
   Os arquivos de docs/ não estão staged. Quer incluí-los no commit?
   ```

3. Extrair TASK-ID da branch, inferir `type` e `scope` pelos arquivos alterados, gerar mensagem:
   - `feat` — nova funcionalidade
   - `fix` — correção de bug
   - `refactor` — refatoração sem nova funcionalidade
   - `docs` — apenas documentação
   - `test` — apenas testes
   - `chore` / `style` — configuração, formatação

**Ponto de pausa:**
```
--- Fase 3/4: Commit ---

Mensagem sugerida:
  feat(auth): adiciona autenticação JWT com refresh token (ENG-123)

Confirma? (ou informe outra mensagem)
```

Após confirmação: executar `git commit -m "..."`.
- **Nunca adicionar Co-Authored-By, assinatura do Claude ou qualquer menção ao Claude**

---

### Fase 4/4 — PR

1. Verificar se branch tem remote:
   - `git status -sb` — se não tiver upstream, perguntar: "Branch sem remote. Quer fazer push agora?"
   - Se confirmar: `git push -u origin {branch}`

2. Gerar título e body do PR com template JusCash (contexto Jira já disponível do setup):

```markdown
## Descrição
{o que foi implementado — baseado no diff e na descrição do Jira}

## Tipo de mudança
- [ ] Bug fix
- [x] Nova feature
- [ ] Breaking change
- [ ] Documentação

## Como testar
{passos para testar a mudança}

## Checklist
- [x] Código revisado
- [x] Testes adicionados/atualizados
- [x] Documentação atualizada
- [ ] Aprovação do time

## Jira
[{TASK-ID}](https://juscash.atlassian.net/browse/{TASK-ID})
```

**Ponto de pausa:**
```
--- Fase 4/4: PR ---

Título: feat(auth): adiciona autenticação JWT com refresh token (ENG-123)

[preview do body acima]

Confirma a criação do PR?
```

Após confirmação: executar `gh pr create --title "..." --body "$(cat <<'EOF' ... EOF)"`.
- **Nunca adicionar Co-Authored-By, assinatura do Claude ou qualquer menção ao Claude**

---

### Resumo final

```
🚀 Feature Done!

✅ Fase 1 — Review: aprovado ({N} warnings)
✅ Fase 2 — Docs: atualizadas localmente + Confluence sincronizado
             (ou: Confluence pulado)
✅ Fase 3 — Commit: feat(auth): adiciona autenticação JWT (ENG-123)
✅ Fase 4 — PR: https://github.com/{org}/{repo}/pull/{N}

Card Jira: https://juscash.atlassian.net/browse/{TASK-ID}
```
