<?php
// Traigo las variables del archivo conexion.php
    include('conexion.php');
    // consulta que quiero mostrar en la página

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
                </optgroup>
            </select>
            <br>
            <label for="">Jornada</label>
            <select name="jornadas" id="jornadas">
                <optgroup label="Jornadas">
                    <option value="1">Diurna</option>
                </optgroup>
            </select>
            <br>
            <label for="">Contrato</label>
            <select name="contratos" id="contratos">
                <optgroup label="Contratos">
                    <option value="1">Indefindo</option>
                    <option value="2">Ops</option>
                </optgroup>
            </select>
            <br>
            <label for="">Salario básico</label>
            <input type="text" name="salario_basic" min="100000">
            <br>
            <label for="">Dias laborados</label>
            <input type="number" name="dias_lab" min="0" max="30">
            <br>
            <table id="horas_extras">
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
        <br>
        <br>
        <button onclick="verEmpleados();">Ver empleados</button>
        
    </div>
    <script>
        // Funcion para obtener el indice seleccionado de la etiqueta select contratos
        function ocultarHoras(){
            // Obteniendo la etiqueta select
            let contratos = document.getElementById('contratos');
            // Obteniendo los campos de horas
            // Ya que si es contrato por ops no tiene derecho a horas extras
            let tabla = document.getElementById('horas_extras');
            // Obteniendo el indice seleccionado
            let indice = contratos.options.selectedIndex;
            // Evaluando si el indice es ops
            if(indice == 1){
                // si es ops no se mostrará la tabla de horas extras
                tabla.style.display = 'none';
            }
            else{
                // Si no es se mostrará
                tabla.style.display = '';
            }
        }
        // Declaracion de la función para ver la página con el listado de empleados
        function verEmpleados(){
            window.location = '/proyecto_nomina/empleados.php';
        }

        contratos.addEventListener('click', ocultarHoras);
    </script>
</body>
</html>