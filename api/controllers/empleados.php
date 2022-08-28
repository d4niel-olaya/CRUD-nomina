<?php


require_once '../database/conexion.php';

interface IConsulta{
    public function get($conexion,$consulta);
}

abstract class Consulta implements IConsulta{
    public function get($conexion, $consulta){
        $resultado = mysqli_query($conexion, $consulta);
        $items = [];
        if($resultado = mysqli_query($conexion, $consulta)){
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
    public function post(){
        echo 'Esto es una clase para crear elementos';
    }
}

class Consultas extends Consulta{
    private $conexion;
    private $consulta = 'SELECT * from productos';
    public function __construct()
    {   
        $this->conexion = Database::Conexion();
    }
    public function getElements(){
        return $this->get($this->conexion, $this->consulta);
    }
}

$empleado = new Consultas();
header('Content-Type:application/json');
print_r($empleado->getElements());


// Database::Conexion()->query('SELECT * from productos');