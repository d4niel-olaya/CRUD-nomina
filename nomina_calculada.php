<?php
    var_dump($_POST['seleccionados']);
    $indice = [];
    foreach($_POST['seleccionados'] as $cedula => $valor){
        array_push($indice, strval($cedula));
    }
    var_dump($indice);
    include('conexion.php');
    $consulta_emp = "SELECT nombre, cedula FROM empleados WHERE cedula = '$indice[0]';";
    
    
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <table border='1' id="empleados">
            <tr>
                <th>Nombre</th>
                <th>Cedula</th>
                
            </tr>
            <?php
            $tabla = mysqli_query($conexion, $consulta_emp);
            while($row = mysqli_fetch_assoc($tabla)){ ?>
            <tr>
                <!--<td><input type="checkbox" name="seleccionados[]"></td>--> 
                <td><?php echo $row['nombre'];?></td>
                <td><?php echo $row['cedula'];?></td>
            </tr>
            <?php } mysqli_free_result($tabla); ?>
    </table>
</body>
</html>