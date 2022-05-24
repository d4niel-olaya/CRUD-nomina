<?php
// Traigo las variables del archivo conexion.php
    include('conexion.php');
    // consulta que quiero mostrar en la página

?>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="estilos/estilos.css">
    <title>Proyecto nomina en php</title>
</head>
<body>
    <h1>Registrar información del empleado</h1>
    <h4>Datos personales y contrato</h4>
        <form action="validar.php" method="POST">
            <h4 class="sub-form">Datos personales del empleado</h4>
            <hr>
            <div class="part_1">
                <div>
                    <label for="">Cedula</label>
                    <br>
                    <input type="text" name="cedula" autocomplete="off" maxlength="10">
                </div>
                <div>
                    <label for="">Nombre</label>
                    <br>
                    <input type="text" name="nombre" autocomplete="off">
                </div>
                <div>
                    <label for="">Apellido</label>
                    <br>
                    <input type="text" name="apellido" autocomplete="off">
                </div>
                <div>
                    <label for="">Genero</label>
                    <br>
                    <input type="text">
                </div>
                <div>
                    <label for="">Celular</label>
                    <br>
                    <input type="text">
                </div>
                <div>
                    <label for="">Telefono fijo</label>
                    <br>
                    <input type="text">
                </div>
                <div>
                    <label for="">Dirrecion</label>
                    <br>
                    <input type="text">
                </div>
                <div>
                    <label for="">Eps</label>
                    <br>
                    <select name="" id="">
                        <optgroup label="Eps">
                            <option value="">Nueva eps</option>
                            <option value="">Sanitas</option>
                        </optgroup>
                    </select>
                </div>
            </div>
            <div>
                <h4 class="sub-form">Contrato</h4>
                <hr>
                <div class="part_1">
                    <div>
                        <label for="">Departamentos</label>
                        <br>
                        <select name="departamentos" id="departamentos">
                            <optgroup label="Departamentos">
                                <option value="1">Desarrollo</option>
                                <option value="2">Analisís</option>
                                <option value="3">Testing</option>
                            </optgroup>
                        </select>
                    </div>
                    <div>
                        <label for="">Cargo</label>
                        <br>
                        <select name="cargos" id="cargos">
                            <optgroup label="Cargos">
                                <option value="1">Back-end</option>
                                <option value="2">Front-end</option>
                            </optgroup>
                        </select>
                    </div>
                    <div>
                        <label for="">Jornada</label>
                        <br>
                        <select name="jornadas" id="jornadas">
                            <optgroup label="Jornadas">
                                <option value="1">Diurna</option>
                            </optgroup>
                        </select>
                    </div>
                    <div>
                        <label for="">Contrato</label>
                        <br>
                        <select name="contratos" id="contratos">
                            <optgroup label="Contratos">
                                <option value="1">Indefindo</option>
                                <option value="2">Ops</option>
                            </optgroup>
                        </select>
                    </div>
                    <div>
                        <label for="">Salario básico</label>
                        <br>
                        <input type="text" name="salario_basic" min="100000" required>
                    </div>
                    <div>
                        <label for="">Horas extras diurnas</label>
                        <br>
                        <input type="number" name="hora_ex_diur_or" min="0">
                    </div>
                    <div>
                        <label for="">Horas Extras nocturnas ordinarias</label>
                        <br>
                        <input type="number" name="hora_ex_noc_or" min="0">
                    </div>
                    <div>
                        <label for="">Horas Extras diurnas festivas</label>
                        <br>
                        <input type="text">
                    </div>
                </div>  
            </div>
            <div class="container-btn">
                <a class="btn-save">Guardar</a>
                <a class="btn-cancel">Cancelar</a>
            </div>
        </form>
        <br>
        <br>
        <button class="btn-save"onclick="verEmpleados();">Ver empleados</button>
        
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