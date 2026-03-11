---
name: docs
description: "Gera documentacao tecnica em docs/ e sincroniza com Confluence (espaco Tech). Usar apos implementar uma feature."
disable-model-invocation: true
---

# Skill: Docs

Gera ou atualiza documentação técnica na pasta `docs/` do projeto (fonte de verdade, versionada no git) e sincroniza com o Confluence no espaço **Tech (DT)**.

## Uso

```
/docs
```

## Instruções para o Claude

Quando o usuário executar `/docs`, siga estes passos:

### Passo 1 — Entender o que foi implementado

Execute em paralelo:
- `git branch --show-current` — branch atual
- `git diff {BASE}...HEAD --stat` — arquivos alterados
- `git diff {BASE}...HEAD` — diff completo

Se houver TASK-ID na branch (regex: letras maiúsculas + hífen + números, ex: `ENG-123`):
1. Usar `getAccessibleAtlassianResources` para obter o `cloudId`
2. Usar `getJiraIssue` para buscar o card: `summary`, `description`, `issuetype.name`
3. Extrair da descrição: o que foi implementado, contexto de negócio, critérios técnicos

Se não encontrar TASK-ID ou card Jira, continuar sem esse contexto.

### Passo 2 — Detectar tipo do projeto

Analise os arquivos do projeto para identificar o tipo:

| Tipo | Critérios de detecção |
|------|----------------------|
| **Node.js/TypeScript** | `package.json` com NestJS, Express, Fastify; arquivos `.ts` em `src/` |
| **Python** | `requirements.txt`, `pyproject.toml`, `poetry.lock`, arquivos `.py` |
| **Frontend** | `package.json` com React, Vue, Next.js; `src/components/`, `src/pages/` |
| **EDA (Event-Driven)** | Presença de filas (SQS, RabbitMQ, Kafka), eventos, consumers, producers |

Um projeto pode ser múltiplos tipos (ex: Node.js + EDA).

### Passo 3 — Verificar docs existentes

1. Verificar se a pasta `docs/` existe na raiz do projeto
2. Listar arquivos `.md` existentes em `docs/`
3. Com base no diff e no tipo do projeto, identificar quais arquivos precisam ser criados ou atualizados

**Estrutura padrão de `docs/`:**
```
docs/
├── README.md              → visão geral e setup do projeto
├── architecture.md        → arquitetura, decisões técnicas, fluxo de dados
├── api.md                 → endpoints e contratos (se aplicável)
├── deploy.md              → processo de deploy, ambientes, variáveis
├── modules/
│   └── {modulo}.md        → doc por módulo alterado na feature
└── changelog.md           → histórico de mudanças por feature/sprint
```

### Passo 4 — Gerar/atualizar os arquivos MD locais

Para cada arquivo de docs afetado, gerar conteúdo em Markdown seguindo o template padrão da JusCash para o tipo detectado:

---

**Template: Backend Node.js / TypeScript**

```markdown
# {Nome do Projeto}

## 1. Introdução
Breve descrição do serviço, propósito e contexto de negócio.

## 2. Arquitetura
Visão geral da arquitetura, padrões utilizados (ex: Clean Architecture, DDD), camadas do sistema.

## 3. Instalação e Configuração
Pré-requisitos, variáveis de ambiente necessárias, como rodar localmente.

## 4. Estrutura de Pastas
Descrição das pastas principais e o que cada uma contém.

## 5. Módulos
Descrição de cada módulo/domínio do sistema, responsabilidades, entidades.

## 6. Banco de Dados
Schema, migrations, decisões de modelagem.

## 7. Filas e Eventos (se aplicável)
Filas utilizadas, eventos publicados/consumidos, fluxo de mensagens.

## 8. Logs e Monitoramento
Padrão de logs, como interpretar, ferramentas de observabilidade.

## 9. Integrações
Serviços externos integrados, como funcionam, contratos.

## 10. Segurança
Autenticação, autorização, proteções implementadas.

## 11. Deploy
Ambientes (dev, staging, prod), processo de deploy, variáveis de ambiente por ambiente.

## 12. Desenvolvimento
Comandos úteis, fluxo de trabalho, como rodar testes.

## 13. Troubleshooting
Problemas comuns e como resolver.

## 14. Referências
Links úteis, ADRs, decisões técnicas documentadas.
```

---

**Template: Backend Python**

```markdown
# {Nome do Projeto}

## 1. Introdução
Breve descrição do serviço, propósito e contexto de negócio.

## 2. Arquitetura
Visão geral da arquitetura, padrões utilizados, camadas do sistema.

## 3. Instalação e Configuração
Pré-requisitos (Python version, Poetry/pip), variáveis de ambiente, como rodar localmente.

## 4. Estrutura de Pastas
Descrição das pastas principais.

## 5. Módulos
Módulos/pacotes principais, responsabilidades.

## 6. Banco de Dados
Schema, migrations (Alembic, Django migrations, etc.), modelos.

## 7. Filas e Eventos (se aplicável)
Filas, workers, Celery tasks, eventos.

## 8. Logs e Monitoramento
Padrão de logs, ferramentas.

## 9. Integrações
Serviços externos.

## 10. Segurança
Autenticação, autorização.

## 11. Deploy
Ambientes, processo de deploy, Dockerfile, variáveis de ambiente.

## 12. Desenvolvimento
Comandos, testes, linting.

## 13. Troubleshooting
Problemas comuns.

## 14. Referências
Links e decisões técnicas.
```

---

**Template: EDA (Event-Driven Architecture)**

```markdown
# {Nome do Fluxo / Serviço}

## Diagrama
[Incluir diagrama do fluxo de eventos se disponível]

## Descrição do Fluxo
O que este fluxo representa no contexto de negócio.

## Trigger / Gatilho
O que inicia este fluxo (evento, API call, scheduler, etc.)

## Evento Inicial
Nome do evento, payload esperado, quem o publica.

## Serviços / Módulos Envolvidos
Lista de serviços que participam do fluxo, suas responsabilidades.

## Serviços Externos
Integrações com sistemas externos (pagamento, notificação, etc.)

## Tratamento de Erros
Como erros são tratados, filas de dead-letter, retries.

## Monitoramento
Como monitorar este fluxo em produção.
```

---

Ao gerar ou atualizar um arquivo:
- Manter o que já existe e atualizar apenas o que mudou com a feature atual
- Adicionar uma entrada no `changelog.md` descrevendo o que foi implementado
- Usar linguagem técnica clara, em **português**
- Incluir exemplos de código ou payload quando relevante
- Referenciar o TASK-ID do Jira na entrada do changelog

### Passo 5 — Apresentar resultado local e perguntar sobre Confluence

Após gerar os MDs locais, mostrar ao usuário:

```
Docs geradas/atualizadas em docs/:
- docs/modules/auth.md (criado)
- docs/api.md (atualizado)
- docs/changelog.md (atualizado)

Quer sincronizar com o Confluence?
Se sim, para cada arquivo informe qual página do Confluence atualizar
(ou se quer criar uma nova página — informe o nome e onde ficará).
```

Aguardar resposta do usuário antes de prosseguir com o Confluence.

### Passo 6 — Sincronizar com Confluence (se o usuário confirmar)

Para cada arquivo que o usuário quiser publicar:

1. **Buscar a página**: usar `searchConfluenceUsingCql` com:
   ```
   space = "DT" AND title ~ "{nome-da-página}"
   ```
   - Cloud ID: `63422ba0-3fba-4a86-916a-7a6abc3fb31f`

2. **Se a página existir** → usar `updateConfluencePage` com:
   - `cloudId`: `63422ba0-3fba-4a86-916a-7a6abc3fb31f`
   - `pageId`: ID encontrado na busca
   - `body`: conteúdo do arquivo MD
   - `contentFormat`: `"markdown"`

3. **Se a página não existir** → perguntar ao usuário:
   - "Quer criar uma nova página no Confluence? Em qual seção/página pai ela deve ficar?"
   - Após confirmar → usar `createConfluencePage` com:
     - `cloudId`: `63422ba0-3fba-4a86-916a-7a6abc3fb31f`
     - `spaceId`: `164069` (espaço Tech / DT)
     - `title`: nome da página
     - `parentId`: ID da página pai (informado pelo usuário)
     - `body`: conteúdo do MD
     - `contentFormat`: `"markdown"`

### Passo 7 — Confirmar resultado

Mostrar resumo final:

```
docs/modules/auth.md — salvo localmente
Confluence: "Auth Module" — sincronizado
  https://juscash.atlassian.net/wiki/spaces/DT/pages/...

docs/api.md — salvo localmente
Confluence: "API Reference" — sincronizado
  https://juscash.atlassian.net/wiki/spaces/DT/pages/...

Lembre-se de commitar os docs locais:
  git add docs/
  /commit
```

---

## Configuração Confluence

- **Cloud ID**: `63422ba0-3fba-4a86-916a-7a6abc3fb31f`
- **Espaço Tech**: key `DT`, id `164069`
- **URL base**: `https://juscash.atlassian.net/wiki`
- **Templates de referência**: espaço Interno, página `843415557`
