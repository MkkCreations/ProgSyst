#!/bin/bash

function search {
    numfiles=$(ls -1 "./Test_Info_AST_2021-data" | wc -l)

    for ((l=0; l<$numfiles; l++)); do
        # Lee los números del archivo y ordena el arreglo
        nums=($(sort -n ./Test_Info_AST_2021-data/data_"$l".txt))

        # Encontrar los números faltantes en el arreglo ordenado
        missing=()
        for ((i=0; i<${#nums[@]}-1; i++)); do
            for ((j=${nums[i]}+1; j<${nums[i+1]}; j++)); do
                missing+=($j)
            done
        done

        # Imprimir los números faltantes
        printf '%s\n' "${missing[@]}"

        # Esperar un segundo antes de la siguiente iteración
        sleep 1
        echo "-------"
    done
}

search