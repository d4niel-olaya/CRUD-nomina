<?php
    include('conexion.php');
    if(isset($_GET['buscarEmp'])){
        $busqueda_cedula = $_GET['buscarEmp'];
        $busqueda_cedula = trim($busqueda_cedula);
        $consulta_empleado = "SELECT nombre FROM empleados WHERE cedula = '$busqueda_cedula' ";
        function buscarCedula($conexion, $consulta){
        if($busqueda_emp = mysqli_prepare($conexion, $consulta)){
            mysqli_stmt_execute($busqueda_emp);
            mysqli_stmt_bind_result($busqueda_emp, $cedula);
            $indicador_cedula = mysqli_stmt_fetch($busqueda_emp);
            return $indicador_cedula;
            var_dump($indicador_cedula);
            
        }
        }
        $busqueda = 'encontrada';
        if(!buscarCedula($conexion, $consulta_empleado)){
            $busqueda = 'no_encontrada';

        }
        header('Location:empleados.php?busqueda='.$busqueda.'&cedula='.$busqueda_cedula);

        
    }
?>