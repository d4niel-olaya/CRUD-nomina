
<?php
// Traigo las variables del archivo conexion.php
    include('conexion.php');
    // consulta que quiero mostrar en la página
    $mostrar = "SELECT empleados.cedula, empleados.nombre, empleados.apellido, departamentos.nombre as 'Departamento',
     cargos.nombre as 'Cargo' FROM empleados INNER JOIN departamentos INNER JOIN cargos ON empleados.id_departamento = departamentos.id AND empleados.id_cargo = cargos.id;
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
        <select name="opciones" id="opciones">
            <optgroup label="Fitros">
                
                <option value="cargo">Cargo</option>
                <option value="departamentos">Departamentos</option>
            </optgroup>
        </select>
        <?php
            if(isset($_GET['busqueda'])){
                $estado_cedula = $_GET['busqueda'];
                if($estado_cedula == 'encontrada'){
                    $cedula = $_GET['cedula'];
                    echo '<h2>Cedula encontrada</h2>';
                    $mostrar = $mostrar = "SELECT empleados.cedula, empleados.nombre, empleados.apellido, departamentos.nombre as 'Departamento',
                    cargos.nombre as 'Cargo' FROM empleados INNER JOIN departamentos INNER JOIN cargos ON empleados.id_departamento = departamentos.id AND empleados.id_cargo = cargos.id
                    WHERE cedula = '$cedula';";
                }
                else{
                    echo '<h2>Cedula no encontrada</h2>';
                }
            }
        ?>
    </div>
    <br>   
    <table border='1' id="empleados">
        <tr>
            <th>Cedula</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Departamento</th>
            <th>Cargo</th>
            
        </tr>
        <?php
        $tabla = mysqli_query($conexion, $mostrar);
        while($row = mysqli_fetch_assoc($tabla)){ ?>
        <tr>
            <td><?php echo $row['cedula'];?></td>
            <td><?php echo $row['nombre'];?></td>
            <td><?php echo $row['apellido'];?></td>
            <td><?php echo $row['Departamento'];?></td>
            <td><?php echo $row['Cargo'];?></td>
           
        </tr>
        <?php } mysqli_free_result($tabla); ?>
    </table>
    <div>
</body>

