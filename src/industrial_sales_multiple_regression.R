source("packages.R")

dir.create("outputs", showWarnings = FALSE, recursive = TRUE)

sales <- read.delim(file.path("data", "raw", "industrial_sales.txt"), encoding = "UTF-8")
sales_adjusted <- read.delim(file.path("data", "raw", "industrial_sales_adjusted.txt"), encoding = "UTF-8")
names(sales) <- tolower(gsub("_+", "_", gsub("[^[:alnum:]]+", "_", iconv(names(sales), to = "ASCII//TRANSLIT"))))
names(sales_adjusted) <- tolower(gsub("_+", "_", gsub("[^[:alnum:]]+", "_", iconv(names(sales_adjusted), to = "ASCII//TRANSLIT"))))

correlation_matrix <- cor(sales)
write.csv(correlation_matrix, file.path("outputs", "correlation_matrix.csv"))

models <- list(
  model_1 = lm(vendas ~ wonder + sc + experiencia + engenheiro, data = sales),
  model_2 = lm(vendas ~ wonder + sc + experiencia, data = sales),
  model_3 = lm(vendas ~ wonder + sc, data = sales),
  model_4 = lm(vendas ~ wonder, data = sales),
  model_5 = lm(vendas ~ sc + experiencia + engenheiro, data = sales),
  model_6 = lm(vendas ~ sc + experiencia, data = sales),
  model_7 = lm(vendas ~ sc + engenheiro, data = sales),
  model_8 = lm(vendas ~ sc, data = sales)
)

comparison <- data.frame(
  model = names(models),
  r_squared = vapply(models, function(x) summary(x)$r.squared, numeric(1))
)

write.csv(comparison, file.path("outputs", "model_comparison.csv"), row.names = FALSE)

selected_models <- c("model_1", "model_5", "model_7")
for (name in selected_models) {
  model <- models[[name]]
  capture.output(summary(model), file = file.path("outputs", paste0(name, "_summary.txt")))
  capture.output(shapiro.test(model$residuals), file = file.path("outputs", paste0(name, "_shapiro.txt")))
  capture.output(lmtest::bptest(model), file = file.path("outputs", paste0(name, "_breusch_pagan.txt")))
  capture.output(lmtest::dwtest(model), file = file.path("outputs", paste0(name, "_durbin_watson.txt")))
}

png(file.path("outputs", "sales_corrplot.png"), width = 1200, height = 800)
corrplot::corrplot(correlation_matrix, method = "number", diag = FALSE)
dev.off()

png(file.path("outputs", "model_1_diagnostics.png"), width = 1400, height = 1000)
par(mfrow = c(2, 2))
hist(models$model_1$residuals, main = "Residuos", col = "gray80", border = "white")
plot(models$model_1$fitted.values, models$model_1$residuals, pch = 19, col = "steelblue", main = "Residuos x Ajustados")
qqnorm(models$model_1$residuals, main = "QQ-Plot")
qqline(models$model_1$residuals, col = "firebrick")
plot(sales$sc, sales$vendas, pch = 19, col = "darkgreen", main = "SC x Vendas")
par(mfrow = c(1, 1))
dev.off()

sales$vendas2 <- sales$vendas ^ 1.2
boxcox_model <- lm(vendas2 ~ wonder + sc + experiencia + engenheiro, data = sales)
adjusted_model <- lm(vendas ~ wonder + sc + experiencia + engenheiro, data = sales_adjusted)

capture.output(summary(boxcox_model), file = file.path("outputs", "boxcox_summary.txt"))
capture.output(summary(adjusted_model), file = file.path("outputs", "adjusted_dataset_summary.txt"))

cat("Regressao multipla concluida. Arquivos gerados em outputs/.\n")
