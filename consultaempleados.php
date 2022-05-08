<?php
    include('conexion.php');
    // Verficando que la variable de la cedula existe
    if(isset($_GET['buscarEmp'])){
        // Extrayendo el valor de la cedula
        $busqueda_cedula = $_GET['buscarEmp'];
        // Obteniendo el cargo
        $cargo = $_GET['cargos'];
        // Quitando los espacios de la cedula
        $busqueda_cedula = trim($busqueda_cedula);
        // Obteniendo el departamento
        $departamento = $_GET['departamentos'];
        // Usando una consulta para verificar si la cedula está en la bd
        $consulta_empleado = "SELECT nombre FROM empleados WHERE cedula = '$busqueda_cedula' ";
        // Función para verificar si la cedula está en la bd
        function buscarCedula($conexion, $consulta){
        if($busqueda_emp = mysqli_prepare($conexion, $consulta)){
            // Ejecutando la consulta
            mysqli_stmt_execute($busqueda_emp);
            mysqli_stmt_bind_result($busqueda_emp, $cedula);
            // Retornando el valor de la consulta: NULL o true
            $indicador_cedula = mysqli_stmt_fetch($busqueda_emp);
            // Retornando la consulta
            return $indicador_cedula;
            // Cerrando la consulta
            mysqli_stmt_close($busqueda_emp);
            
        }
        }
        // Creando una varible de estado de la consulta de la cedula
        $busqueda = 'encontrada';
        // Si la cedula no esta presente el estado cambia
        if(!buscarCedula($conexion, $consulta_empleado)){
            $busqueda = 'no_encontrada';

        }
        // pasando la variable busqueda, el valor de la cedula, cargo y departamento por url
        header('Location:empleados.php?busqueda='.$busqueda.'&cedula='.$busqueda_cedula.'&cargo='.$cargo.'&dep='.$departamento);

        
    }
?>