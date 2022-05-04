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
    <title>Proyecto nomina en php</title>
</head>
<body>
    <h1>Formulario para crear un empleado</h1>
    <table border='1'>
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
        <form action="validar.php" method="POST">
            <label for="">Nombre</label>
            <input type="text" name="nombre" autocomplete="off">
            <br>
            <label for="">Apellido</label>
            <input type="text" name="apellido" autocomplete="off">
            <br>
            <label for="">Cedula</label>
            <input type="text" name="cedula" autocomplete="off" maxlength="10">
            <br>
            <label for="">Departamentos</label>
            <select name="departamentos" id="departamentos">
                <optgroup label="Departamentos">
                    <option value="1">Desarrollo</option>
                    <option value="2">Analisís</option>
                    <option value="3">Testing</option>
                </optgroup>
            </select>
            <br>
            <label for="">Cargo</label>
            <select name="cargos" id="cargos">
                <optgroup label="Cargos">
                    <option value="1">Back-end</option>
                    <option value="2">Front-end</option>
                </optgroup>
            </select>
            <br>
            <label for="">Jornada</label>
            <select name="jornadas" id="jornadas">
                <optgroup label="Jornadas">
                    <option value="1">Diurna</option>
                    <option value="2">Ops</option>
                </optgroup>
            </select>
            <br>
            <label for="">Contrato</label>
            <select name="contratos" id="contratos">
                <optgroup label="Contratos">
                    <option value="1">Indefindo</option> 
                </optgroup>
            </select>
            <br>
            <label for="">Salario básico</label>
            <input type="text" name="salario_basic" min="100000">
            <br>
            <label for="">Dias laborados</label>
            <input type="number" name="dias_lab" min="0" max="30">
            <br>
            <table>
                <tr>
                    <th>Horas Extras diurnas ordinarias</th>
                    <th>Horas Extras nocturnas ordinarias</th>
                    <th>Horas Extras diurnas festivas</th>
                    <th>Horas Extras nocturnas festivas</th>
                </tr>
                <tr>
                    <td><input type="number" name="hora_ex_diur_or" min="0"></td>
                    <td><input type="number" name="hora_ex_noc_or" min="0"></td>
                    <td><input type="number" name="hora_ex_diur_fes" min="0"></td>
                    <td><input type="number" name="hora_ex_noc_fes" min="0"></td>
                </tr>
            </table>
            <button>Enviar</button>
        </form>
        <button>Ver empleados</button>
    </div>
</body>
</html>