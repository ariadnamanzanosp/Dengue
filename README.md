Sí, aquí tienes una versión más bonita y lista para pegar como `README.md`:

````markdown
# Proyecto Dengue y Clima en México

Este proyecto fue realizado en 2024 y tiene como objetivo analizar la relación entre los casos de dengue en México y algunas variables climáticas, principalmente temperatura media y precipitación.

El proyecto integra bases de datos de dengue y clima para explorar patrones por entidad federativa, año y mes. Además, incluye visualizaciones, análisis exploratorio, regresiones lineales y modelos predictivos simples utilizando árbol de decisión y red neuronal.

## Descripción general

El análisis se enfoca en datos de México correspondientes a los años 2021, 2022 y 2023.  
A partir de estos datos, se buscó observar si existe una relación entre el comportamiento de los casos de dengue y las condiciones climáticas registradas en distintas entidades federativas.

El flujo general del proyecto fue:

1. Carga de datos mensuales de dengue
        ↓
2. Limpieza y filtrado de casos relevantes
        ↓
3. Unión de bases por año
        ↓
4. Agregación de variables de fecha, mes y año
        ↓
5. Conversión de claves de entidad federativa a nombres de estados
        ↓
6. Integración con datos de temperatura y precipitación
        ↓
7. Análisis exploratorio y generación de visualizaciones
        ↓
8. Aplicación de regresiones lineales por estado
        ↓
9. Entrenamiento de modelos predictivos:
   - Árbol de decisión
   - Red neuronal
````

## Estructura del proyecto


Proyecto_2/
│
├── Codigos/
│   ├── R/
│   │   ├── obtención_datos_dengue.R
│   │   ├── NUEVO.R
│   │   ├── resumen_por_año_dengue.R
│   │   ├── numero_casos_identidad_federativa.R
│   │   ├── base_datos_dengue_clima.R
│   │   ├── datos_regresión_lineal.R
│   │   ├── regresion_lineal_imagenes.R
│   │   ├── regresionlineal_ambos_clima.R
│   │   └── estandarizadovariableedo.R
│   │
│   ├── red.py
│   ├── arbol_edo.py
│   └── algunas_graficas.ipynb
│
├── Dengue/
│   ├── datos_por_año_dengue/
│   ├── dengue_temperaturas_datasets_r/
│   └── imagenes/
│
├── Temperaturas/
│   ├── Temp_Media_2021.csv
│   ├── Temp_Media_2022.csv
│   ├── Temp_Media_2023.csv
│   ├── Preci_mm_2021.csv
│   ├── Preci_mm_2022.csv
│   └── Preci_mm_2023.csv
│
└── diccionario_datos_dengue/


## Descripción de los códigos

### `obtención_datos_dengue.R`

Carga los archivos mensuales de dengue, filtra los casos relevantes y genera una base anual combinada.

### `NUEVO.R`

Integra bases anuales, agrega variables de fecha, mes y año, y reemplaza claves numéricas por nombres de entidades federativas.

### `resumen_por_año_dengue.R`

Genera un resumen del número de registros de dengue por año.

### `numero_casos_identidad_federativa.R`

Agrupa los casos por entidad federativa y año, y genera una gráfica comparativa.

### `base_datos_dengue_clima.R`

Une la información de dengue con los datos climáticos de temperatura media y precipitación.

### `datos_regresión_lineal.R`

Prepara bases por estado para aplicar regresiones entre dengue, temperatura y precipitación.

### `regresion_lineal_imagenes.R`

Genera gráficas de regresión lineal entre casos de dengue y temperatura media por estado.

### `regresionlineal_ambos_clima.R`

Genera gráficas comparando casos de dengue con temperatura media y precipitación.

### `estandarizadovariableedo.R`

Estandariza variables para compararlas en una misma escala y genera visualizaciones estáticas y animadas.

### `arbol_edo.py`

Entrena un modelo de árbol de decisión para clasificar resultados relacionados con dengue usando variables temporales, clínicas y geográficas.

### `red.py`

Entrena una red neuronal simple con TensorFlow/Keras para clasificación binaria.

### `algunas_graficas.ipynb`

Notebook de análisis exploratorio con gráficas, pruebas visuales y comparaciones entre variables.

## Tecnologías usadas

* R
* Python
* Pandas
* Scikit-learn
* TensorFlow / Keras
* ggplot2
* dplyr
* tidyr
* readr
* matplotlib
* seaborn

## Modelos utilizados

En el proyecto se aplicaron modelos básicos para explorar posibles patrones en los datos:

### Regresión lineal

Se utilizó para observar la relación entre casos de dengue y variables climáticas como temperatura media y precipitación.

### Árbol de decisión

Se utilizó como modelo de clasificación para explorar patrones en los datos de dengue por entidad federativa, año, mes y variables clínicas.

### Red neuronal

Se implementó una red neuronal simple con capas densas para realizar una clasificación binaria.

## Objetivo del análisis

El objetivo principal fue estudiar la relación entre los casos de dengue en México y el comportamiento de variables climáticas durante los años 2021, 2022 y 2023.

Este proyecto permite observar cómo pueden combinarse herramientas de programación, análisis estadístico, visualización de datos y modelos de aprendizaje automático para estudiar un problema de salud pública en México.

## Nota

Las rutas dentro de algunos códigos están escritas de forma local.
Para ejecutar el proyecto en otra computadora, es necesario modificar esas rutas por rutas relativas o adaptarlas a la ubicación de los archivos.

## Descripción corta del repositorio

Análisis de casos de dengue en México y su relación con temperatura y precipitación usando R, Python, visualización de datos, regresión lineal, árbol de decisión y red neuronal.

```
```
