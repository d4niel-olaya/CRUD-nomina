
<?php
    include('conexion.php');
    $no_hay_seleccion = 'vacio';
    if(isset($_POST['seleccionados'])){
        $no_hay_seleccion = 'seleccionados';
        $empleadosSeleccionados= $_POST['seleccionados'];
        $acumulador = 0;
        foreach($empleadosSeleccionados as $cedula => $valor){
            $consultaParaCalcular = 'SELECT total_dev FROM devengados WHERE id = id_empleado('.strval($cedula).')';
            $resultadoConsulta = mysqli_query($conexion, $consultaParaCalcular);
            $idDelempleado = mysqli_fetch_assoc($resultadoConsulta);
            foreach($idDelempleado as $totalDevengado){
                // usando la función floatval estoy quitando los valores decimales
                intval($totalDevengado);
                $acumulador += $totalDevengado;
            }
        }
        
        
    }
    header('Location:empleados.php?seleccion='.$no_hay_seleccion.'&total='.$acumulador);
    
?>
