
<?php
// Traigo las variables del archivo conexion.php
    include('conexion.php');
    // consulta que quiero mostrar en la página
    $mostrar = "SELECT empleados.cedula, empleados.nombre, empleados.dias_lab, devengados.sueldo, devengados.valor_horas_total,
    devengados.auxilio_transporte, devengados.total_dev, deducciones.salud, deducciones.otras_deduc as 'Prestamos',
deducciones.total_deducido FROM empleados INNER JOIN devengados INNER JOIN deducciones ON empleados.id = devengados.id_empleado AND empleados.id = deducciones.id_devengado;
";

?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Listado de empleados</title>
</head>
<body>
<h1>Listado de empleados</h1>
    <div>
        <form action="consultaempleados.php" method="GET">
            <label for="busquedaEmp">Buscar empleado por la cedula</label>
            <input type="search" id="busquedaEmp" name="buscarEmp">
            <button>Buscar</button>
        </form> 
    </div>
    <br>   
    <table border='1' id="empleados">
        <tr>
            <th>Cedula</th>
            <th>Nombre</th>
            <th>Dias laborados</th>
            <th>Sueldo</th>
            <th>Valor horas extras</th>
            <th>Auxilio de transporte</th>
            <th>Total devengados</th>
            <th>Salud</th>
            <th>Prestamos</th>
            <th>Total deducido</th>
        </tr>
        <?php
        $tabla = mysqli_query($conexion, $mostrar);
        while($row = mysqli_fetch_assoc($tabla)){ ?>
        <tr>
            <td><?php echo $row['cedula'];?></td>
            <td><?php echo $row['nombre'];?></td>
            <td><?php echo $row['dias_lab'];?></td>
            <td><?php echo $row['sueldo'];?></td>
            <td><?php echo $row['valor_horas_total'];?></td>
            <td><?php echo $row['auxilio_transporte'];?></td>
            <td><?php echo $row['total_dev'];?></td>
            <td><?php echo $row['salud'];?></td>
            <td><?php echo $row['Prestamos'];?></td>
            <td><?php echo $row['total_deducido'];?></td>
        </tr>
        <?php } mysqli_free_result($tabla); ?>
    </table>
    <div>
</body>

