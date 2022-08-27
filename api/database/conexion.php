
<?php

interface IDatabase{
    public static function Conexion();
}

class Database implements IDatabase{
    public $host;
    public static $conexion;

    public static function Conexion()
    {   
        self::$conexion =  mysqli_connect('localhost', 'root', '', 'ecommerce');
        return self::$conexion;
    }
}

