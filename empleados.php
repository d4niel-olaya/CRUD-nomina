
<?php
// Traigo las variables del archivo conexion.php
    include('conexion.php');
    // consulta que quiero mostrar en la página
    $mostrar = "SELECT empleados.cedula, empleados.nombre, empleados.apellido, departamentos.nombre as 'Departamento',
     cargos.nombre as 'Cargo' FROM empleados INNER JOIN departamentos INNER JOIN cargos ON empleados.id_departamento = departamentos.id AND empleados.id_cargo = cargos.id
    ORDER BY empleados.cedula;";  

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
            <select name="cargos" id="Cargos">
                <optgroup label="Cargos">
                    <option value="Back-end">Back-end</option>
                    <option value="Front-end">Front-end</option>
                </optgroup>
            </select>
            <select name="departamentos" id="departamentos">
                <optgroup label="Departamentos">
                    <option value="Desarrollo">Desarrollo</option>
                </optgroup>
            </select>
        </form>
        <?php
        // Verificando la variable de busqueda existe
            if(isset($_GET['busqueda'])){
                // guardando el estado de la busqueda
                $estado_cedula = $_GET['busqueda'];
                // Si la cedula se encuentra
                if($estado_cedula == 'encontrada'){
                    // Se guarda la cedula
                    $cedula = $_GET['cedula'];
                    // Se le avisa al usuario que se encontró
                    echo '<h2>Cedula encontrada</h2>';
                    // Se modifica la consulta general
                    $mostrar =  "SELECT empleados.cedula, empleados.nombre, empleados.apellido, departamentos.nombre as 'Departamento',
                    cargos.nombre as 'Cargo' FROM empleados INNER JOIN departamentos INNER JOIN cargos ON empleados.id_departamento = departamentos.id AND empleados.id_cargo = cargos.id
                    WHERE cedula = '$cedula';";
                    
                }
                // Si la cedula está vacia y  si se seleccioná algún filtro
                else if(empty($_GET['cedula']) && !empty($_GET['cargo']) && !empty($_GET['dep'])){
                    // Se guarda el cargo
                    $cargo = $_GET['cargo'];
                    // Se guarda el departamento
                    $dep = $_GET['dep'];
                    // Se incorpora el cargo y el departamento en la consulta
                    $mostrar = "SELECT empleados.cedula, empleados.nombre, empleados.apellido, departamentos.nombre as 'Departamento',
                        cargos.nombre as 'Cargo' FROM empleados INNER JOIN departamentos INNER JOIN cargos ON empleados.id_departamento = departamentos.id AND empleados.id_cargo = cargos.id
                    WHERE cargos.nombre = '$cargo' AND departamentos.nombre = '$dep' ORDER BY cargos.nombre and departamentos.nombre;";  
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
    <button onclick="volver()">Volver al inicio</button>
    <script>
        function volver(){
            // Función para volver al index.php
            window.location = '/proyecto_nomina';
        }
    </script>
    <div>
</body>

