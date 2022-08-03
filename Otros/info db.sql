--query basica--
SELECT --columnas de elementos a mostrar--
    GROUP_CONTACT(elemento1 v elemento2...)--agrupa los elementos marcados--
        SEPARATOR ''--define un relemnto que va entre los valores resultantes en el group_contact--
    DISTINCT --elimina valores repetidos--
    ORDER BY elemento --ordena en base a elemento en:--
        DESC --de forma decendente--
        ASC --acendente--
FROM --tablas de donde se lee--
WHERE --condiciones--
    x != y --si son desiguales--
    x = y --si son iguales--
    x < y --si y es mayor que x--
    x like y --comparacion de texto--
    x BETWEEN y --comparacion de elemento x en intervalo y--

        AND --concatena condiciones--
        OR --si alguna de las condiciones se cumple--
        NOT --valor contrario--

--join--
SELECT tablan.elemento --columnas de elementos a mostrar--
FROM --tablas de donde se lee--
    tabla1 INNER JOIN tabla2 ON --condicion que las une--
WHERE --condiciones--

--subquery--
    --sub select--
        SELECT (--subquey--) --selecciona la columna de otra tabla--
        FROM --tablas de donde se lee (no va la de la subquey)--
        WHERE --condiciones--

    --sub where--
        SELECT --columnas de elementos a mostrar--
        FROM --tablas de donde se lee (no va la de la subquey)--
        WHERE elemento --operador-- --extension-- (--subquery--)
            --extensiones de subquery--
            ALL --si todos los valores de la subquey dieron verdadero--
            ANY --si alguno de los valores de la subquey dio falso--
            ALL --solo si es una columna el valor de la subquery--