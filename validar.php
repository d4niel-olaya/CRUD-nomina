<?php
include('conexion.php');
// incluyo las variables del archivo conexion.php

// Función para calcular las horas extras
// Solo calculo de momento un tipo de hora extra
// que es 
function calc_hrs($salario_basico ,$dias_lab ,$hrs_d){
    // defino como parametro el salario basico, los dias laborados y el tipo de hora
    // Acumulador del valor de las horas extras
    $valor_total = 0;
    // Valor de la hora ordinaria
    $valor_hora = ($salario_basico/240);
    // Se calculan las horas si son diferentes de 0
    if($hrs_d != 0){
        $valor_total += round(($valor_hora*1.75),0);
    }
    return $valor_total;
};

// Función para hacer una consulta a la bd, en este caso para saber si la cedula
// introducida ya existe
function cedula_presente($consulta, $conexion){

        // Preparando la consulta
    if($sentencia = mysqli_prepare($conexion, $consulta)){
        // Ejecutando la consulta
        mysqli_stmt_execute($sentencia);
        // Extrayendo los campos que quiero consultar
        // En este caso solo quiero consultar la cedula
        mysqli_stmt_bind_result($sentencia, $cedula_emp);
        // guardando el resultado de la consulta
        // arroja true, false, null
        $indicador = mysqli_stmt_fetch($sentencia);
        return $indicador;
        // retornado la variable indicador
        mysqli_stmt_close($sentencia);
        // cerrando la consulta
    }

};

// Sacando cada dato por separado usando post
$nombre = $_POST['nombre'];
$apellido = $_POST['apellido'];
$cedula = $_POST['cedula'];
$hrs_diur = (int)$_POST["hora_ex_diur_or"];
$departamento = (int)$_POST['departamentos'];
$cargo = (int)$_POST['cargos'];

$jornada = (int)$_POST['jornadas'];
$contrato = (int)$_POST['contratos'];

$hrs_noc = (int)$_POST["hora_ex_noc_or"];
$hrs_diur_fes = (int)$_POST["hora_ex_diur_fes"];
$hrs_noc_fes = (int)$_POST["hora_ex_noc_fes"];
$salario_basico = (int)$_POST["salario_basic"];
$dias_lab = (int)$_POST['dias_lab'];


// Pasando valores a la función que calcula las horas extras
// almacenando el resultado en una variable $horas_total
$horas_total = calc_hrs($salario_basico, $dias_lab, $hrs_diur);

// consulta para saber si la cedula ingresada ya está presente en la bd
$consulta = "SELECT nombre FROM empleados WHERE cedula = '$cedula'";

// consulta para insertar los datos
$insertar = "INSERT INTO empleados(cedula, id_nomina, nombre,apellido, id_cargo, id_departamento, id_jornada, id_contrato, salario_basico,
dias_lab, num_horas, valor_horas_total)
VALUES('$cedula', 1, '$nombre', '$apellido', '$cargo', '$departamento', '$jornada',
'$contrato', '$salario_basico', '$dias_lab', '$hrs_diur', '$horas_total');";


// almacenando el valor de la funcion cedula_presente en una variable
$valido = cedula_presente($consulta, $conexion);
// si el valor es igual a true, indicara que ya está presente en la bd
if($valido){
    echo "<script>alert('El dato introducio ya está presente'); window.history.go(-1)</script>";

}else{
    // sino va a guardar los datos en la bd
    // el paso como paramentro la conexion y consulta con los datos a introducir
    $resultado = mysqli_query($conexion, $insertar);
    // si retorna false avisará que se ha presentado un error
    if(!$resultado){
        echo "<script>alert('Error en el insertado de los datos'); window.history.go(-1);</script>";

    }else{
        // si es diferente a false avisará que se han insertado los datos con exito
        echo "<script>alert('Dato insertados con exito'); window.location = '/proyecto_nomina'</script>";
    }
}

?>