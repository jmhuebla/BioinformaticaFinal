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
# 1. Los genes seleccionados están relacionados con funciones metabólicas (exoc1 clrn2, exoc1l, pomc)
# 2. Salmonidae es una familia de peces con interesantes adaptaciones evolutivas
# 3. Se recomienda verificar las secuencias obtenidas ya que algunas pueden ser parciales

#Verificar que nos encontremos en la carpeta correcta
pwd

#Definir nuestra familia objetivo
taxon="SALMONIDAE"
genes=("clrn2" "coch" "exoc1l" "pomc")

# 1. Creo directorios para cada gen
for gene in "${genes[@]}"; do
    mkdir -p "${gene}_${taxon}_info"
done

## 2. Copiar programas necesarios
cp ../PROGRAMS/muscle3.8.31_i86linux64 ./
cp ../PROGRAMS/datasets ./

## 3. Descargar desde la base de datos de NCBI
for gene in "${genes[@]}"; do
    ./datasets download gene symbol "${gene}" --ortholog "${taxon}" --filename "${gene}_${taxon}.zip"
    mv "${gene}_${taxon}.zip" "${gene}_${taxon}_info"
done

## 4.Descomprimir archivos .zip
for gene in "${genes[@]}"; do
    arc="${gene}_${taxon}_info"
    cd "$arc"
    unzip "${gene}_${taxon}.zip"
    mv ncbi_dataset/data/rna.fna "${gene}_${taxon}.fna"
    cd ..
done

## 5. Alinear con MUSCLE
for gene in "${genes[@]}"; do
    arc="${gene}_${taxon}_info"
    cd "$arc"
    mkdir -p MUSCLE
    mv "${gene}_${taxon}.fna" MUSCLE/
    cd MUSCLE
    ../../muscle3.8.31_i86linux64 -in "${gene}_${taxon}.fna" -out "muscle_${gene}_${taxon}.fasta" -maxiters 1 -diags
    cd ../..
done

## 6. IQTREE
for gene in "${genes[@]}"; do
    arc="${gene}_${taxon}_info"
    cd "$arc"
    mkdir -p IQTREE
    cp MUSCLE/"muscle_${gene}_${taxon}.fasta" IQTREE/
    cd IQTREE
    iqtree -s "muscle_${gene}_${taxon}.fasta" -nt AUTO
    cd ../..
done

# 7. Recolectar filogenias
mkdir -p FILOGENIA_NA
for gene in "${genes[@]}"; do
    tree_file="${gene}_${taxon}_info/IQTREE/muscle_${gene}_${taxon}.fasta.treefile"
    if [ -f "$tree_file" ]; then
        cp "$tree_file" FILOGENIA_NA/
    fi
done

## Concatenar árboles
cd FILOGENIA_NA
cat *.treefile > All.Salmonidae.Genes.tree
