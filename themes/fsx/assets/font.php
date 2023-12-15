<?php

header("Content-Type: font/ttf");
$fontName = $_GET["name"] ?? "";
header("Content-Disposition: attachment; filename=$fontName.ttf");
header("Pragma: no-cache");
header("Expires: 0");
$path = $_GET["path"] ?? "";

readfile(__DIR__ . "/font/$path/$fontName.ttf");
