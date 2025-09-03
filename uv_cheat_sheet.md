# 🐍 UV Cheat Sheet

Um guia rápido para usar o **uv** – gerenciador de pacotes Python rápido.

---

## 📦 Instalação

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## 🎯 Comandos Principais

### Criar e Gerenciar Projetos

```bash
uv init my-project       # cria novo projeto com pyproject.toml
uv add requests          # adiciona uma dependência
uv remove requests       # remove uma dependência
uv sync                  # instala/atualiza dependências
```

### Ambientes Virtuais

```bash
uv venv                  # cria ambiente virtual
uv run python main.py    # roda um script no ambiente
uv python install 3.11   # instala Python 3.11 via uv
uv python list           # lista versões do Python instaladas
uv python pin 3.12       # fixa versão do Python no projeto
```

### Rodando Comandos

```bash
uv run pytest            # roda comando no ambiente virtual
uv run jupyter lab       # roda jupyter no venv
```

### Dependências

```bash
uv add flask==3.0        # instala versão específica
uv add "django>=5.0"     # instala versão mínima
uv pip list              # lista pacotes instalados
uv lock                  # gera/atualiza uv.lock
```

---

## ⚡️ Fluxo de Trabalho Padrão

```bash
uv init my-project       # cria novo projeto
cd my-project
uv python install 3.12   # instala versão desejada do Python
uv venv                  # cria ambiente virtual
uv add requests pytest   # adiciona dependências
uv run pytest            # roda testes no ambiente
```

---

## 🔧 Dicas Rápidas

- `uv` é compatível com `pip`, `venv` e `virtualenv`, mas é muito mais rápido 🚀
- O arquivo `uv.lock` garante builds reprodutíveis
- Use `uv run <comando>` para rodar qualquer comando no venv sem ativar manualmente

---

## 🐧 Aliases para UV (bash/zsh)

Adicione ao seu `~/.bashrc` ou `~/.zshrc`:

```bash
# atalhos UV
alias uvp="uv run python"      # roda python direto
alias uvr="uv run"             # roda comando no venv
alias uva="uv add"             # adiciona dependência
alias uvrm="uv remove"         # remove dependência
alias uvs="uv sync"            # instala/atualiza deps
alias uvpl="uv pip list"       # lista pacotes
alias uvl="uv lock"            # gera lockfile
alias uvpy="uv python list"    # lista v ersões do Python
```

Depois recarregue o shell:

```bash
source ~/.zshrc   # ou ~/.bashrc
```

Exemplo de uso:

```bash
uva requests
uvp script.py
uvr pytest
```
