-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-05-2022 a las 01:28:40
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
  `caja_comp` float DEFAULT NULL,
  `icbf` float DEFAULT NULL,
  `sena` float DEFAULT NULL,
  `total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `aportes_pfs`
--

INSERT INTO `aportes_pfs` (`id`, `id_p_seg_social`, `caja_comp`, `icbf`, `sena`, `total`) VALUES
(1, 1, 1003000, 752250, 501500, 2256750),
(2, 2, 336333, 252250, 168167, 756750),
(3, 3, 403000, 302250, 201500, 906750),
(4, 4, 604375, 453281, 302188, 1359840),
(5, 5, 604375, 453281, 302188, 1359840),
(6, 6, 604375, 453281, 302188, 1359840),
(7, 7, 504375, 378281, 252188, 1134840);

--
-- Disparadores `aportes_pfs`
--
DELIMITER $$
CREATE TRIGGER `aportes_pfs_AI` AFTER INSERT ON `aportes_pfs` FOR EACH ROW INSERT INTO prestaciones_sociales(id_aportes, cesantias, intereses_ces, prima, vacaciones, total)
SELECT devengados.id_empleado, devengados.total_dev * 0.833, devengados.total_dev * 0.1, devengados.total_dev * 0.833, (devengados.total_dev 
- devengados.auxilio_transporte - devengados.valor_horas_total) * 0.417,  (devengados.total_dev * 0.833) + (devengados.total_dev * 0.1) +(devengados.total_dev * 0.833) + ((devengados.total_dev 
- devengados.auxilio_transporte - devengados.valor_horas_total) * 0.417) FROM devengados INNER JOIN deducciones ON devengados.id_empleado = deducciones.id_devengado WHERE deducciones.id_devengado = new.id
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

--
-- Volcado de datos para la tabla `cargos`
--

INSERT INTO `cargos` (`id`, `nombre`) VALUES
(1, 'Back-end');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contratos`
--

CREATE TABLE `contratos` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `contratos`
--

INSERT INTO `contratos` (`id`, `nombre`) VALUES
(1, 'Indefinido');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `deducciones`
--

CREATE TABLE `deducciones` (
  `id` int(11) NOT NULL,
  `id_devengado` int(11) NOT NULL,
  `ibc` float NOT NULL,
  `salud` float DEFAULT NULL,
  `fsp` float DEFAULT NULL,
  `retencion_ef` float DEFAULT NULL,
  `otras_deduc` float DEFAULT NULL,
  `pension` float DEFAULT NULL,
  `total_deducido` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `deducciones`
--

INSERT INTO `deducciones` (`id`, `id_devengado`, `ibc`, `salud`, `fsp`, `retencion_ef`, `otras_deduc`, `pension`, `total_deducido`) VALUES
(1, 1, 2507500, 1003000, 0, 0, 0, 1003000, 2006000),
(2, 2, 840833, 336333, 0, 0, 0, 336333, 672667),
(3, 3, 1007500, 403000, 0, 0, 0, 403000, 806000),
(4, 4, 1510940, 604375, 0, 0, 0, 604375, 1208750),
(5, 5, 1510940, 604375, 0, 0, 0, 604375, 1208750),
(6, 6, 1510940, 604375, 0, 0, 0, 604375, 1208750),
(7, 7, 1260940, 504375, 0, 0, 0, 504375, 1008750);

--
-- Disparadores `deducciones`
--
DELIMITER $$
CREATE TRIGGER `deducciones_AI` AFTER INSERT ON `deducciones` FOR EACH ROW INSERT INTO provision_seg_social(id_deduccion,salud, pension, arl, total)
SELECT deducciones.id_devengado, deducciones.ibc * 0.85,deducciones.ibc * 0.12,  deducciones.ibc * 0.052,(deducciones.ibc * 0.85)+(deducciones.ibc * 0.12) FROM deducciones INNER JOIN devengados ON deducciones.id_devengado = devengados.id_empleado WHERE deducciones.id_devengado = new.id
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

--
-- Volcado de datos para la tabla `departamentos`
--

INSERT INTO `departamentos` (`id`, `nombre`) VALUES
(1, 'Desarrollo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `devengados`
--

CREATE TABLE `devengados` (
  `id` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `sueldo` decimal(11,2) DEFAULT 1000000.00,
  `dias_lab` tinyint(3) UNSIGNED DEFAULT 30,
  `valor_horas_total` float DEFAULT NULL,
  `auxilio_transporte` float DEFAULT NULL,
  `comisiones` float DEFAULT NULL,
  `total_dev` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `devengados`
--

INSERT INTO `devengados` (`id`, `id_empleado`, `sueldo`, `dias_lab`, `valor_horas_total`, `auxilio_transporte`, `comisiones`, `total_dev`) VALUES
(1, 1, '2500000.00', 25, 7500, 0, 0, 2507500),
(2, 2, '833333.33', 25, 7500, 117.172, 0, 840950),
(3, 3, '1000000.00', 30, 7500, 117.172, 0, 1007620),
(4, 4, '1500000.00', 30, 10938, 117.172, 0, 1511060),
(5, 5, '1500000.00', 30, 10938, 117.172, 0, 1511060),
(6, 6, '1500000.00', 30, 10938, 117.172, 0, 1511060),
(7, 7, '1250000.00', 25, 10938, 117.172, 0, 1261060);

--
-- Disparadores `devengados`
--
DELIMITER $$
CREATE TRIGGER `devengados_AI` AFTER INSERT ON `devengados` FOR EACH ROW INSERT INTO deducciones(id_devengado, ibc, salud,fsp,retencion_ef,otras_deduc, pension,total_deducido)
SELECT devengados.id_empleado, devengados.total_dev - devengados.auxilio_transporte, (devengados.total_dev - devengados.auxilio_transporte) * 0.4, 0,0,0, (devengados.total_dev - devengados.auxilio_transporte) * 0.4,
((devengados.total_dev - devengados.auxilio_transporte) * 0.4) * 2 FROM empleados INNER JOIN devengados ON empleados.id = devengados.id_empleado WHERE empleados.id = new.id
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
  `salario_basico` decimal(11,2) DEFAULT NULL,
  `dias_lab` tinyint(3) UNSIGNED DEFAULT NULL,
  `num_horas` tinyint(3) UNSIGNED DEFAULT NULL,
  `valor_horas_total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id`, `cedula`, `id_nomina`, `nombre`, `apellido`, `id_cargo`, `id_departamento`, `id_jornada`, `id_contrato`, `salario_basico`, `dias_lab`, `num_horas`, `valor_horas_total`) VALUES
(1, '1095298369', 1, 'David', 'Olaya', 1, 1, 1, 1, '3000000.00', 25, 2, 7500),
(2, '1095298370', 1, 'Daniel', 'Olaya', 1, 1, 1, 1, '1000000.00', 25, 2, 7500),
(3, '1095298371', 1, 'Daniel', 'Perez', 1, 1, 1, 1, '1000000.00', 30, 2, 7500),
(4, '1095298379', 1, 'Juan', 'Olaya', 1, 1, 1, 1, '1500000.00', 30, 2, 10938),
(5, '1095298382', 1, 'Marcos', 'Olaya', 1, 1, 1, 1, '1500000.00', 30, 2, 10938),
(6, '1023431213', 1, 'Nicolas', 'Camargo', 1, 1, 1, 1, '1500000.00', 30, 2, 10938),
(7, '1232431043', 1, 'Sergio', 'Leon', 1, 1, 1, 1, '1500000.00', 25, 3, 10938);

--
-- Disparadores `empleados`
--
DELIMITER $$
CREATE TRIGGER `empleados_dev` AFTER INSERT ON `empleados` FOR EACH ROW BEGIN
	DECLARE auxilio float;
	IF(new.salario_basico > 2000000) THEN
		SET auxilio = 0;
	ELSE
		SET auxilio = 117.172;
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

--
-- Volcado de datos para la tabla `horas`
--

INSERT INTO `horas` (`id`, `id_empleado`, `num_horas`, `valor_horas_total`) VALUES
(1, 1, 2, 7500),
(2, 2, 2, 7500),
(3, 3, 2, 7500),
(4, 4, 2, 10938),
(5, 5, 2, 10938),
(6, 6, 2, 10938),
(7, 7, 3, 10938);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jornadas`
--

CREATE TABLE `jornadas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `jornadas`
--

INSERT INTO `jornadas` (`id`, `nombre`) VALUES
(1, 'Diurna');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `nominas`
--

CREATE TABLE `nominas` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `nominas`
--

INSERT INTO `nominas` (`id`, `fecha`) VALUES
(1, '2022-02-24');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `prestaciones_sociales`
--

CREATE TABLE `prestaciones_sociales` (
  `id` int(11) NOT NULL,
  `id_aportes` int(11) NOT NULL,
  `cesantias` float DEFAULT NULL,
  `intereses_ces` float DEFAULT NULL,
  `prima` float DEFAULT NULL,
  `vacaciones` float DEFAULT NULL,
  `total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `prestaciones_sociales`
--

INSERT INTO `prestaciones_sociales` (`id`, `id_aportes`, `cesantias`, `intereses_ces`, `prima`, `vacaciones`, `total`) VALUES
(1, 1, 2088750, 250750, 2088750, 1042500, 5470740),
(2, 2, 700512, 84095, 700512, 347500, 1832620),
(3, 3, 839345, 100762, 839345, 417000, 2196450),
(4, 4, 1258710, 151106, 1258710, 625500, 3294020),
(5, 5, 1258710, 151106, 1258710, 625500, 3294020),
(6, 6, 1258710, 151106, 1258710, 625500, 3294020),
(7, 7, 1050460, 126106, 1050460, 521250, 2748270);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provision_seg_social`
--

CREATE TABLE `provision_seg_social` (
  `id` int(11) NOT NULL,
  `id_deduccion` int(11) NOT NULL,
  `salud` float DEFAULT NULL,
  `pension` float DEFAULT NULL,
  `arl` float DEFAULT NULL,
  `total` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `provision_seg_social`
--

INSERT INTO `provision_seg_social` (`id`, `id_deduccion`, `salud`, `pension`, `arl`, `total`) VALUES
(1, 1, 2131380, 300900, 130390, 2432280),
(2, 2, 714708, 100900, 43723.3, 815608),
(3, 3, 856375, 120900, 52390, 977275),
(4, 4, 1284300, 181313, 78568.8, 1465610),
(5, 5, 1284300, 181313, 78568.8, 1465610),
(6, 6, 1284300, 181313, 78568.8, 1465610),
(7, 7, 1071800, 151313, 65568.8, 1223110);

--
-- Disparadores `provision_seg_social`
--
DELIMITER $$
CREATE TRIGGER `provision_seg_social_AI` AFTER INSERT ON `provision_seg_social` FOR EACH ROW INSERT INTO aportes_pfs(id_p_seg_social, caja_comp, icbf, sena, total)
SELECT deducciones.id_devengado, deducciones.ibc * 0.4, deducciones.ibc *0.3, deducciones.ibc * 0.2,
(deducciones.ibc * 0.4)+(deducciones.ibc *0.3) +(deducciones.ibc * 0.2) FROM deducciones INNER JOIN provision_seg_social ON
deducciones.id_devengado = provision_seg_social.id_deduccion WHERE provision_seg_social.id_deduccion = new.id
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `cargos`
--
ALTER TABLE `cargos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `contratos`
--
ALTER TABLE `contratos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `deducciones`
--
ALTER TABLE `deducciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `departamentos`
--
ALTER TABLE `departamentos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `devengados`
--
ALTER TABLE `devengados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `horas`
--
ALTER TABLE `horas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `jornadas`
--
ALTER TABLE `jornadas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `nominas`
--
ALTER TABLE `nominas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `prestaciones_sociales`
--
ALTER TABLE `prestaciones_sociales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `provision_seg_social`
--
ALTER TABLE `provision_seg_social`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
