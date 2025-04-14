#!/bin/bash

archivo="/workspaces/Practica-semana-3/ventas_empresa.csv"

salida="/workspaces/Practica-semana-3/log.txt"

echo "REPORTE DE VENTAS - $(date '+%d-%m-%Y %H:%M:%S')" > "$salida"
echo "" >> "$salida"

echo "1. Total de ventas por mes:" >> "$salida"
tail -n +2 "$archivo" | awk -F',' '
{
    split($1, fecha, "-");
    mes = fecha[1] "-" fecha[2];
    monto = $3 * $5;
    ventas[mes] += monto;
}
END {
    for (m in ventas)
        printf "%s: $%.2f\n", m, ventas[m];
}
' | sort >> "$salida"

echo "" >> "$salida"

echo "2. Producto más vendido:" >> "$salida"
tail -n +2 "$archivo" | awk -F',' '
{
    productos[$4] += $3;
}
END {
    max = 0;
    for (p in productos) {
        if (productos[p] > max) {
            max = productos[p];
            mas_vendido = p;
        }
    }
    print mas_vendido " (" productos[mas_vendido] " unidades)";
}
' >> "$salida"

echo "" >> "$salida"

echo "3. Monto total anual:" >> "$salida"
tail -n +2 "$archivo" | awk -F',' '
{
    total += $3 * $5;
}
END {
    printf "Total anual: $%.2f\n", total;
}
' >> "$salida"

echo "" >> "$salida"

echo "4. Cliente más frecuente:" >> "$salida"
tail -n +2 "$archivo" | awk -F',' '
{
    clientes[$6]++;
}
END {
    max = 0;
    for (c in clientes) {
        if (clientes[c] > max) {
            max = clientes[c];
            frecuente = c;
        }
    }
    print frecuente " (" clientes[frecuente] " compras)";
}
' >> "$salida"