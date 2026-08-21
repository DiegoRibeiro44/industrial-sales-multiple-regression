# Industrial Sales Multiple Regression

Projeto em **R** para regressão linear múltipla aplicada a vendas de dispositivos de instrumentação industrial. Ajusta e compara vários modelos e valida os resíduos com diagnósticos clássicos.

## Problema resolvido

Identificar quais variáveis de negócio explicam as vendas, comparando modelos com diferentes combinações de preditores.

## O que o script entrega

- matriz de correlação entre as variáveis;
- ajuste e comparação de 8 modelos por R²;
- diagnósticos de resíduos (Shapiro-Wilk, Breusch-Pagan, Durbin-Watson) para os modelos selecionados;
- experimentos com transformação da variável resposta e com uma base ajustada.

## Stack

- R (>= 4.0)
- corrplot
- lmtest

## Estrutura

```text
industrial-sales-multiple-regression/
├── README.md
├── packages.R
├── data/
│   └── raw/
│       ├── industrial_sales.txt            # base principal (tab-delimitada)
│       └── industrial_sales_adjusted.txt   # base ajustada
├── docs/
│   └── problem_statement.docx              # enunciado original do exercício
├── outputs/
└── src/
    └── industrial_sales_multiple_regression.R
```

## Dados

As bases (`data/raw/*.txt`) acompanham o projeto e são versionadas — não é preciso baixar nada. O enunciado original do exercício está preservado em `docs/`.

## Como executar

A partir da **raiz do projeto**:

```bash
Rscript src/industrial_sales_multiple_regression.R
```

O `packages.R` instala automaticamente os pacotes necessários (`corrplot`, `lmtest`) a partir do CRAN.

## Resultado esperado

Arquivos gerados em `outputs/`:

- `correlation_matrix.csv`, `model_comparison.csv`;
- `model_1_summary.txt`, `model_5_summary.txt`, `model_7_summary.txt` e os respectivos `_shapiro.txt`, `_breusch_pagan.txt`, `_durbin_watson.txt`;
- `boxcox_summary.txt`, `adjusted_dataset_summary.txt`;
- `sales_corrplot.png`, `model_1_diagnostics.png`.
