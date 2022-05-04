-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-05-2022 a las 03:07:29
-- Versión del servidor: 10.4.22-MariaDB
-- Versión de PHP: 8.1.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `coex_definitiva`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `aportes_pfs`
--

CREATE TABLE `aportes_pfs` (
  `id` int(11) NOT NULL,
  `id_p_seg_social` int(11) NOT NULL,
  `caja_comp` decimal(16,4) DEFAULT NULL,
  `icbf` decimal(16,4) DEFAULT NULL,
  `sena` decimal(16,4) DEFAULT NULL,
  `total` decimal(16,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `aportes_pfs`
--
DELIMITER $$
CREATE TRIGGER `aportes_pfs_AI` AFTER INSERT ON `aportes_pfs` FOR EACH ROW BEGIN
	DECLARE contrato_t int;
    SET contrato_t = tipo_contrato(new.id);
    IF contrato_t = 2 THEN
   	INSERT INTO prestaciones_sociales(id_aportes, cesantias, intereses_ces, prima, vacaciones, total)
            VALUES(new.id, 0, 0,0,0,0);
	ELSE 
    INSERT INTO prestaciones_sociales(id_aportes, cesantias, intereses_ces, prima, vacaciones, total)
    SELECT devengados.id_empleado, devengados.total_dev * 0.0833, devengados.total_dev * 0.01, devengados.total_dev * 0.0833, (devengados.total_dev 
    - devengados.auxilio_transporte - devengados.valor_horas_total) * 0.0417,  (devengados.total_dev * 0.0833) + (devengados.total_dev * 0.01) +(devengados.total_dev * 0.0833) + ((devengados.total_dev 
    - devengados.auxilio_transporte - devengados.valor_horas_total) * 0.0417) FROM devengados INNER JOIN deducciones ON devengados.id_empleado = deducciones.id_devengado WHERE deducciones.id_devengado = new.id;
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargos`
--

CREATE TABLE `cargos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contratos`
--

CREATE TABLE `contratos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `deducciones`
--

CREATE TABLE `deducciones` (
  `id` int(11) NOT NULL,
  `id_devengado` int(11) NOT NULL,
  `ibc` decimal(16,4) NOT NULL,
  `salud` decimal(16,4) DEFAULT NULL,
  `fsp` decimal(16,4) DEFAULT NULL,
  `retencion_ef` decimal(16,4) DEFAULT NULL,
  `otras_deduc` decimal(16,4) DEFAULT NULL,
  `pension` decimal(16,4) DEFAULT NULL,
  `total_deducido` decimal(16,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `deducciones`
--
DELIMITER $$
CREATE TRIGGER `deducciones_AI` AFTER INSERT ON `deducciones` FOR EACH ROW BEGIN
	DECLARE contrato_t int;
    SET contrato_t = tipo_contrato(new.id);
   	IF contrato_t = 2 THEN
    INSERT INTO provision_seg_social(id_deduccion,salud, pension, arl, total)
SELECT deducciones.id_devengado, deducciones.ibc * 0,deducciones.ibc * 0,  deducciones.ibc * 0.0052,
deducciones.ibc * 0.0052
FROM deducciones INNER JOIN devengados ON deducciones.id_devengado = devengados.id_empleado WHERE deducciones.id_devengado = new.id;
ELSE 
    INSERT INTO provision_seg_social(id_deduccion,salud, pension, arl, total)
    SELECT deducciones.id_devengado, deducciones.ibc * 0.085,deducciones.ibc * 0.12,  deducciones.ibc * 0.0052,(deducciones.ibc * 0.085)+(deducciones.ibc * 0.12)+(deducciones.ibc * 0.0052) FROM deducciones INNER JOIN devengados ON deducciones.id_devengado = devengados.id_empleado WHERE deducciones.id_devengado = new.id;
	END IF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamentos`
--

CREATE TABLE `departamentos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devengados`
--

CREATE TABLE `devengados` (
  `id` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `sueldo` decimal(16,4) DEFAULT 1000000.0000,
  `dias_lab` tinyint(3) UNSIGNED DEFAULT 30,
  `valor_horas_total` float DEFAULT NULL,
  `auxilio_transporte` decimal(16,4) DEFAULT NULL,
  `comisiones` decimal(16,4) DEFAULT NULL,
  `total_dev` decimal(16,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `devengados`
--
DELIMITER $$
CREATE TRIGGER `devengados_AI` AFTER INSERT ON `devengados` FOR EACH ROW BEGIN
    DECLARE contrato_t int;
    SET contrato_t = tipo_contrato(new.id);
    IF contrato_t = 2 THEN
    	INSERT INTO deducciones(id_devengado, ibc, salud,fsp,retencion_ef,otras_deduc, pension,total_deducido)
SELECT devengados.id_empleado, (devengados.total_dev - devengados.auxilio_transporte), (devengados.total_dev - devengados.auxilio_transporte) * 0, 0,0,0, (devengados.total_dev - devengados.auxilio_transporte) * 0.064,
(devengados.total_dev - devengados.auxilio_transporte) * 0.064 FROM empleados INNER JOIN devengados ON empleados.id = devengados.id_empleado WHERE empleados.id = new.id;
    ELSE
		INSERT INTO deducciones(id_devengado, ibc, salud,fsp,retencion_ef,otras_deduc, pension,total_deducido)
SELECT devengados.id_empleado, devengados.total_dev - devengados.auxilio_transporte, (devengados.total_dev - devengados.auxilio_transporte) * 0.04, 0,0,0, (devengados.total_dev - devengados.auxilio_transporte) * 0.04,
((devengados.total_dev - devengados.auxilio_transporte) * 0.04) * 2 FROM empleados INNER JOIN devengados ON empleados.id = devengados.id_empleado WHERE empleados.id = new.id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id` int(11) NOT NULL,
  `cedula` char(10) NOT NULL,
  `id_nomina` int(11) DEFAULT NULL,
  `nombre` varchar(30) NOT NULL,
  `apellido` varchar(30) NOT NULL,
  `id_cargo` int(11) NOT NULL,
  `id_departamento` int(11) NOT NULL,
  `id_jornada` int(11) NOT NULL,
  `id_contrato` int(11) NOT NULL,
  `salario_basico` decimal(16,2) DEFAULT NULL,
  `dias_lab` tinyint(3) UNSIGNED DEFAULT NULL,
  `num_horas` tinyint(3) UNSIGNED DEFAULT NULL,
  `valor_horas_total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `empleados`
--
DELIMITER $$
CREATE TRIGGER `empleados_dev` AFTER INSERT ON `empleados` FOR EACH ROW BEGIN
	DECLARE auxilio int;
    DECLARE contrato_t int;
    SET contrato_t = tipo_contrato(new.id);
	IF contrato_t = 2 OR new.salario_basico > 2000000 THEN
    	SET auxilio = 0;
	ELSE
    	SET auxilio = 117172;
    END IF;	
	INSERT INTO devengados(id_empleado, sueldo, dias_lab, valor_horas_total,auxilio_transporte,comisiones, total_dev)
		VALUES(new.id, (new.salario_basico/30)*new.dias_lab, new.dias_lab, new.valor_horas_total, auxilio, 0, ((new.salario_basico/30)*new.dias_lab) + new.valor_horas_total+ auxilio);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `empleados_horas_AI` AFTER INSERT ON `empleados` FOR EACH ROW INSERT INTO horas(id_empleado, num_horas, valor_horas_total)
VALUES(new.id, new.num_horas, new.valor_horas_total)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horas`
--

CREATE TABLE `horas` (
  `id` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `num_horas` tinyint(3) UNSIGNED DEFAULT NULL,
  `valor_horas_total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornadas`
--

CREATE TABLE `jornadas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nominas`
--

CREATE TABLE `nominas` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestaciones_sociales`
--

CREATE TABLE `prestaciones_sociales` (
  `id` int(11) NOT NULL,
  `id_aportes` int(11) NOT NULL,
  `cesantias` decimal(16,4) DEFAULT NULL,
  `intereses_ces` decimal(16,4) DEFAULT NULL,
  `prima` decimal(16,4) DEFAULT NULL,
  `vacaciones` decimal(16,4) DEFAULT NULL,
  `total` decimal(16,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provision_seg_social`
--

CREATE TABLE `provision_seg_social` (
  `id` int(11) NOT NULL,
  `id_deduccion` int(11) NOT NULL,
  `salud` decimal(16,4) DEFAULT NULL,
  `pension` decimal(16,4) DEFAULT NULL,
  `arl` decimal(16,4) DEFAULT NULL,
  `total` decimal(16,4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Disparadores `provision_seg_social`
--
DELIMITER $$
CREATE TRIGGER `provision_seg_social_AI` AFTER INSERT ON `provision_seg_social` FOR EACH ROW BEGIN
	DECLARE contrato_t int;
    SET contrato_t = tipo_contrato(new.id);
    IF contrato_t = 2 THEN
    	INSERT INTO aportes_pfs(id_p_seg_social, caja_comp, icbf, sena, total)
SELECT deducciones.id_devengado, deducciones.ibc *0, deducciones.ibc *0, deducciones.ibc * 0,
deducciones.ibc * 0 FROM deducciones INNER JOIN provision_seg_social ON
deducciones.id_devengado = provision_seg_social.id_deduccion WHERE provision_seg_social.id_deduccion = new.id;
ELSE 
    INSERT INTO aportes_pfs(id_p_seg_social, caja_comp, icbf, sena, total)
    SELECT deducciones.id_devengado, deducciones.ibc * 0.04, deducciones.ibc *0.03, deducciones.ibc * 0.02,
    (deducciones.ibc * 0.04)+(deducciones.ibc *0.03) +(deducciones.ibc * 0.02) FROM deducciones INNER JOIN provision_seg_social ON
    deducciones.id_devengado = provision_seg_social.id_deduccion WHERE provision_seg_social.id_deduccion = new.id;
    END IF;

END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `aportes_pfs`
--
ALTER TABLE `aportes_pfs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_p_seg_social` (`id_p_seg_social`);

--
-- Indices de la tabla `cargos`
--
ALTER TABLE `cargos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `deducciones`
--
ALTER TABLE `deducciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_devengado` (`id_devengado`);

--
-- Indices de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  ADD PRIMARY KEY (`id`,`nombre`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `devengados`
--
ALTER TABLE `devengados`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `id_nomina` (`id_nomina`),
  ADD KEY `id_cargo` (`id_cargo`),
  ADD KEY `id_departamento` (`id_departamento`),
  ADD KEY `id_jornada` (`id_jornada`),
  ADD KEY `id_contrato` (`id_contrato`);

--
-- Indices de la tabla `horas`
--
ALTER TABLE `horas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_empleado` (`id_empleado`);

--
-- Indices de la tabla `jornadas`
--
ALTER TABLE `jornadas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `nominas`
--
ALTER TABLE `nominas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fecha` (`fecha`);

--
-- Indices de la tabla `prestaciones_sociales`
--
ALTER TABLE `prestaciones_sociales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_aportes` (`id_aportes`);

--
-- Indices de la tabla `provision_seg_social`
--
ALTER TABLE `provision_seg_social`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_deduccion` (`id_deduccion`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `aportes_pfs`
--
ALTER TABLE `aportes_pfs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cargos`
--
ALTER TABLE `cargos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `contratos`
--
ALTER TABLE `contratos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `deducciones`
--
ALTER TABLE `deducciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `devengados`
--
ALTER TABLE `devengados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `horas`
--
ALTER TABLE `horas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `jornadas`
--
ALTER TABLE `jornadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `nominas`
--
ALTER TABLE `nominas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `prestaciones_sociales`
--
ALTER TABLE `prestaciones_sociales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `provision_seg_social`
--
ALTER TABLE `provision_seg_social`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `aportes_pfs`
--
ALTER TABLE `aportes_pfs`
  ADD CONSTRAINT `aportes_pfs_ibfk_1` FOREIGN KEY (`id_p_seg_social`) REFERENCES `provision_seg_social` (`id`);

--
-- Filtros para la tabla `deducciones`
--
ALTER TABLE `deducciones`
  ADD CONSTRAINT `deducciones_ibfk_1` FOREIGN KEY (`id_devengado`) REFERENCES `devengados` (`id`);

--
-- Filtros para la tabla `devengados`
--
ALTER TABLE `devengados`
  ADD CONSTRAINT `devengados_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`);

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`id_nomina`) REFERENCES `nominas` (`id`),
  ADD CONSTRAINT `empleados_ibfk_2` FOREIGN KEY (`id_cargo`) REFERENCES `cargos` (`id`),
  ADD CONSTRAINT `empleados_ibfk_3` FOREIGN KEY (`id_departamento`) REFERENCES `departamentos` (`id`),
  ADD CONSTRAINT `empleados_ibfk_4` FOREIGN KEY (`id_jornada`) REFERENCES `jornadas` (`id`),
  ADD CONSTRAINT `empleados_ibfk_5` FOREIGN KEY (`id_contrato`) REFERENCES `contratos` (`id`);

--
-- Filtros para la tabla `horas`
--
ALTER TABLE `horas`
  ADD CONSTRAINT `horas_ibfk_1` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`);

--
-- Filtros para la tabla `prestaciones_sociales`
--
ALTER TABLE `prestaciones_sociales`
  ADD CONSTRAINT `prestaciones_sociales_ibfk_1` FOREIGN KEY (`id_aportes`) REFERENCES `aportes_pfs` (`id`);

--
-- Filtros para la tabla `provision_seg_social`
--
ALTER TABLE `provision_seg_social`
  ADD CONSTRAINT `provision_seg_social_ibfk_1` FOREIGN KEY (`id_deduccion`) REFERENCES `deducciones` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
