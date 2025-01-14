#!/bin/bash
# Este pipeline tiene como objetivo leer un fichero input de lista de acceso de secuencias
# para descargar todos los ficheros SRR de su interior y filtrarlos con fastqc. Funciona con secuencias paired-end
# El script se debe situar donde el fichero de secuencias a descargar
echo "Dime qué lista quieres descargar:"
read archivo
lista=$(cat $archivo)
echo "El archivo de lista a descargar es el siguiente: $archivo :"
echo "A continuación comenzará la descarga y análisis de calidad de las siguientes secuencias: $lista"
for i in $lista
do
	echo "SE VA A DESCARGAR LA SECUENCIA: $i"
	fastq-dump --split-3 $i
	echo "LA DESCARGA DE LA SECUENCIA $i SE HA COMPLETADO CON ÉXITO"
done

echo "la lista de secuencias ha sido descargada correctamente"
#Ahora se creará un directorio para organizar las secuencias descargadas
#En caso de que el directorio exista, saltará un aviso de que ya existe y no creará ninguno nuevo

echo "Creando directorio para almacenar las secuencias descargadas..."
n=0
while ! mkdir fastq_files$n
do
	n=$((n+1))
done

echo "moviendo las secuencias al nuevo directorio"
	
mv *.fastq fastq_files$n

#Finalmente, sera necesario utilizar el comando fastqc para realizar el analisis de calidad de las secuencias
#y almacenarlas de nuevo en un nuevo directorio.

echo "Creando directorio para almacenar ficheros fastqc"

y=0
while ! mkdir fastqc_results$y
do
	y=$((n+1))
done
echo "Fichero Fastqc-results creado"

for x in fastq_files$n:
do
	echo "Se va a analizar la calidad del archivo: $x"
	fastqc -o ./fastqc_results$y $x
done

"Descarga y filtrado realizado con exito"

