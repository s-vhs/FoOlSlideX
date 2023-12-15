<?php

require_once ROOT . "autoload.php";
header("Content-Type: application/json; charset=utf-8");

$resp = [
    "done" => false,
    "msg" => "Error",
];

if (!$logged || $user["level"] > 15) {
    die(json_encode($resp));
}

switch ($action) {
    case "title":
        switch ($mode) {
            case "delete_title":
                //TODO, but should be preeetty easy haha
                break;
            case "edit_title":
            case "add_title":
                if ($user["level"] > 14) { // Checks if user can add titles, if not die()
                    die(json_encode($resp));
                }

                // Definitions
                $id = isset($_POST["id"]) ? (string) $_POST["id"] : null;
                $cover = isset($_POST["cover"]) ? clean($_POST["cover"]) : "";
                $title = isset($_POST["title"]) ? clean($_POST["title"]) : "";
                $alts = isset($_POST["alts"]) ? clean($_POST["alts"]) : "";
                $authors = isset($_POST["authors"]) ? clean($_POST["authors"]) : "";
                $artists = isset($_POST["artists"]) ? clean($_POST["artists"]) : "";
                $lang = isset($_POST["lang"]) ? clean($_POST["lang"]) : "";
                $originalStatus = isset($_POST["originalStatus"]) && is_numeric($_POST["originalStatus"]) ? (int) $_POST["originalStatus"] : 2;
                $uploadStatus = isset($_POST["uploadStatus"]) && is_numeric($_POST["uploadStatus"]) ? (int) $_POST["uploadStatus"] : 2;
                $release = isset($_POST["release"]) && is_numeric($_POST["release"]) ? (int) $_POST["release"] : date("Y");
                $completion = isset($_POST["completion"]) && is_numeric($_POST["completion"]) ? (int) $_POST["completion"] : date("Y");
                $summary = isset($_POST["summary"]) ? $_POST["summary"] : "";

                $formats = isset($_POST["format"]) && is_array($_POST["format"]) ? $_POST["format"] : [];
                $warnings = isset($_POST["warnings"]) && is_array($_POST["warnings"]) ? $_POST["warnings"] : [];
                $themes = isset($_POST["theme"]) && is_array($_POST["theme"]) ? $_POST["theme"] : [];
                $genres = isset($_POST["genre"]) && is_array($_POST["genre"]) ? $_POST["genre"] : [];
                $demographics = isset($_POST["demographic"]) && is_array($_POST["demographic"]) ? $_POST["demographic"] : [];

                if (empty($title)) {
                    die(json_encode(["done" => false, "msg" => "Requires Title."]));
                }

                if (empty($lang)) {
                    die(json_encode(["done" => false, "msg" => "Requires Lang."]));
                }

                $originalStatus = in_array($originalStatus, [1, 2, 3, 4, 5]) ? $originalStatus : 2;
                $uploadStatus = in_array($uploadStatus, [1, 2, 3, 4, 5]) ? $uploadStatus : 2;
                $release = (strlen($release) === 4) ? $release : date("Y");

                processAndTrimArray($formats);
                processAndTrimArray($warnings);
                processAndTrimArray($themes);
                processAndTrimArray($genres);
                processAndTrimArray($demographics);

                // Check if ID is null or not
                if (is_null($id)) {
                    $check = $db["projects"]->findOneBy(["title", "==", $title]);
                    if (!empty($check)) {
                        die(json_encode(["done" => false, "msg" => "There is already a project with that title."]));
                    }
                } else {
                    if (is_numeric($id)) {
                        $check = $db["projects"]->findById($id);
                    } else {
                        $check = $db["projects"]->findOneBy(["uid", "==", $id]);
                    }
                    if (empty($check)) {
                        die(json_encode(["done" => false, "msg" => "ID is invalid."]));
                    }
                }

                // Ensure the covers directory exists
                $coversDirectory = ROOT . "assets/covers";
                if (!file_exists($coversDirectory)) {
                    mkdir($coversDirectory, 0777, true);
                }

                // Process cover file, if provided
                if (!empty($cover)) {
                    $oldFilePath = ROOT . "assets/tmp/{$cover}";
                    if (file_exists($oldFilePath)) {
                        $coverHash = md5_file($oldFilePath);
                        $ext = pathinfo($oldFilePath, PATHINFO_EXTENSION);
                        $cover = $coverHash . "." . $ext;
                        $newFilePath = ROOT . "assets/covers/{$cover}";
                        rename($oldFilePath, $newFilePath);
                    }
                }
                if (!empty($cover)) {
                    $finalCover = $cover;
                } elseif (!empty($check)) {
                    $finalCover = $check["cover"];
                } else {
                    $finalCover = "";
                }

                $data = [
                    "cover" => $finalCover,
                    "title" => $title,
                    "alts" => $alts,
                    "authors" => $authors,
                    "artists" => $artists,
                    "lang" => $lang,
                    "summary" => $summary,
                    "status" => [
                        "original" => $originalStatus,
                        "upload" => $uploadStatus,
                    ],
                    "years" => [
                        "release" => $release,
                        "completion" => $completion,
                    ],
                    "tags" => [
                        "format" => $formats,
                        "genre" => $genres,
                        "theme" => $themes,
                        "warnings" => $warnings,
                        "demographic" => $demographics,
                    ],
                    "updated" => [
                        "user" => $user["id"],
                        "timestamp" => now(),
                    ],
                    "public" => true,
                ];

                if (is_null($id)) {
                    $data["creator"] = $user["id"];
                    $data["timestamp"] = now();
                    $data["uid"] = genUuid();
                } else {
                    $data["id"] = $id;
                    $title = $db["projects"]->findById($id);
                    $data["uid"] = $title["uid"];
                }

                if (!empty($cover)) {
                    $data["cover"] = $cover;
                }

                $res = $db["projects"]->updateOrInsert($data);

                $resp["done"] = true;
                $resp["msg"] = "Created!";
                $resp["url"] = "{$config["url"]}project/{$res["id"]}/" . cat($data["title"]);
                break;
            default:
                // Huh?
                $resp["msg"] = "Index...!";
                break;
        }
        break;
    case "default":
        $resp["msg"] = "Index...?";
        break;
}

die(json_encode($resp));
