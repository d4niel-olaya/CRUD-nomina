
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
    <link rel="stylesheet" href="estilos/estilos.css">
    <style>
        table,th,td{
            border:1px solid black;
        }
    </style>
</head>
<body>
<h1>Listado de empleados</h1>
<div class="nav-vertical">
    <ul>
        <li>Imagen</li>
        <li>Inicio</li>
        <li>Empleados</li>
        <li>Ajustes</li>
        <li>Salir</li>
    </ul>
</div>
    <div>
        <form action="consultaempleados.php" method="GET">
            <label for="busquedaEmp">Buscar empleado por la cedula</label>
            <input type="search" id="busquedaEmp" name="buscarEmp">
            <button>Buscar</button>
            <select name="cargos" id="Cargos">
                <optgroup label="Cargos">
                    <option value=""></option>
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
                else if(empty($_GET['cedula']) && empty($_GET['cargo'])){
                    // Se guarda el cargo
                    $cargo = $_GET['cargo'];
                    // Se guarda el departamento
                    $dep = $_GET['dep'];
                    // Se modifica la consulta
                    $mostrar = "SELECT empleados.cedula, empleados.nombre, empleados.apellido, departamentos.nombre as 'Departamento',
                        cargos.nombre as 'Cargo' FROM empleados INNER JOIN departamentos INNER JOIN cargos ON empleados.id_departamento = departamentos.id AND empleados.id_cargo = cargos.id
                    WHERE departamentos.nombre = '$dep' ORDER BY departamentos.nombre;";  

                }   
                
                else{
                    echo '<h2>Cedula no encontrada</h2>';
                }
            }
        ?>
        <?php
            if(isset($_GET['seleccion'])){
                
                $indicativo = $_GET['seleccion'];
                $total_acumulado = $_GET['total'];
                if($indicativo == 'vacio'){
                    echo "<h3>Debes seleccionar un empleado</h3>";
                }
                else{
                    echo "<h3>Total devengado calculado = ".$total_acumulado."</h3>";
                }
            }
        ?>
    </div>
    <br>
    <form action="nomina_calculada.php" id="calcularNomina" method ="POST">
        <table id="empleados">
            <tr>
                <th></th>
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
                <!--<td><input type="checkbox" name="seleccionados[]"></td>--> 
                <?php echo '<td> <input type="checkbox"  name="seleccionados['.$row['cedula'].']"></td>' ?>
                <td><?php echo $row['cedula'];?></td>
                <td><?php echo $row['nombre'];?></td>
                <td><?php echo $row['apellido'];?></td>
                <td><?php echo $row['Departamento'];?></td>
                <td><?php echo $row['Cargo'];?></td>
            </tr>
            <?php } mysqli_free_result($tabla); ?>
        </table>
        <button>Calcular nomina</button>
    </form>  

    <br>
    <button onclick="volver()">Volver al inicio</button>
    <script>
        function volver(){
            // Función para volver al index.php
            window.location = '/proyecto_nomina';
        }
    </script>
    <div>
</body>

