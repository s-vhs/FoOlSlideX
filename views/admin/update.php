<?php

require_once ROOT . "autoload.php";
$smarty->assign("pageTitle", titlify("Admin - Update-Center", $config["divider"], $config["title"]));

if (!$logged || $user["level"] > 10) {
    header("Location: {$config["url"]}");
    die("No u");
}

$kengine = [
    "gitver" => file_get_contents("https://raw.githubusercontent.com/H33Tx/KEngine/master/version.txt"),
    "devver" => file_get_contents("https://raw.githubusercontent.com/H33Tx/KEngine/dev/version.txt"),
];

$foolslidex = [
    "version" => file_get_contents(ROOT . "system/themes/FoOlSlideX/version.txt"),
    "gitver" => file_get_contents("https://raw.githubusercontent.com/saintly2k/FoOlSlideX/master/version.txt"),
    "devver" => file_get_contents("https://raw.githubusercontent.com/saintly2k/FoOlSlideX/dev/version.txt"),
];

$smarty->assign("kengine", $kengine);
$smarty->assign("foolslidex", $foolslidex);

$smarty->display("parts/head.tpl");
$smarty->display("parts/header.tpl");

$smarty->display("pages/admin/update.tpl");

$smarty->display("parts/footer.tpl");
$smarty->display("parts/foot.tpl");
