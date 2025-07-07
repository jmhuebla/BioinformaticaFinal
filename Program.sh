
#!/bin/bash

#$ -l h_rt=24:00:00,h_data=10G,h_vmem=10G
#$ -pe shared 1
#$ -N JHUFinalProject
#$ -cwd
#$ -m bea
#$ -o /u/scratch/d/dechavez/Bioinformatica-PUCE/HerrBio/JulissaHu/FinalProject/log/FinalProgram.out
#$ -e /u/scratch/d/dechavez/Bioinformatica-PUCE/HerrBio/JulissaHu/FinalProject/log/FinalProgram.err
#$ -M dechavezv

source /u/local/Modules/default/init/modules.sh
module load iqtree/2.2.2.6

# Notas importantes:
# 1. Los genes seleccionados están relacionados con funciones auditivas (clrn2, coch) y metabólicas (exoc1l, pik)
# 2. Salmonidae es una familia de peces con interesantes adaptaciones evolutivas
# 3. Se recomienda verificar las secuencias obtenidas ya que algunas pueden ser parciales

#Verificar que nos encontremos en la carpeta correcta
pwd

#Definir nuestra familia objetivo

taxon="SALMONIDAE"
genes=("clrn2" "coch" "exoc1l" "pik")

# Creo directorios para cada gen
for gene in "${genes[@]}"; do
    mkdir -p "${gene}_${taxon}_info"
    # Nota: Se buscarán todos los orthólogos disponibles para la familia completa
done

## Debo tener cerca la el archivo "datasets" ya que contiene la base de datos del NCBI para descargar los genes que me interesan
cp ../PROGRAMS/muscle3.8.31_i86linux64 ./
cp ../PROGRAMS/datasets ./

## Descargar desde la base de datos de NCBI 
# OJO: los genes que vamos a usar los definimos al inicio
for gene in "${genes[@]}"; do

    # Buscar los ortologos de la familia Salmonidae --ortholog
    ./datasets download gene symbol "${gene}" --ortholog "${taxon}" --filename "${gene}_${taxon}.zip"
    
    # Cambio de ubicacion al folder que termina en info
    mv "${gene}_${taxon}.zip" "${gene}_${taxon}_info/"
done

## de los archivos .zip que descargamos de NCBI, hacemos el loop para descomprimirlos
for gene in "${genes[@]}"; do
    for taxon in "${taxa[@]}"; do
        arc="${gene}_${taxon}_info
        cd "$arc"

        # Se decomprime con unzip
        unzip "${gene}_${taxon}.zip"

        # Para mayor orden, todos los archivos que terminan en fna, agrupamos en un solo directory y cambiamos la nomenclatura
        mv ncbi_dataset/data/rna.fna ./"${gene}_${taxon}.fna"

    done
done

## Alinear con MUSCLE (ya copiamos e�l programaal inicio)
for gene in "${genes[@]}"; do
    for taxon in "${taxa[@]}"; do
        arc="${gene}_${taxon}_info"
        cd "$arc"

        mkdir -p MUSCLE
        mv "${gene}_${taxon}.fna" MUSCLE/

        cd MUSCLE
        ./muscle3.8.31_i86linux64 -in "${gene}_${taxon}.fna" -out "muscle_${gene}_${taxon}.fasta" -maxiters 1 -diags
## OJO: ME MUEVO DOS PASOS ATRAS CON cd
        cd ../..
    done
done


## IMPORTANTE: A partir de Aqui, se puede copiar los alineamientos hechos con muscle hacia nuestra suervidor propio y hacer regular expressions con ATOMTextEditor, y luego volver a subir los archivos editados a nuestro servidor remoto Hoffman


## IQTREE
for gene in "${genes[@]}"; do
    for taxon in "${taxa[@]}"; do
        arc="${gene}_${taxon}_info"
        cd "$arc"

        mkdir -p IQTREE
        cp MUSCLE/"muscle_${gene}_${taxon}.fasta" IQTREE/

        cd IQTREE

        # Ya cargamos IQTREE version 2.2.2.6 al inicio, ahora hacemos el analisis filogenetico con iqtree -s
        iqtree -s "muscle_${gene}_${taxon}.fasta" -nt AUTO

        cd ../..
    done
done

# Hago una carpeta para todas mis Filogenias

mkdir -p FILOGENIA_NA


# Recolectar todos los árboles filogenéticos
for gene in "${genes[@]}"; do
    tree_file="${gene}_${taxon}_info/IQTREE/muscle_${gene}_${taxon}.fasta.treefile"
    if [ -f "$tree_file" ]; then
        cp "$tree_file" FILOGENIA_NA/ 
    fi
done

## Concatenar todos los treefiles en un solo archivo
cd FILOGENIA_NA
cat *.trefile > All.Salmonidae.Genes.tree
