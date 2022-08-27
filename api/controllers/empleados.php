<?php


require_once '../database/conexion.php';

interface IConsulta{
    public function get($conexion);
}

abstract class Consulta implements IConsulta{
    protected $consulta  = 'SELECT * from productos';
    public function get($conexion){
        $resultado = mysqli_query($conexion, $this->consulta);
        $items = [];
        if($resultado = mysqli_query($conexion, $this->consulta)){
            while($row = mysqli_fetch_assoc($resultado)){
                $id = $row['id'];
                $nombre = $row['nombre'];
                $arr = ['id'=> $id,'nombre' => $nombre];
                array_push($items, $arr);
            }
            mysqli_free_result($resultado);
            return json_encode($items,true);
        }
    }
}

class Empleados extends Consulta{

}

$empleado = new Empleados();
header('Content-Type:application/json');
print_r($empleado->get(Database::Conexion()));



// Database::Conexion()->query('SELECT * from productos');