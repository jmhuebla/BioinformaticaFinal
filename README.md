
# Análisis Filogenético de Genes Metabólicos en Salmonidae: Implicaciones en Bioingeniería y Acuicultura

## Julissa Hu H.
## Julio, 2025

![Salmonidae Family](https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Salmonidae.jpg/800px-Salmonidae.jpg)

## Tabla de Contenidos
1. [Introducción](#introducción)  
2. [Genes de Estudio](#genes-de-estudio)  
   - [Tabla Comparativa](#tabla-comparativa-de-genes)  
3. [Relevancia en Bioingeniería](#relevancia-en-bioingeniería)  
4. [Metodología](#metodología)  
5. [Prerequisitos](#prerequisitos)  
6. [Resultados Esperados](#resultados-esperados)  
7. [Referencias](#referencias)  

## Introducción

Este proyecto investiga la evolución molecular de cuatro genes clave en la familia Salmonidae mediante análisis filogenéticos comparativos. Los genes estudiados (clrn2, coch, exoc1l y pomc) están involucrados en importantes procesos metabólicos y presentan adaptaciones evolutivas relevantes para la acuicultura moderna.

## Genes de Estudio

### Tabla Comparativa de Genes

| Gen     | Función Biológica                                                                 | Expresión Tisular         | Relevancia en Salmonidae                                                                 |
|---------|-----------------------------------------------------------------------------------|---------------------------|------------------------------------------------------------------------------------------|
| **clrn2** | Mantenimiento de la estructura celular en tejidos neurosensoriales                | Branquias, línea lateral | Adaptación a diferentes salinidades y calidades de agua                                  |
| **coch**  | Desarrollo y mantenimiento del sistema auditivo                                   | Oído interno             | Adaptación a diferentes presiones hidrodinámicas en ríos y océanos                       |
| **exoc1l**| Regulación del tráfico vesicular y secreción celular                              | Gónadas, hígado          | Relacionado con la maduración gonadal y producción de componentes del plasma seminal     |
| **pomc**  | Precursor de hormonas como ACTH (corticotropina) y MSH (hormona estimulante de melanocitos) | Cerebro, hipófisis | Regulación de la respuesta al estrés y patrones de coloración corporal                  |

## Relevancia en Bioingeniería

### Aplicaciones Potenciales:

1. **Selección Asistida por Marcadores**:
   - Desarrollo de tests genéticos para identificar individuos con variantes favorables
   - Optimización de programas de reproducción selectiva

2. **Diseño de Instalaciones Acuícolas**:
   - Adaptación de sistemas de cultivo basados en perfiles genéticos
   - Personalización de condiciones ambientales según variantes genéticas

3. **Biomonitoreo Ambiental**:
   - Uso de estos genes como biomarcadores de salud poblacional
   - Detección temprana de estrés metabólico en poblaciones silvestres

## Metodología

### Pipeline de Análisis:

```bash
# Paso 1: Descarga de secuencias
datasets download gene symbol "clrn2" --ortholog "SALMONIDAE" --filename clrn2.zip

# Paso 2: Alineamiento múltiple
muscle3.8.31_i86linux64 -in secuencias.fna -out alineado.fasta -maxiters 1 -diags

# Paso 3: Análisis filogenético
iqtree -s renombrado.fasta -nt AUTO -m MFP -bb 1000


### Para Empezar

Este proyecto se centra en el análisis comparativo y evolutivo de genes relacionados con la maduración sexual en peces de la familia Salmonidae. Mediante herramientas bioinformáticas, se busca identificar loci de gran efecto vinculados a la regulación del eje cerebro-hipófisis-gónada, el cual controla procesos hormonales críticos para el desarrollo reproductivo.

### Prerequisitos

* GitBash
* MUSCLE v3.8.31
* IQ-TREE v2.4.0
* FigTree v1.4.4
* Strawberry Perl v5.40.2.1
* ATOM Editor

### Bibliografía

Salgado, A., Kurko, J., Verta, J., House, A., Sinclair-Waters, M., Mobley, K., Primmer, C., Miettinen, A., Moustakas-Verho, J., Aykanat, T., & Czorlich, Y. (2020). Maturation in Atlantic salmon (Salmo salar, Salmonidae): a synthesis of ecological, genetic, and molecular processes. Reviews in Fish Biology and Fisheries, 31, 523 - 571. https://doi.org/10.1007/s11160-021-09656-w.

Macqueen, D., & Houston, R. (2018). Atlantic salmon (Salmo salar L.) genetics in the 21st century: taking leaps forward in aquaculture and biological understanding. Animal Genetics, 50, 3 - 14. https://doi.org/10.1111/age.12748.




